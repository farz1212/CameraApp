//
//  VideoPlayer.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import AVKit
import SwiftUI

struct VideoPlayerView: View {
    @StateObject private var viewModel: VideoPlayerViewModel

    // Initialize the view model with recorded videos
    init(recordedVideos: [URL]) {
        _viewModel = StateObject(
            wrappedValue: VideoPlayerViewModel(recordedVideos: recordedVideos))
    }

    var body: some View {
        VStack {
            
            // Video Player for the currently selected video
            if let player = viewModel.player {
                ZStack(alignment: .top) {
                    VideoPlayer(player: player)
                        .cornerRadius(15)
                        .ignoresSafeArea()
                        .onAppear {
                            viewModel.setupPlayer()
                        }

                    Color.black.opacity(0.4)
                        .frame(height: 100)
                }

                HStack {
                    
                    // Horizontal ScrollView for video thumbnails
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.recordedVideos, id: \.self) {
                                videoURL in
                                VideoThumbnailView(videoURL: videoURL)
                                    .cornerRadius(15)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        viewModel.playVideo(url: videoURL)
                                    }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }

                    // Save video button
                    Button {
                        viewModel.saveVideoToPhotoLibrary()
                    } label: {
                        Image(systemName: "sdcard.fill")
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .foregroundColor(.green)
                            .cornerRadius(15)
                            .shadow(color: .gray, radius: 4, x: 0, y: 0)
                            .padding(.trailing, 20)
                    }
                }
                .alert(
                    "Video saved to gallery", isPresented: $viewModel.showAlert
                ) {
                    Button("OK", role: .cancel) {}
                }

            } else {
                Text("No video available")
                    .background(Color.white)
            }
        }
        .background(Color.black)
        .padding(.bottom, 25)
        .ignoresSafeArea(.all)
        .onAppear {
            if viewModel.currentVideoURL != nil {
                viewModel.setupPlayer()
            }
        }
    }
}

// Preview Section
#Preview {
    // Provide some dummy video URLs for preview
    let dummyVideoURLs: [URL] = [
        URL(string: "https://example.com/sample1.mp4")!,
    ]

    VideoPlayerView(recordedVideos: dummyVideoURLs)
}
