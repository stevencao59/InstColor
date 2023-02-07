//
//  ImageButtonView.swift
//  InstColor
//
//  Created by Lei Cao on 11/4/22.
//

import SwiftUI

struct ImageButtonView: View {
    let imageName: String
    var color: Color = .white

    var frameSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 20
    var imageSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 10
    
    init(imageName: String) {
        self.imageName = imageName
    }
    
    init(imageName: String, color: Color, frameSize: CGFloat, imageSize: CGFloat) {
        self.imageName = imageName
        self.color = color
        self.frameSize = UIScreen.screenHeight / defaultScreenHeight * frameSize
        self.imageSize = UIScreen.screenHeight / defaultScreenHeight * imageSize
    }
    
    var body: some View {
        Circle()
            .strokeBorder(color)
            .frame(width: frameSize, height: frameSize)
            .background(.clear)
            .overlay() {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(color)
            }
    }
}

struct ImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ImageButtonView(imageName: "heart")
        }
            

            
    }
}
