//
//  CameraView.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var permissionGranted = false

    var body: some View {
        NavigationView {
            ZStack {
                if permissionGranted {
                    CameraPreviewView(viewModel: viewModel)
                        .onAppear {
                            viewModel.startSession()
                        }
                    VStack {
                        Color.black.opacity(0.4)
                            .frame(height: 100)
                        Spacer()
                        ZStack {

                            Color.black.opacity(0.4)
                                .frame(height: 125)
                            HStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .opacity(0)
                                    .padding(.leading, 20)

                                Spacer()

                                RecordingButton(viewModel: viewModel)

                                Spacer()

                                NavigationLink(
                                    destination: VideoPlayerView(
                                        recordedVideos: viewModel.recordedVideos
                                    )
                                ) {
                                    Image(systemName: "photo.stack.fill")
                                        .frame(width: 50, height: 50)
                                        .background(Color.white)
                                        .foregroundColor(.gray)
                                        .cornerRadius(15)
                                        .shadow(
                                            color: .gray, radius: 4, x: 0, y: 0
                                        )
                                        .padding(.trailing, 20)
                                }

                            }
                        }
                    }
                } else {
                    Color.black
                        .onAppear {
                            viewModel.requestPermission { granted in
                                if granted {
                                    permissionGranted = true
                                    viewModel.setupSession()
                                    viewModel.startSession()
                                }
                            }
                            viewModel.checkPhotoLibraryPermissions()
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                viewModel.stopSession()
            }
        }
    }
}

#Preview {
    CameraView()
}
