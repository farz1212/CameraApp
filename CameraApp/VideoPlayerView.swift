//
//  VideoPlayer.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import AVKit
import SwiftUI
import AVFoundation

struct VideoPlayerView: View {
    @State private var currentVideoURL: URL? // Optional URL of the video currently being played
    @State private var player: AVPlayer? // The AVPlayer instance to manage playback
    @State private var recordedVideos: [URL] // Array to hold recorded video URLs

    // Initialize the view with the recorded videos array
    init(recordedVideos: [URL]) {
        _recordedVideos = State(initialValue: recordedVideos)
        // Set the first video as the current video URL, if available
        _currentVideoURL = State(initialValue: recordedVideos.first)
    }

    var body: some View {
        VStack {
            // Video Player for the currently selected video
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        setupPlayer(url: currentVideoURL)
                    }
                
            } else {
                Text("No video available")
                    .background(Color.black)
            }
            
            // Horizontal ScrollView for video thumbnails
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(recordedVideos, id: \.self) { videoURL in
                        VideoThumbnailView(videoURL: videoURL)
                            .padding(5)
                            .cornerRadius(15)
                            .onTapGesture {
                                playVideo(url: videoURL)
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 25)
        .ignoresSafeArea(.all)
        .onAppear {
            if currentVideoURL != nil {
                setupPlayer(url: currentVideoURL)
            }
        }
    }

    // Function to set up the AVPlayer with the given URL
    private func setupPlayer(url: URL?) {
        guard let url = url else { return }
        player = AVPlayer(url: url)
        player?.play() // Start playing the video
    }

    // Function to play the selected video
    private func playVideo(url: URL) {
        currentVideoURL = url // Update the current video URL
        setupPlayer(url: url) // Set up the player with the new video URL
    }

    // Function to stop and release the AVPlayer
    private func stopAndReleasePlayer() {
        player?.pause() // Pause the player
        player = nil // Release the player
    }
}

struct VideoThumbnailView: View {
    var videoURL: URL
    @State private var thumbnailImage: Image? // To store the thumbnail image

    var body: some View {
        VStack {
            if let image = thumbnailImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 80) // Set thumbnail size
                    .cornerRadius(8)
            } else {
                Rectangle() // Placeholder if thumbnail not available
                    .fill(Color.gray)
                    .frame(width: 120, height: 80)
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
                    thumbnailImage = Image(decorative: cgImage, scale: 1.0, orientation: .up) // Set the generated thumbnail image
                }
            }
        }
    }
}

// Preview Section
#Preview {
    // Provide some dummy video URLs for preview
    let dummyVideoURLs: [URL] = [
        URL(string: "https://example.com/sample1.mp4")!,
        URL(string: "https://example.com/sample2.mp4")!
    ]
    
    VideoPlayerView(recordedVideos: dummyVideoURLs)
}
