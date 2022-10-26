//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationMenu: View {
    let action: () -> Void
    
    init (action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Menu {
            Button(action: action) {
                HStack {
                    Text("Full Screen")
                    Image(systemName: "viewfinder")
                }
                .foregroundColor(.yellow)
            }
            Button(action: action) {
                HStack {
                    Text("Rectagle View")
                    Image(systemName: "viewfinder.circle")
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
    var error: Error?
    @Binding var frameSource: FrameSource
    @Binding var navigationHeight: CGFloat
    
    @State var imageName = "viewfinder"
    
    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack {
            HStack {
                if let error = error {
                    Text(error.localizedDescription)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    FrameSourceView(frameSource: $frameSource, imageName: $imageName)
                    NavigationMenu(action: changeFrameSource)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .opacity(0.9)
            .foregroundColor(.yellow)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            print("Navigation Height is \(geo.size.height)")
                            navigationHeight = geo.size.height
                        }
                }
            )
            Spacer()
            
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(error: nil, frameSource: .constant(.thumbImage), navigationHeight: .constant(1.0))
  }
}
