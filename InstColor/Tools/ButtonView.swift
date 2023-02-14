//
//  ImageButtonView.swift
//  InstColor
//
//  Created by Lei Cao on 2/12/23.
//

import SwiftUI

struct ButtonView: View {
    var action: () -> Void
    let imageName: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(.white)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(action: { }, imageName: "")
    }
}
