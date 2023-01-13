//
//  Device.swift
//  InstColor
//
//  Created by Lei Cao on 1/12/23.
//

import Foundation
import SwiftUI

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
