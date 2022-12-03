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
            .border(.white)
            .opacity(0.8)
            .frame(width: cornerWidth, height: cornerHeight)
            .offset(x: offsetX, y: offsetY)
    }
}

struct RectCornerView: View {
    var navigationHeight: CGFloat
    var statusBarHeight: CGFloat
    var frameHeight: CGFloat
    let cornerLength = 30.0

    var offsetTopHeight: CGFloat {
        return navigationHeight + statusBarHeight
    }
    
    var offsetBottomHeight: CGFloat {
        return navigationHeight + statusBarHeight
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Group {
                    RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: offsetTopHeight)
                    RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: offsetTopHeight)
                    RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength, offsetY: offsetTopHeight)
                    RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: offsetTopHeight)
                }

                Group {
                    RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: geo.size.width - 1, offsetY: geo.size.height - offsetBottomHeight - cornerLength)
                    RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: geo.size.width - cornerLength, offsetY: geo.size.height - offsetBottomHeight)
                    RectSingleView(cornerHeight: 1, cornerWidth: cornerLength, offsetX: 0, offsetY: geo.size.height - offsetBottomHeight)
                    RectSingleView(cornerHeight: cornerLength, cornerWidth: 1, offsetX: 0, offsetY: geo.size.height - offsetBottomHeight - cornerLength)
                }
                .padding([.top])

            }
        }
        .background(.clear)
    }
}

struct RectCornerView_Previews: PreviewProvider {
    static var previews: some View {
        RectCornerView(navigationHeight: 10, statusBarHeight: 10, frameHeight: 100)
            .background(.black)
    }
        
}
