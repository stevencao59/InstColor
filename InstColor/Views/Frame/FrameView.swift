//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameGapHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat,
                       nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct FrameView: View {
    @ObservedObject var model: ContentViewModel
    @State private var frameBlur = 0.0
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.black
            if let error = model.error {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth / 4)
                        .padding()
                    Text(error.localizedDescription)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .bottom])
                }
                .foregroundColor(.white)
            } else {
                if let image = model.frame {
                    Image(image, scale: 1, label: Text("Camera feed"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: model.imageScaledHeight, alignment: .center)
                        .rotation3DEffect(.degrees(model.animationAmount), axis: (x: 0, y: 1, z: 0))
                        .blur(radius: frameBlur)
                        .modifier(FrameModifier(contentSize: CGSize(width: UIScreen.screenWidth, height: model.imageScaledHeight), rectSize: $model.size, location: $model.location, frameSource: $model.frameSource, scaleAmount: $model.scaleAmount))
                        .onChange(of: model.isCameraReady) { isReady in
                            frameBlur = isReady ? 0 : 10
                        }
                        .animation(.default, value: frameBlur)
                        .overlay(ThumbView(model: model), alignment: .topLeading)
                        .background (GeometryReader { geo in
                            Color.clear.preference(key: FrameGapHeightPreferenceKey.self, value: geo.frame(in: .named("Custom")).minY)
                        })
                }
            }
        }
        .coordinateSpace(name: "Custom")
        .onPreferenceChange(FrameGapHeightPreferenceKey.self) {
            model.imageGapHeight = $0
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(model: ContentViewModel())
    }
}
