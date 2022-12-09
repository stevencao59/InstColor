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
    @Published var cameraRunnning: Bool = true
    @Published var torchMode: Bool = false

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
    private var cameraInput: AVCaptureInput?
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
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = on == true ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Torch is available but cannot be opened!")
            }
        } else {
            print("Torch is not available!")
        }
    }
    
    private func addDeviceOutput() throws {
        if !session.canAddOutput(videoOutput) {
            session.removeOutput(session.outputs[0])
        }
        session.addOutput(videoOutput)
        
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }
    
    private func configureCaptureSession(cameraPosition: AVCaptureDevice.Position) {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
            status = .configured
        }
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            if let cameraInput = cameraInput {
                session.removeInput(cameraInput)
            }
            
            let deviceInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
                cameraInput = deviceInput
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
        
        do {
            try addDeviceOutput()
        } catch {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
    }
    
    private init() {
        configure()
    }
    
    private func configure() {
        checkPermission()
        sessionQueue.async {
            self.session.startRunning()
            self.startSubscription()
        }
    }
    
    private func startSubscription() {
        $torchMode
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global())
            .removeDuplicates()
            .sink(receiveValue: { openTorch in
                self.toggleTorch(on: openTorch)
            })
            .store(in: &subscriptions)
        
        $cameraPosition
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global())
            .removeDuplicates()
            .sink (receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Position Subscription is finished!")
                }
            }, receiveValue: { value in
                self.status = .unconfigured
                self.configureCaptureSession(cameraPosition: value)
            })
            .store(in: &subscriptions)
        
        $cameraRunnning
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global())
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value {
                    if self.status == .configured {
                        self.sessionQueue.async {
                            self.session.startRunning()
                        }
                    }
                } else {
                    self.session.stopRunning()
                    
                }
            })
            .store(in: &subscriptions)
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}
