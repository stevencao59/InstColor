//
//  String.swift
//  InstColor
//
//  Created by Lei Cao on 12/3/22.
//

import Foundation
import SwiftUI

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
    
    func removeLastInt() -> String {
        var output = self
        if let split_name = self.components(separatedBy: " ").last {
            if split_name.isInt {
                output = self.replacingOccurrences(of: " \(split_name)", with: "")
            }
        }
        return output
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.width
     }
}
