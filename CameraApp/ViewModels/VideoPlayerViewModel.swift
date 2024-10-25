//
//  VideoPlayerViewModel.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-25.
//

import AVKit
import Foundation
import Photos

class VideoPlayerViewModel: ObservableObject {
    @Published var currentVideoURL: URL? // Optional URL of the video currently being played
    @Published var player: AVPlayer? // The AVPlayer instance to manage playback
    @Published var recordedVideos: [URL] // Array to hold recorded video URLs
    @Published var showAlert: Bool = false

    // Initialize with recorded videos
    init(recordedVideos: [URL]) {
        self.recordedVideos = recordedVideos
        self.currentVideoURL = recordedVideos.first
        setupPlayer()
    }
    
    // Setup player with the current video URL
    func setupPlayer() {
        guard let url = currentVideoURL else { return }
        player = AVPlayer(url: url)
        player?.play() // Start playing the video
    }

    // Function to play a selected video
    func playVideo(url: URL) {
        currentVideoURL = url
        setupPlayer() // Set up the player with the new video URL
    }

    // Save video to photo library
    func saveVideoToPhotoLibrary() {
        guard let videoURL = currentVideoURL else { return }
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                }) { success, error in
                    if success {
                        self.showAlert = true
                    } else if let error = error {
                        print("Failed to save video to photo library: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Photo library access was not granted.")
            }
        }
    }
}
