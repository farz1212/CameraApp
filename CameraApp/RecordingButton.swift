//
//  RecordingButton.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import SwiftUI

struct RecordingButton: View {
    // Parameters for the button
    var isRecording: Bool
    var action: () -> Void

    var body: some View {
        
        ZStack{
            Color.black.opacity(0.4)
            Button(action: {
                action()
            }) {
                ZStack{
                    Image(systemName: isRecording ? "stop.fill" : "video.fill") // Display different icons based on the state
                        .frame(width: 60, height: 60)
                        .background(isRecording ? Color.red : Color.white)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 4, x: 0, y: 0)
                    
                        Circle()
                        .stroke(Color.gray, lineWidth: 1)
                            .padding(5)
                            .frame(width: 65, height: 65)
                }
            }
            .padding(.bottom, 15)
        }
        .frame(height: 125)
        .ignoresSafeArea()
    }
}
#Preview {
    RecordingButton(isRecording: false, action: {})
}
