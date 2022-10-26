//
//  MenuButtonView.swift
//  InstColor
//
//  Created by Lei Cao on 10/24/22.
//

import SwiftUI

struct MenuButtonView: View {
    var action: () -> Void
    var text: String
    var imageName: String
    
    init(action: @escaping () -> Void, text: String, imageName: String) {
        self.action = action
        self.text = text
        self.imageName = imageName
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                Image(systemName: imageName)
            }
        }
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var action : () -> Void = { }
    
    static var previews: some View {
        MenuButtonView(action: action, text: "Full Screen", imageName: "viewfinder" )
    }
}
