//
//  ColorResultViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 10/8/22.
//

import Foundation
import SwiftUI
import Combine

class ColorResultViewModel: ObservableObject {
    @Published var color: UIColor = UIColor(.white)
    @Published var colorName: String = "Unknown Color"
    @Published var baseColorName: String = "Unknown Base Color"
    @Published var baseColorHex: String = "#000000"
    @Published var selectedDentent: PresentationDetent = .medium
    @Published var showColorDetail: Bool = false
    
    let camera: CameraManager
    
    private var subscriptions = Set<AnyCancellable>()
    
    func setupSubscriptions() {
        $color
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                let closestColor = color.calculateClosestColor(colorMap: Settings.shared.colorMap)

                self.colorName = closestColor.Color
                self.baseColorName = closestColor.BaseColor
                self.baseColorHex = closestColor.BaseColorHex
            })
            .store(in: &subscriptions)
        
        $showColorDetail
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { show in
                self.camera.cameraRunnning = !show
            })
            .store(in: &subscriptions)
    }
    
    init(camera: CameraManager) {
        self.camera = camera
        self.setupSubscriptions()
    }
}
