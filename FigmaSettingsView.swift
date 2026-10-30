import SwiftUI

/// Settings view for configuring Figma integration
struct FigmaSettingsView: View {
    @State private var apiToken: String = ""
    @State private var fileKey: String = ""
    @State private var showingSaveSuccess = false
    @State private var errorMessage: String?
    @State private var hasExistingToken = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("To use Figma integration, you need a personal access token from Figma.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Link("Get your Figma token", destination: URL(string: "https://www.figma.com/developers/api#access-tokens")!)
                        .font(.callout)
                } header: {
                    Text("About")
                }
                
                Section {
                    if hasExistingToken {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("API Token saved")
                            Spacer()
                            Button("Update") {
                                hasExistingToken = false
                            }
                            .buttonStyle(.bordered)
                        }
                    } else {
                        SecureField("Figma API Token", text: $apiToken)
                            .textContentType(.password)
                            .autocorrectionDisabled()
                        
                        Button("Save Token") {
                            saveAPIToken()
                        }
                        .disabled(apiToken.isEmpty)
                    }
                } header: {
                    Text("API Configuration")
                } footer: {
                    Text("Your token is stored securely in the Keychain")
                        .font(.caption)
                }
                
                Section {
                    TextField("File Key (from Figma URL)", text: $fileKey)
                        .autocorrectionDisabled()
                    
                    Text("Example: https://www.figma.com/file/YOUR_FILE_KEY/...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if !fileKey.isEmpty {
                        NavigationLink("View This Design") {
                            if let token = try? FigmaConfiguration.shared.getAPIToken() {
                                FigmaDesignView(
                                    apiToken: token,
                                    fileKey: fileKey
                                )
                            } else {
                                Text("Please configure your API token first")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .disabled(!hasExistingToken)
                    }
                } header: {
                    Text("Test File")
                }
                
                if hasExistingToken {
                    Section {
                        Button("Remove Token", role: .destructive) {
                            removeAPIToken()
                        }
                    }
                }
            }
            .navigationTitle("Figma Settings")
            .onAppear {
                hasExistingToken = FigmaConfiguration.shared.hasAPIToken()
                fileKey = UserDefaults.standard.lastFigmaFileKey ?? ""
            }
            .alert("Success", isPresented: $showingSaveSuccess) {
                Button("OK") { }
            } message: {
                Text("Figma API token saved successfully")
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    private func saveAPIToken() {
        do {
            try FigmaConfiguration.shared.saveAPIToken(apiToken)
            hasExistingToken = true
            apiToken = ""
            showingSaveSuccess = true
            
            // Save the file key for quick access
            if !fileKey.isEmpty {
                UserDefaults.standard.lastFigmaFileKey = fileKey
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func removeAPIToken() {
        do {
            try FigmaConfiguration.shared.deleteAPIToken()
            hasExistingToken = false
            apiToken = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    FigmaSettingsView()
}
