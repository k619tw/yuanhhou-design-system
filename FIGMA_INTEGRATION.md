# Figma Integration Guide

## Overview
This app now includes full Figma API integration, allowing you to fetch and display designs directly from Figma.

## Setup Instructions

### 1. Get Your Figma API Token
1. Go to [Figma Account Settings](https://www.figma.com/developers/api#access-tokens)
2. Log in to your Figma account
3. Navigate to "Personal Access Tokens"
4. Click "Generate new token"
5. Give it a name (e.g., "MyApp Integration")
6. Copy the token (you won't be able to see it again!)

### 2. Configure the App
1. Open the app
2. Tap "Configure Figma"
3. Paste your API token
4. Optionally enter a Figma file key to test

### 3. Find Your File Key
The file key is in the Figma URL:
```
https://www.figma.com/file/YOUR_FILE_KEY_HERE/File-Name
                              ^^^^^^^^^^^^^^^^^^
```

## Usage Examples

### Basic Usage - Display a Figma File

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        FigmaDesignView(
            apiToken: "your-token-here",
            fileKey: "your-file-key-here"
        )
    }
}
```

### Display Specific Nodes (Components/Frames)

```swift
FigmaDesignView(
    apiToken: "your-token-here",
    fileKey: "your-file-key-here",
    nodesToDisplay: ["123:456", "789:012"]  // Node IDs from Figma
)
```

### Advanced - Custom Integration

```swift
import SwiftUI

struct CustomFigmaView: View {
    @StateObject private var viewModel = FigmaDesignViewModel(
        apiToken: "your-token-here"
    )
    
    var body: some View {
        VStack {
            if let file = viewModel.figmaFile {
                Text(file.name)
                    .font(.title)
                
                // Display custom UI based on Figma data
            }
        }
        .task {
            await viewModel.loadDesign(
                fileKey: "your-file-key",
                nodeIds: nil
            )
        }
    }
}
```

### Using the Service Directly

```swift
let service = FigmaService(apiToken: "your-token")

// Fetch file metadata
let file = try await service.fetchFile(fileKey: "abc123")

// Get images for specific nodes
let images = try await service.fetchImages(
    fileKey: "abc123",
    nodeIds: ["1:2", "3:4"],
    scale: 2.0,
    format: .png
)

// Download an image
for (nodeId, imageUrl) in images.images {
    let imageData = try await service.downloadImage(from: imageUrl)
    // Use imageData...
}
```

## Features

### ✅ Implemented
- Fetch Figma files and metadata
- Download design images (PNG, JPG, SVG, PDF)
- Display document structure/hierarchy
- Secure token storage in Keychain
- Settings UI for configuration
- Error handling and loading states
- Pull-to-refresh support
- Async/await API

### 🎯 Available Figma Data
- File name and version
- Last modified date
- Document structure (frames, components, text, etc.)
- Node properties (colors, fonts, dimensions)
- Rendered images of any node

## API Reference

### FigmaService
Main service class for API calls.

**Methods:**
- `fetchFile(fileKey:)` - Get file metadata
- `fetchImages(fileKey:nodeIds:scale:format:)` - Get rendered images
- `downloadImage(from:)` - Download image data
- `fetchNodes(fileKey:nodeIds:)` - Get specific nodes
- `fetchProjectFiles(projectId:)` - List project files

### FigmaDesignView
SwiftUI view for displaying Figma designs.

**Parameters:**
- `apiToken` - Your Figma API token
- `fileKey` - The file key from Figma URL
- `nodesToDisplay` - Optional array of node IDs to render

### FigmaConfiguration
Secure configuration management.

**Methods:**
- `saveAPIToken(_:)` - Save token to Keychain
- `getAPIToken()` - Retrieve token from Keychain
- `deleteAPIToken()` - Remove token
- `hasAPIToken()` - Check if token exists

## Finding Node IDs

To get node IDs from Figma:
1. Select a frame/component in Figma
2. Right-click → "Copy/Paste as" → "Copy link"
3. The URL will contain the node ID: `?node-id=123-456`
4. Use format "123:456" in the app

## Security Notes

- API tokens are stored in the Keychain (not UserDefaults)
- Never commit tokens to version control
- Consider using environment variables for development
- Tokens have full access to your Figma files - keep them secure

## Troubleshooting

### "Invalid URL" Error
- Check that your file key is correct
- Ensure it doesn't contain extra characters or spaces

### "HTTP 403" Error
- Verify your API token is valid
- Check that you have access to the file
- Token may have been revoked in Figma settings

### "HTTP 404" Error
- File key is incorrect or file doesn't exist
- You may not have permission to access the file

### Images Not Loading
- Check node IDs are in correct format ("123:456")
- Ensure the nodes exist in the file
- Try with a smaller number of nodes first

## Next Steps

Consider adding:
- Image caching for better performance
- Export design tokens (colors, typography)
- Component library browser
- Design system documentation generator
- Figma plugin integration for deeper control

## Resources

- [Figma API Documentation](https://www.figma.com/developers/api)
- [Figma REST API Reference](https://www.figma.com/developers/api#files)
- [Get Personal Access Tokens](https://www.figma.com/developers/api#access-tokens)
