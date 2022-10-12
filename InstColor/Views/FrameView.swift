//
//  FrameView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    let ratio = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(image, scale: 1.0, label: Text("Camera feed"))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
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
