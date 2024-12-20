//
//  ContentViewModel.swift
//  CameraApp
//
//  Created by Farzaad Goiporia on 2024-10-24.
//

import AVFoundation
import Photos
import SwiftUI

class CameraViewModel: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordedVideos: [URL] = []

    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    func requestPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    //Check Permissions for Photo Library
    func checkPhotoLibraryPermissions() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Photo library access is granted.")
            case .denied, .restricted:
                print("Photo library access is denied.")
            case .notDetermined:
                print("Photo library access has not been requested.")
            default:
                print("Unknown photo library access status.")
            }
        }
    }

    //Set up new AVCaptureSession
    func setupSession() {
        captureSession = AVCaptureSession()
        guard let session = captureSession else { return }

        session.beginConfiguration()

        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),

            let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(videoInput)
        else {
            return
        }

        session.addInput(videoInput)

        // Add video output
        videoOutput = AVCaptureMovieFileOutput()
        if let output = videoOutput, session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        // Prepare preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
    }

    //Strat Session
    func startSession() {
        guard let session = captureSession else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            session.startRunning()

            // Ensure we update UI on the main thread after the session starts
            DispatchQueue.main.async {
                if session.isRunning, let previewLayer = self?.previewLayer {
                    previewLayer.connection?.videoRotationAngle = CGFloat(90.0)
                }
            }
        }
    }

    //Stop Session
    func stopSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }

    //Start Recording
    func startRecording() {
        guard let output = videoOutput, !output.isRecording else { return }

        // Use a unique file name to avoid overwriting previous recordings
        let uniqueFileName = UUID().uuidString + ".mov"
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(uniqueFileName)

        output.startRecording(to: tempURL, recordingDelegate: self)
        isRecording = true
    }

    //Stop Recording
    func stopRecording() {
        videoOutput?.stopRecording()
        isRecording = false
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
}

//Add to List of Recorded Video URLs
extension CameraViewModel: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection], error: Error?
    ) {
        if let error = error {
            print("Failed to record video: \(error.localizedDescription)")
            return
        }

        //Save to list of videos
        recordedVideos.append(outputFileURL)
    }


}
