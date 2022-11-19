//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    @ObservedObject var model: ContentViewModel
    @State private var cornerViewOpacity = 1.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if let image = model.frame {
                    Image(image, scale: 1, label: Text("Camera feed"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .rotation3DEffect(.degrees(model.animationAmount), axis: (x: 0, y: 1, z: 0))
                        .modifier(FrameModifier(contentSize: CGSize(width: geometry.size.width, height: geometry.size.height), rectSize: $model.size, location: $model.location, frameSource: $model.frameSource, scaleAmount: $model.scaleAmount))
                    
                    RectCornerView(navigationHeight: model.navigationHeight, statusBarHeight: model.statusBarHeight, bottomBarHeight: model.bottomBarHeight)
                        .frame(height: geometry.size.height)
                        .opacity(cornerViewOpacity)
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeIn, value: cornerViewOpacity)
        .onChange(of: $model.frameSource.wrappedValue) { source in
            cornerViewOpacity = source == .wholeImage ? 1.0 : 0.0
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(model: ContentViewModel())
    }
}
