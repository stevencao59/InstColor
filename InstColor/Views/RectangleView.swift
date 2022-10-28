//
//  RectangleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/16/22.
//

import SwiftUI

struct RectangleCornerView: View {
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        Rectangle()
            .background(.yellow)
            .offset(x: x, y: y)
            .frame(width: width, height: height)
    }
}

struct CornerGroupView: View {
    var size: CGSize
    var cornerLength: Double
    
    var body: some View {
        ZStack {
            RectangleCornerView(x: 0, y: 0, width: 1, height: cornerLength)
            RectangleCornerView(x: 0, y: size.height - cornerLength, width: 1, height: cornerLength)
            RectangleCornerView(x: cornerLength / 2, y: size.width - (cornerLength / 2), width: cornerLength, height: 1)
            RectangleCornerView(x: size.width - (cornerLength / 2), y: size.width - (cornerLength / 2), width: cornerLength, height: 1)
            RectangleCornerView(x: size.width, y: size.height - cornerLength, width: 1, height: cornerLength)
            RectangleCornerView(x: size.width, y: 0, width: 1, height: cornerLength)
            RectangleCornerView(x: size.height - (cornerLength / 2), y: -(cornerLength / 2), width: cornerLength, height: 1)
            RectangleCornerView(x: cornerLength / 2, y: -(cornerLength / 2), width: cornerLength, height: 1)
        }
    }
}

struct RectangleImageView: View {
    var rect: CGRect?
    @Binding var scaleAmount: Double
    
    var body: some View {
        if let rect = rect {
            Image(systemName: "viewfinder")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .scaleEffect(scaleAmount)
                .onChange(of: rect) { _ in
                    withAnimation() {
                        scaleAmount = 1
                    }
                }
                .onAppear() {
                    withAnimation() {
                        scaleAmount = 1
                    }
                }
        }
    }
}

struct RectangleView: View {
    @ObservedObject var model: ContentViewModel
    
    var body: some View {
        if model.frameSource == .thumbImage {
            if let rect = model.rect {
                RectangleImageView(rect: rect, scaleAmount: $model.scaleAmount)
            .frame(width: rect.width, height: rect.height)
            .offset(CGSize(width: rect.origin.x, height: rect.origin.y))
            }
        }

    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RectangleImageView(rect: CGRect(x: 0, y: 0, width: 20, height: 20), scaleAmount: .constant(1.5))
        }

    }
}
