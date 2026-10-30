import Foundation
import Combine

/// Service for interacting with the Figma API
@MainActor
class FigmaService: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.figma.com/v1"
    private var apiToken: String
    
    init(apiToken: String) {
        self.apiToken = apiToken
    }
    
    // MARK: - File Operations
    
    /// Fetch a Figma file by its key
    func fetchFile(fileKey: String) async throws -> FigmaFile {
        let endpoint = "\(baseURL)/files/\(fileKey)"
        return try await performRequest(endpoint: endpoint)
    }
    
    /// Fetch images from a Figma file
    func fetchImages(fileKey: String, nodeIds: [String], scale: Double = 1.0, format: ImageFormat = .png) async throws -> FigmaImages {
        let nodeIdsString = nodeIds.joined(separator: ",")
        let endpoint = "\(baseURL)/images/\(fileKey)?ids=\(nodeIdsString)&scale=\(scale)&format=\(format.rawValue)"
        return try await performRequest(endpoint: endpoint)
    }
    
    /// Download an image from a URL
    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw FigmaError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FigmaError.networkError
        }
        
        return data
    }
    
    /// Fetch file nodes (specific components or frames)
    func fetchNodes(fileKey: String, nodeIds: [String]) async throws -> FigmaNodes {
        let nodeIdsString = nodeIds.joined(separator: ",")
        let endpoint = "\(baseURL)/files/\(fileKey)/nodes?ids=\(nodeIdsString)"
        return try await performRequest(endpoint: endpoint)
    }
    
    /// Fetch project files
    func fetchProjectFiles(projectId: String) async throws -> FigmaProjectFiles {
        let endpoint = "\(baseURL)/projects/\(projectId)/files"
        return try await performRequest(endpoint: endpoint)
    }
    
    // MARK: - Private Helpers
    
    private func performRequest<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw FigmaError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiToken, forHTTPHeaderField: "X-Figma-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FigmaError.networkError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(FigmaErrorResponse.self, from: data) {
                throw FigmaError.apiError(errorResponse.message)
            }
            throw FigmaError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw FigmaError.decodingError(error.localizedDescription)
        }
    }
}

// MARK: - Models

struct FigmaFile: Codable {
    let name: String
    let lastModified: String
    let thumbnailUrl: String?
    let version: String
    let document: FigmaNode
}

struct FigmaNode: Codable {
    let id: String
    let name: String
    let type: String
    let children: [FigmaNode]?
    
    // Visual properties
    let backgroundColor: FigmaColor?
    let absoluteBoundingBox: BoundingBox?
    
    // Text properties
    let characters: String?
    let style: TextStyle?
}

struct FigmaColor: Codable {
    let r: Double
    let g: Double
    let b: Double
    let a: Double
}

struct BoundingBox: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

struct TextStyle: Codable {
    let fontFamily: String?
    let fontSize: Double?
    let fontWeight: Int?
    let lineHeightPx: Double?
}

struct FigmaImages: Codable {
    let err: String?
    let images: [String: String]
}

struct FigmaNodes: Codable {
    let name: String
    let nodes: [String: FigmaNodeWrapper]
}

struct FigmaNodeWrapper: Codable {
    let document: FigmaNode
}

struct FigmaProjectFiles: Codable {
    let files: [FigmaFileReference]
}

struct FigmaFileReference: Codable {
    let key: String
    let name: String
    let thumbnailUrl: String?
    let lastModified: String
}

struct FigmaErrorResponse: Codable {
    let status: Int
    let message: String
}

// MARK: - Enums

enum ImageFormat: String {
    case jpg
    case png
    case svg
    case pdf
}

enum FigmaError: LocalizedError {
    case invalidURL
    case networkError
    case httpError(Int)
    case apiError(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network error occurred"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .apiError(let message):
            return "Figma API error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}
