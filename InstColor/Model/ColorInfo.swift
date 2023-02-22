//
//  ColorInfo.swift
//  InstColor
//
//  Created by Lei Cao on 1/27/23.
//

import Foundation
import SwiftUI

struct ColorInfo: Identifiable {
    let id = UUID()
    let InfoName: String
    let Value: String
}

struct DetectedColor: Identifiable, Hashable, Equatable {
    let id = UUID()
    let color: UIColor
    var frequency: CGFloat = 1
}
