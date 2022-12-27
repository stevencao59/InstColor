//
//  AboutView.swift
//  InstColor
//
//  Created by Lei Cao on 12/24/22.
//

import SwiftUI

struct AboutView: View {
    @State var imageSize: CGFloat = .zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                VStack {
                    Group {
                        Image(systemName: "app.dashed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize / 4)
                            .foregroundColor(.white)
                        Group {
                            Text("InstColor")
                                .font(.title)
                                .bold()
                            Text("Version: \(appVersion ?? "")" )
                        }
                        .foregroundColor(.white)
                        Link("helps@instcolor.com", destination: URL(string: "mailto:helps@instcolor.com")!)
                    }
                    .padding(.bottom)
                }
            }
            .background(.black)
            .modifier(SimpleModalViewModifier())
        }
        .edgesIgnoringSafeArea(.vertical)
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        imageSize = geo.size.width
                    }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
