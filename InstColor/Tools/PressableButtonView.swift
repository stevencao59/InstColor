//
//  PressableView.swift
//  InstColor
//
//  Created by Lei Cao on 12/9/22.
//

import SwiftUI

struct PressableButtonView<Content: View>: View {
    var action: () -> Void
    var content: () -> Content
    
    @State var pressed: Bool = false
    
    func pressedAction() {
        action()
        pressed.toggle()
    }
    
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: pressedAction) {
            content()
        }
        .foregroundColor(pressed ? .yellow : .white)
        .animation(.easeIn, value: pressed)
    }
}

struct PressableView_Previews: PreviewProvider {
    static var previews: some View {
        PressableButtonView(action: { }) { }
    }
}
