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
    @Published var averageColor: UIColor?
    
    private let frameManager = FrameManager.shared
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)

        $frame
            .compactMap { result in
                if let image = result.publisher.output {
                    let image = UIImage(cgImage: image)
                    if let color = image.averageColor {
                        print(color.components)
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
