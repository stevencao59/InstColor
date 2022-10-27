//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    var navigationHeight: CGFloat
    var dashboardHeight: CGFloat
    var statusBarHeight: CGFloat
    var bottomBarHeight: CGFloat
    
    @Binding var location: CGPoint?
    @Binding var rectSize: CGSize?
    @Binding var scaleAmount: Double
    
    @Binding var frameSource: FrameSource
    
    @State private var cornerViewOpacity = 1.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if let image = image {
                    Image(image, scale: 1.0, label: Text("Camera feed"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .modifier(FrameModifier(contentSize: CGSize(width: geometry.size.width, height: geometry.size.height), rectSize: $rectSize, location: $location, frameSource: $frameSource, scaleAmount: $scaleAmount))
                    
                    RectCornerView(navigationHeight: navigationHeight, statusBarHeight: statusBarHeight, bottomBarHeight: bottomBarHeight)
                        .frame(height: geometry.size.height)
                        .opacity(cornerViewOpacity)
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeIn, value: cornerViewOpacity)
        .onChange(of: frameSource) { source in
            cornerViewOpacity = source == .wholeImage ? 1.0 : 0.0
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(navigationHeight: 20, dashboardHeight: 20, statusBarHeight: 10, bottomBarHeight: 10, location: .constant(CGPoint(x: 100, y: 100)), rectSize: .constant(CGSize(width: 50, height: 50)), scaleAmount: .constant(1.0), frameSource: .constant(.wholeImage))
    }
}
