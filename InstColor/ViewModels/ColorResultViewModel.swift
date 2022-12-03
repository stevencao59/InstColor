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
    @Published var colorName: String?
    @Published var baseColorName: String?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $color
            .receive(on: RunLoop.main)
            .sink(receiveValue: { color in
                let closestColor = color.calculateClosestColor()

                self.colorName = closestColor.Color
                self.baseColorName = closestColor.BaseColor
            })
            .store(in: &subscriptions)
    }
}
