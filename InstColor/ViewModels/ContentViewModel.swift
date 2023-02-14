//
//  ContentViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//
import CoreImage
import UIKit
import Combine

class Settings {
    static let shared = Settings()
    var colorMap: [RGBColor] = Bundle.main.decode("color.json")

    private init() { }
}

class States: ObservableObject {
    @Published var description: String = ""
    @Published var viewedColors: [ViewedColor] = []
}

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
    @Published var averageColor: UIColor = .white
    
    // Pressed location, size and scale
    @Published var location: CGPoint?
    @Published var rect: CGRect?
    @Published var scaleAmount: Double = 1
    
    // Image size
    @Published var size: CGSize?
    
    // Navigation/dashboard size
    @Published var dashboardHeight: CGFloat = 0
    @Published var statusBarHeight: CGFloat = 0
    @Published var bottomBarHeight: CGFloat = 0
    @Published var containerCotentWidth: CGFloat = 0
    @Published var containerCotentHeight: CGFloat = 0
    
    // All camera errors
    @Published var error: Error?

    // Thumb view size to exact color
    let thumbViewBaseSize: CGFloat = (UIScreen.screenHeight / UIScreen.screenWidth) * 5
    var thumbViewSize: CGFloat = 0.0
    @Published var thumbViewSizeDelta: Double = 0
    
    // Animation Amounts
    @Published var animationAmount = 0.0
    
    let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    // Camera running indicator
    @Published var isCameraReady: Bool = true
    
    // Image height scale
    var imageScaledHeight: CGFloat = 0.0
    
    // Average color algorithm
    @Published var colorAlgorithm: AverageColorAlgorithm = .defaultAlgo
    
    func getThumbFrame(cgImage: CGImage?) -> CGImage? {
        if let cgImage {
            let image = UIImage(cgImage: cgImage)
            if let rect = self.rect {
                if let size = self.size {
                    let posX =  self.cameraManager.cameraPosition == .front ? self.containerCotentWidth - rect.origin.x - self.thumbViewSize : rect.origin.x
                    let finalRect = CGRect(x: posX, y: rect.origin.y, width: rect.width, height: rect.height)
                    let croppedImage = image.cropImage(toRect: finalRect, viewWidth: size.width, viewHeight: size.height)
                    return croppedImage
                }
            }
        }
        return nil
    }
    
    func getRect(loc: CGPoint?) -> CGRect? {
        if let location = loc {
            return CGRect(x: location.x - self.thumbViewSize / 2, y: location.y - (self.thumbViewSize / 2), width: self.thumbViewSize, height: self.thumbViewSize)
        }
        return CGRect(x: self.containerCotentWidth / 2 - (self.thumbViewSize / 2), y: (self.containerCotentHeight / 2) - self.thumbViewSize / 2, width: self.thumbViewSize, height: self.thumbViewSize)
    }
    
    func getScaledHeight(image: CGImage) -> CGFloat {
        let scaledHeight = (Double(image.height) / Double(image.width)) * UIScreen.screenWidth
        return scaledHeight
    }
    
    func clampSize(originalSize: CGFloat, deltaSize: CGFloat) -> CGFloat {
        let size = originalSize + deltaSize
        return size < 1 ? 1 : size
    }
    
    func getColor(cgImage: CGImage?) -> UIColor? {
        if let image = cgImage {
            let image = UIImage(cgImage: image)
            if let color = colorAlgorithm == .defaultAlgo ? image.averageColor : image.averageColorLinear {
                return color
            }
        }
        return nil
    }
    
    func setupSubscriptions() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)

        cameraManager.$cameraRunnning
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isRunning in
                self.isCameraReady = isRunning
            })
            .store(in: &subscriptions)
        
        $location
            .receive(on: RunLoop.main)
            .compactMap() { loc in
                return self.getRect(loc: loc)
            }
            .assign(to: &$rect)
        
//        Timer.publish(every: 0.01, on: .main, in: .default)
//            .autoconnect()
//            .sink(receiveValue: { value in
//                guard let uiImage = UIImage(named: "TestImage") else {
//                    self.frame = nil
//                    return
//                }
//
//                guard let image = uiImage.convertToCgImage() else {
//                    self.frame = nil
//                    return
//                }
//
//                self.thumbViewSize = (Double(image.height) / Double(image.width)) * 10
//                self.frame = image
//                self.rect = self.getRect(loc: self.location)
//                self.imageSpaceSize = (UIScreen.screenHeight - (Double(image.height) / Double(image.width)) * UIScreen.screenWidth) / 2
//            })
//            .store(in: &subscriptions)
        
        frameManager.$current
            .receive(on: RunLoop.main)
            .sink(receiveValue: { buffer in
                guard let image = CGImage.create(from: buffer) else {
                    self.frame = nil
                    return
                }
                self.thumbViewSize = self.clampSize(originalSize: self.thumbViewBaseSize, deltaSize: self.thumbViewSizeDelta)
                self.frame = image
                self.rect = self.getRect(loc: self.location)
                self.imageScaledHeight = self.getScaledHeight(image: image)
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
            .removeDuplicates()
            .sink(receiveValue: { result in
                if let color = self.getColor(cgImage: result.publisher.output) {
                    self.averageColor = color
                }
            })
            .store(in: &subscriptions)
    }
    
    init() {
        setupSubscriptions()
    }
}
