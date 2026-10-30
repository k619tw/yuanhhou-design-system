import SwiftUI
import Combine

/// View for displaying Figma designs
struct FigmaDesignView: View {
    /// Builds a SwiftUI image from raw data on both iOS and macOS.
    private static func image(from data: Data) -> Image? {
        #if canImport(UIKit)
        UIImage(data: data).map(Image.init(uiImage:))
        #else
        NSImage(data: data).map(Image.init(nsImage:))
        #endif
    }

    @StateObject private var viewModel: FigmaDesignViewModel
    let fileKey: String
    let nodesToDisplay: [String]?
    
    init(apiToken: String, fileKey: String, nodesToDisplay: [String]? = nil) {
        self.fileKey = fileKey
        self.nodesToDisplay = nodesToDisplay
        _viewModel = StateObject(wrappedValue: FigmaDesignViewModel(apiToken: apiToken))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading Figma design...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text("Error loading design")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadDesign(fileKey: fileKey, nodeIds: nodesToDisplay)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if let file = viewModel.figmaFile {
                    VStack(alignment: .leading, spacing: 16) {
                        // File header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(file.name)
                                .font(.title)
                                .bold()
                            Text("Last modified: \(file.lastModified)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Images
                        if !viewModel.downloadedImages.isEmpty {
                            Text("Design Components")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(Array(viewModel.downloadedImages.keys.sorted()), id: \.self) { nodeId in
                                if let imageData = viewModel.downloadedImages[nodeId],
                                   let image = Self.image(from: imageData) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Node: \(nodeId)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(radius: 4)
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                        // Document tree (collapsible)
                        DisclosureGroup("Document Structure") {
                            FigmaNodeTreeView(node: file.document)
                                .padding(.vertical, 8)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadDesign(fileKey: fileKey, nodeIds: nodesToDisplay)
        }
        .refreshable {
            await viewModel.loadDesign(fileKey: fileKey, nodeIds: nodesToDisplay)
        }
    }
}

/// Recursive view for displaying Figma node hierarchy
struct FigmaNodeTreeView: View {
    let node: FigmaNode
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: nodeIcon)
                    .foregroundStyle(.blue)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(node.name)
                        .font(.subheadline)
                    Text(node.type)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if let children = node.children, !children.isEmpty {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded, let children = node.children {
                ForEach(children.indices, id: \.self) { index in
                    FigmaNodeTreeView(node: children[index])
                        .padding(.leading, 20)
                }
            }
        }
    }
    
    private var nodeIcon: String {
        switch node.type.lowercased() {
        case "frame": return "rectangle"
        case "text": return "textformat"
        case "rectangle": return "square"
        case "group": return "square.stack"
        case "component": return "cube.box"
        case "instance": return "doc.on.doc"
        default: return "circle"
        }
    }
}

/// ViewModel for managing Figma design data
@MainActor
class FigmaDesignViewModel: ObservableObject {
    @Published var figmaFile: FigmaFile?
    @Published var downloadedImages: [String: Data] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let figmaService: FigmaService
    
    init(apiToken: String) {
        self.figmaService = FigmaService(apiToken: apiToken)
    }
    
    func loadDesign(fileKey: String, nodeIds: [String]?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch file metadata
            figmaFile = try await figmaService.fetchFile(fileKey: fileKey)
            
            // If specific nodes are requested, fetch their images
            if let nodeIds = nodeIds, !nodeIds.isEmpty {
                let images = try await figmaService.fetchImages(
                    fileKey: fileKey,
                    nodeIds: nodeIds,
                    scale: 2.0,
                    format: .png
                )
                
                // Download each image
                for (nodeId, imageUrl) in images.images {
                    do {
                        let imageData = try await figmaService.downloadImage(from: imageUrl)
                        downloadedImages[nodeId] = imageData
                    } catch {
                        print("Failed to download image for node \(nodeId): \(error)")
                    }
                }
            }
            
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    // Preview with dummy data - replace with your actual Figma file key and API token
    FigmaDesignView(
        apiToken: "figd_PNaXygxEsNmN2dMg5szBh3sFiOGtSAYR0LfyLOnl",
        fileKey: "5iR1wP3qoTT4uD6d20ekVv"
    )
}
