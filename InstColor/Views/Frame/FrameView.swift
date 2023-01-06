//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    @ObservedObject var model: ContentViewModel
    @State private var frameBlur = 0.0
    
    var body: some View {
        ZStack {
            Color.black
            GeometryReader { geometry in
                if let image = model.frame {
                    Image(image, scale: 1, label: Text("Camera feed"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .rotation3DEffect(.degrees(model.animationAmount), axis: (x: 0, y: 1, z: 0))
                        .blur(radius: frameBlur)
                        .modifier(FrameModifier(contentSize: CGSize(width: geometry.size.width, height: geometry.size.height), rectSize: $model.size, location: $model.location, frameSource: $model.frameSource, scaleAmount: $model.scaleAmount))
                        .onChange(of: model.isCameraReady) { isReady in
                            frameBlur = isReady ? 0 : 50
                        }
                        .animation(.default, value: frameBlur)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(model: ContentViewModel())
    }
}
