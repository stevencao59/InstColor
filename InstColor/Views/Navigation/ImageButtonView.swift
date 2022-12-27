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
    @State var frameSize: CGFloat = 20
    @State var imageSize: CGFloat = 10
    
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
