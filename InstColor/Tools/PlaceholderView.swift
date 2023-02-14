//
//  SwiftUIView.swift
//  InstColor
//
//  Created by Lei Cao on 2/11/23.
//

import SwiftUI

struct PlaceholderView: View {
    var placeholderImageName = ""
    var placeholderText = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
            VStack {
                Image(systemName: placeholderImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.screenWidth / 4)
                    .padding()
                Text(placeholderText)
                    .multilineTextAlignment(.center)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButtonView()
            }
        }
        .background(.black)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
    }
}
