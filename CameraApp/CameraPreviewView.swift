//
//  CameraPreviewView.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        if let previewLayer = viewModel.getPreviewLayer() {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    CameraPreviewView(viewModel: CameraViewModel())
}
