//
//  ColorTextGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct ColorTextGroupView: View {
    let components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    var body: some View {
        HStack {
            ColorTextView(iconColor: .red, displayColor: components.red)
            ColorTextView(iconColor: .green, displayColor: components.green)
            ColorTextView(iconColor: .blue, displayColor: components.blue)
        }
    }
}

struct ColorTextGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTextGroupView(components: (red: CGFloat(0.7), green: CGFloat(0.8), blue: CGFloat(0.9), alpha: CGFloat(1)))
    }
}
