//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(image, scale: 1.0, label: Text("Camera feed"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .modifier(ZoomModifier(contentSize: CGSize(width: geometry.size.width, height: geometry.size.height)))
                    .modifier(ThumbnailModifier())

            } else {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(.black)
            }
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
