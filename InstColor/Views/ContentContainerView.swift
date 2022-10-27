//
//  SizeMeasureView.swift
//  InstColor
//
//  Created by Lei Cao on 10/26/22.
//

import SwiftUI

struct ContentContainerView<Content: View>: View {
    @ObservedObject var model: ContentViewModel
    let content: () -> Content
    
    init(model: ContentViewModel, @ViewBuilder content: @escaping () -> Content ) {
        self.model = model
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geo in
            self.content()
                .onAppear() {
                    model.statusBarHeight = geo.safeAreaInsets.top
                    model.bottomBarHeight = geo.safeAreaInsets.bottom
                }
        }
    }
}

struct SizeMeasureView_Previews: PreviewProvider {
    static var previews: some View {
        ContentContainerView(model: ContentViewModel()) { }
    }
}
