import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var showingFigmaSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "figma.logo")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Figma Integration Demo")
                    .font(.title)
                    .bold()
                
                Text("Connect your Figma designs to this app")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button {
                        showingFigmaSettings = true
                    } label: {
                        Label("Configure Figma", systemImage: "gearshape.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    if FigmaConfiguration.shared.hasAPIToken() {
                        if let lastFileKey = UserDefaults.standard.lastFigmaFileKey,
                           !lastFileKey.isEmpty {
                            NavigationLink {
                                if let token = try? FigmaConfiguration.shared.getAPIToken() {
                                    FigmaDesignView(
                                        apiToken: token,
                                        fileKey: lastFileKey
                                    )
                                }
                            } label: {
                                Label("View Last Design", systemImage: "arrow.right.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        }
                    }
                }
                .padding()
            }
            .padding()
            .sheet(isPresented: $showingFigmaSettings) {
                FigmaSettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
