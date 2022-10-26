//
//  RectCornerView.swift
//  InstColor
//
//  Created by Lei Cao on 10/25/22.
//

import SwiftUI

struct RectSingleView: View {
    var cornerHeight: Double
    var cornerWidth: Double
    var offsetX: Double
    var offsetY: Double

    var body: some View {
        Rectangle()
            .border(.yellow)
            .frame(width: cornerWidth, height: cornerHeight)
            .offset(x: offsetX, y: offsetY)
    }
}

struct RectCornerView: View {
    var cornerLength = 40.0
    let lengthDelta = 4.0
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: lengthDelta)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: lengthDelta)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength, offsetY: lengthDelta)
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: lengthDelta)
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: geo.size.height - cornerLength - lengthDelta)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength - 1, offsetY: geo.size.height - lengthDelta)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: geo.size.height - lengthDelta)
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: geo.size.height - cornerLength - lengthDelta)
            }
        }
        .background(.clear)
    }
}

struct RectCornerView_Previews: PreviewProvider {
    static var previews: some View {
        RectCornerView()
            .background(.black)
    }
        
}
