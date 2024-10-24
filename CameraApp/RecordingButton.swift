//
//  RecordingButton.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import SwiftUI

struct RecordingButton: View {
    // Parameters for the button
    @ObservedObject var viewModel: CameraViewModel
    @State private var navigateToVideoPlayer = false  // State to control navigation

    var body: some View {
        // Recorder Button (Center)
        Button(action: {
            viewModel.isRecording
                ? viewModel.stopRecording() : viewModel.startRecording()
        }) {
            ZStack {
                Image(
                    systemName: viewModel.isRecording
                        ? "stop.fill" : "video.fill"
                )
                .frame(width: 60, height: 60)
                .background(
                    viewModel.isRecording ? Color.red : Color.white
                )
                .foregroundColor(.gray)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 4, x: 0, y: 0)

                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .padding(5)
                    .frame(width: 65, height: 65)
            }
        }
    }
}

#Preview {
    RecordingButton(viewModel: CameraViewModel())
}
