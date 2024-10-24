//
//  CameraView.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var permissionGranted = false

    var body: some View {
        ZStack {
            if permissionGranted {
                CameraPreviewView(viewModel: viewModel)
                VStack {
                    Color.black.opacity(0.4)
                        .frame(height: 100)
                    Spacer()
                    RecordingButton(isRecording: viewModel.isRecording, action: {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            viewModel.startRecording()
                        }
                    })
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

