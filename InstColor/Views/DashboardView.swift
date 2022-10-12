//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct DashboardView: View {
    let color: UIColor?
    
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
                .animation(.easeInOut, value: 0.25)
            }
        }

    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(color: UIColor(.white))
    }
}
