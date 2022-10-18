//
//  ContentViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import CoreImage
import UIKit

class ContentViewModel: ObservableObject {
    @Published var frame: CGImage?
    @Published var thumbFrame: CGImage?
    @Published var averageColor: UIColor?
    @Published var location: CGPoint?
    @Published var rect: CGRect?
    @Published var size: CGSize?
    @Published var error: Error?

    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
        
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
        $location
            .receive(on: RunLoop.main)
            .compactMap() { loc in
                if let location = self.location {
                    return CGRect(x: location.x - 20, y: location.y - 20, width: 20, height: 20)
                }
                return nil
            }
            .assign(to: &$rect)
        
        $thumbFrame
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
        
        $frame
            .receive(on: RunLoop.main)
            .compactMap { result in
                if let image = result.publisher.output {
                    let image = UIImage(cgImage: image)
                    if let rect = self.rect {
                        if let size = self.size {
                            return image.cropImage(toRect: rect, viewWidth: size.width, viewHeight: size.height)
                        }
                    }
                }
                return nil
            }
            .assign(to: &$thumbFrame)
    }
    
    init() {
        setupSubscriptions()
    }
}
