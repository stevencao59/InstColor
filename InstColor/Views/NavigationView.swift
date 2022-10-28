//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var model: ContentViewModel
    @State var imageName = "viewfinder"
    
    var body: some View {
        VStack {
            HStack {
                if let error = model.error {
                    Text(error.localizedDescription)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    FrameSourceView(frameSource: $model.frameSource, imageName: $imageName)
                    NavigationMenuView(frameSource: $model.frameSource, thumbFrameSize: $model.thumbViewSize)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .opacity(0.8)
            .foregroundColor(.yellow)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            model.navigationHeight = geo.size.height
                        }
                }
            )
            Spacer()
            
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(model: ContentViewModel())
  }
}
