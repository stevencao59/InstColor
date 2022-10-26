//
//  ContentViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//
import CoreImage
import UIKit

class ContentViewModel: ObservableObject {
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
    @Published var scaleAmount: Double = 2
    
    // Image size
    @Published var size: CGSize?
    
    // Navigation height
    @Published var navigationHeight: CGFloat = 0
    @Published var dashboardHeight: CGFloat = 0
    
    // All camera errors
    @Published var error: Error?

    // Thumb view size to exact color
    @Published var thumbViewSize = 20.0
    
    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    func setupSubscriptions() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)

        $location
            .receive(on: RunLoop.main)
            .compactMap() { loc in
                if let location = self.location {
                    return CGRect(x: location.x, y: location.y - self.navigationHeight - self.thumbViewSize / 2, width: self.thumbViewSize, height: self.thumbViewSize)
                }
                return nil
            }
            .assign(to: &$rect)

        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
        
        $frame
            .receive(on: RunLoop.main)
            .compactMap { result in
                if let image = result.publisher.output {
                    let image = UIImage(cgImage: image)
                    if let rect = self.rect {
                        if let size = self.size {
                            let finalRect = CGRect(x: rect.origin.x, y: rect.origin.y  - self.thumbViewSize, width: rect.width, height: rect.height)
                            return image.cropImage(toRect: finalRect, viewWidth: size.width, viewHeight: size.height)
                        }
                    }
                }
                return nil
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
