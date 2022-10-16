//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct DashboardView: View {
    let color: UIColor?
    let location: CGPoint?
    let rectSize: CGSize?
    
    var locationXText: String {
        return "X: \(String(format: "%.0f", location?.x ?? CGFloat(0)))"
    }
    
    var locationYText: String {
        return "Y: \(String(format: "%.0f", location?.y ?? CGFloat(0)))"
    }
    
    var widthText: String {
        return "W: \(String(format: "%.0f", rectSize?.width ?? CGFloat(0)))"
    }
    
    var heightText: String {
        return "H: \(String(format: "%.0f", rectSize?.height ?? CGFloat(0)))"
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let color = color {
                HStack(alignment: .center) {
                    ColorResultView(color: color)
                    Spacer()
                    VStack {
                        Text(locationXText)
                            .font(.footnote)
                        Text(locationYText)
                            .font(.footnote)
                        Text(widthText)
                            .font(.footnote)
                        Text(heightText)
                            .font(.footnote)
                    }
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
        DashboardView(color: UIColor(.white), location: CGPoint(x: 100, y: 50), rectSize: CGSize(width: 50, height: 50))
    }
}
