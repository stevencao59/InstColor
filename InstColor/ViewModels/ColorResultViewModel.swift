//
//  ColorResultViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 10/8/22.
//

import Foundation
import SwiftUI

class ColorResultViewModel: ObservableObject {
    @Published var color: UIColor = UIColor(.white)
    @Published var colorName: String?
    
    init() {
        $color
            .receive(on: RunLoop.main)
            .map { color in
                let closestColor = color.calculateClosestColor()
                return closestColor?.English
            }
            .assign(to: &$colorName)
    }
}
