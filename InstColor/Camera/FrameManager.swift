//
//  FrameManager.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import Foundation
import AVFoundation

class FrameManager: NSObject, ObservableObject {
    static let shared = FrameManager()
    
    @Published var current: CVPixelBuffer?
    @Published var position: AVCaptureDevice.Position?
    
    let videoOutputQueue = DispatchQueue(label: "come.home.leicao.VideoOuputQ", qos: .userInitiated, attributes:  [], autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        CameraManager.shared.set(self, queue: videoOutputQueue)
    }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}
