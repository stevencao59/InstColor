//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct DashboardView: View {
    let color: UIColor?
    @Binding var dashboardHeight: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            if let color = color {
                HStack(alignment: .center) {
                    ColorResultView(color: color)
                    Spacer()
                    ColorTextGroupView(components: color.components)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .opacity(0.9)
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                print("Dashboard Height is \(geo.size.height)")
                                dashboardHeight = geo.size.height
                            }
                    }
                )

            }
        }

    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(color: UIColor(.white), dashboardHeight: .constant(10))
    }
}
