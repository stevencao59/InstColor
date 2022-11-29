//
//  ContentViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//
import CoreImage
import UIKit
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    
    // Cancellables
    private var subscriptions = Set<AnyCancellable>()
    
    // Note: recognizeFrame is the frame where we get average color from
    @Published var frame: CGImage?
    @Published var thumbFrame: CGImage?
    @Published var recgonizeFrame: CGImage?
    
    // Image source can be from whole camera, thumb image or camera pictures
    @Published var frameSource: FrameSource = .wholeImage
    
    // Average color results
    @Published var averageColor: UIColor?
    
    // Pressed location, size and scale
    @Published var location: CGPoint?
    @Published var rect: CGRect?
    @Published var scaleAmount: Double = 1
    
    // Image size
    @Published var size: CGSize?
    
    // Navigation/dashboard size
    @Published var navigationHeight: CGFloat = 0
    @Published var dashboardHeight: CGFloat = 0
    @Published var statusBarHeight: CGFloat = 0
    @Published var bottomBarHeight: CGFloat = 0
    @Published var containerCotentWidth: CGFloat = 0
    @Published var containerCotentHeight: CGFloat = 0
    
    // All camera errors
    @Published var error: Error?

    // Thumb view size to exact color
    var thumbViewSize: CGFloat = 0.0
    
    // Animation Amounts
    @Published var animationAmount = 0.0
    
    let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    func getThumbFrame(cgImage: CGImage?) -> CGImage? {
        if let image = cgImage {
            let image = UIImage(cgImage: image)
            if let rect = self.rect {
                if let size = self.size {
                    let finalRect = CGRect(x: rect.origin.x, y: rect.origin.y  - self.thumbViewSize, width: rect.width, height: rect.height)
                    let croppedImage = image.cropImage(toRect: finalRect, viewWidth: size.width, viewHeight: size.height)
                    return croppedImage
                }
            }
        }
        return nil
    }
    
    func getRect(loc: CGPoint?) -> CGRect? {
        if let location = loc {
            return CGRect(x: location.x - self.thumbViewSize / 2, y: location.y - self.navigationHeight - self.thumbViewSize  / 2, width: self.thumbViewSize, height: self.thumbViewSize)
        }
        return CGRect(x: self.containerCotentWidth / 2 - (self.thumbViewSize / 2), y: (self.containerCotentHeight / 2) - self.navigationHeight - self.thumbViewSize / 2, width: self.thumbViewSize, height: self.thumbViewSize)
    }
    
    func setupSubscriptions() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)

        $location
            .receive(on: RunLoop.main)
            .compactMap() { loc in
                return self.getRect(loc: loc)
            }
            .assign(to: &$rect)
        
        frameManager.$current
            .receive(on: RunLoop.main)
            .sink(receiveValue: { buffer in
                guard let image = CGImage.create(from: buffer) else {
                    self.frame = nil
                    return
                }
                self.thumbViewSize = (Double(image.height) / Double(image.width)) * 10
                self.frame = image
            })
            .store(in: &subscriptions)
        
        $frame
            .receive(on: RunLoop.main)
            .compactMap { result in
                return self.getThumbFrame(cgImage: result.publisher.output)
            }
            .assign(to: &$thumbFrame)

        $frame
            .receive(on: RunLoop.main)
            .compactMap { frame in
                switch self.frameSource {
                case .wholeImage:
                    return self.frame
                case .thumbImage:
                    return self.thumbFrame
                default:
                    return self.frame
                }
            }
            .assign(to: &$recgonizeFrame)

        $recgonizeFrame
            .receive(on: RunLoop.main)
            .compactMap { result in
                if let image = result.publisher.output {
                    let image = UIImage(cgImage: image)
                    if let color = image.averageColor {
                        return color
                    }
                }
                return nil
            }
            .assign(to: &$averageColor)
    }
    
    init() {
        setupSubscriptions()
    }
}
