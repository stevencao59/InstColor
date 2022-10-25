//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    @Binding var location: CGPoint?
    @Binding var rectSize: CGSize?
    @Binding var scaleAmount: Double
    
    @Binding var frameSource: FrameSource

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = image {
                    Image(image, scale: 1.0, label: Text("Camera feed"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .modifier(FrameModifier(contentSize: CGSize(width: geometry.size.width, height: geometry.size.height), rectSize: $rectSize, location: $location, frameSource: $frameSource, scaleAmount: $scaleAmount))
                }
            }
        }
        .background(.black)
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(location: .constant(CGPoint(x: 100, y: 100)), rectSize: .constant(CGSize(width: 50, height: 50)), scaleAmount: .constant(1.0), frameSource: .constant(.wholeImage))
    }
}
