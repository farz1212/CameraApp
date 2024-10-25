//
//  VideoThumbnailView.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-25.
//

import SwiftUICore
import AVFoundation

struct VideoThumbnailView: View {
    var videoURL: URL
    @State private var thumbnailImage: Image? // To store the thumbnail image

    var body: some View {
        VStack {
            if let image = thumbnailImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80) // Set thumbnail size
                    .cornerRadius(8)
            } else {
                Rectangle() // Placeholder if thumbnail not available
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .onAppear {
                        generateThumbnail() // Generate thumbnail when the view appears
                    }
            }
        }
    }

    // Function to generate a thumbnail from the video URL
    private func generateThumbnail() {
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 60) // Get the thumbnail at 1 second
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, result, error in
            if let cgImage = image, error == nil {
                DispatchQueue.main.async {
                    thumbnailImage = Image(decorative: cgImage, scale: 1.0, orientation: .right)
                }
            }
        }
    }
}

