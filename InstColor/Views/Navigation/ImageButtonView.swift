//
//  ImageButtonView.swift
//  InstColor
//
//  Created by Lei Cao on 11/4/22.
//

import SwiftUI

struct ImageButtonView: View {
    let imageName: String
    
    var body: some View {
        Circle()
            .strokeBorder(.yellow)
            .frame(width: 20, height: 20)
            .background(.clear)
            .overlay() {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.yellow)
                    
            }
            .scaleEffect(1.5)
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
