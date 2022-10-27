//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationMenu: View {
    let action: () -> Void
    var frameSource: FrameSource
    
    init (action: @escaping () -> Void, frameSource: FrameSource) {
        self.action = action
        self.frameSource = frameSource
    }
    
    var body: some View {
        Menu {
            Button(action: action) {
                HStack {
                    Text("Full Screen")
                    if frameSource == .wholeImage {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: action) {
                HStack {
                    Text("Rectagle View")
                    if frameSource == .thumbImage {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
        } label: {
            HStack {
                Text("Camera")
                Image(systemName: "chevron.down")
            }
        }
        .font(.headline)
        .padding([.vertical])
    }
}

struct NavigationView: View {
    @ObservedObject var model: ContentViewModel
    @State var imageName = "viewfinder"
    
    func changeFrameSource() {
        model.frameSource = model.frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
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
                    NavigationMenu(action: changeFrameSource, frameSource: model.frameSource)
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
                            print("navigation bar is \(geo.size.height)")
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
