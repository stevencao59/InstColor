//
//  ColorTextView.swift
//  InstColor
//
//  Created by Lei Cao on 10/5/22.
//

import SwiftUI

struct ColorTextView: View {
    let iconColor: Color
    let displayColor: CGFloat
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(iconColor)
                .frame(width: 10, height: 10)
                
            Text("\(String(format: "%g", Double(displayColor * 255)))")
                .font(.footnote)
        }
    }
}

struct ColorTextView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTextView(iconColor: .red, displayColor: CGFloat(0.2))
    }
}
