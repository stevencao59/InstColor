//
//  CameraManager.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import Combine
import Foundation
import AVFoundation

class CameraManager: ObservableObject {
    @Published var error: CameraError?

    @Published var cameraPosition: AVCaptureDevice.Position = .back
    private var subscriptions = Set<AnyCancellable>()

    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = CameraManager()
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "come.home.leicao.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = Status.unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            set(error: .unknownAuthorization)
        }
    }
    
    private func configureCaptureSession(cameraPosition: AVCaptureDevice.Position) {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
        
    }
    
    private init() {
        configure()
    }
    
    private func configure() {
        checkPermission()
        sessionQueue.async {
            self.configureCaptureSession(cameraPosition: self.cameraPosition)
            self.session.startRunning()
            self.startSubscription()
        }
    }
    
    private func startSubscription() {
        $cameraPosition
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global())
            .sink (receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Position Subscription is finished!")
                }
            }, receiveValue: { value in
                print("Current position: \(value)")
            })
            .store(in: &subscriptions)
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
}
