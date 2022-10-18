//
//  ColorTextGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct ColorTextGroupView: View {
    let components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    func translateHexString(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> String {
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
    
    var body: some View {
        VStack {
            HStack {
                ColorTextView(iconColor: .red, displayColor: components.red)
                ColorTextView(iconColor: .green, displayColor: components.green)
                ColorTextView(iconColor: .blue, displayColor: components.blue)
            }
            Text("Hex: \(translateHexString(components.red, components.green, components.blue))")
                .font(.footnote)
                .foregroundColor(.white)
        }

    }
}

struct ColorTextGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTextGroupView(components: (red: CGFloat(0.7), green: CGFloat(0.8), blue: CGFloat(0.9), alpha: CGFloat(1)))
    }
}
