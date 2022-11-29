//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var model: ContentViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if let color = model.averageColor {
                HStack(alignment: .center) {
                    ColorResultView(color: color, containerCotentWidth: model.containerCotentWidth)
                    Spacer()
                    ColorTextGroupView(components: color.components)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                model.dashboardHeight = geo.size.height
                            }
                    }
                )
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(model: ContentViewModel())
    }
}
