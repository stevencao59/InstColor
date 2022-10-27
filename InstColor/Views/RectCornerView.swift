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
    var navigationHeight: CGFloat
    var statusBarHeight: CGFloat
    var bottomBarHeight: CGFloat
    let cornerLength = 40.0

    var offsetTopHeight: CGFloat {
        return navigationHeight + statusBarHeight
    }
    
    var offsetBottomHeight: CGFloat {
        return navigationHeight + statusBarHeight + bottomBarHeight + 1
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: offsetTopHeight)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: offsetTopHeight)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength, offsetY: offsetTopHeight)
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: offsetTopHeight)

                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: geo.size.height - offsetBottomHeight)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength, offsetY: geo.size.height - offsetBottomHeight + cornerLength)
                RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: geo.size.height - offsetBottomHeight + cornerLength)
                RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: geo.size.height - offsetBottomHeight)
            }
        }
        .background(.clear)
    }
}

struct RectCornerView_Previews: PreviewProvider {
    static var previews: some View {
        RectCornerView(navigationHeight: 10, statusBarHeight: 10, bottomBarHeight: 10)
            .background(.black)
    }
        
}
