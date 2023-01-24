//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct ResultTextContainerView: View {
    let color: UIColor
    let baseColorName: String
    let baseColorHex: String
    
    @State var showBaseColor = false
    
    func toggleShowBaseColor() {
        showBaseColor.toggle()
    }
    
    var body: some View {
        Button(action: toggleShowBaseColor) {
            VStack {
                if showBaseColor {
                    if let baseColor = UIColor(hex: baseColorHex) {
                        VStack {
                            Text("Family Color:")
                                .foregroundColor(.white)
                                .bold()
                            HStack {
                                BorderedRectView(color: Color(baseColor), cornerRadius: 40, lineWidth: 1, width: 15, height: 15)
                                Text("\(baseColorName)")
                                    .foregroundColor(.white)
                            }
                        }
                        .font(.caption)
                        .padding([.bottom, .trailing])
                    }
                } else {
                    ColorTextGroupView(components: color.components)
                }
            }
            .animation(.easeIn, value: showBaseColor)
        }
    }
}


struct DashboardView: View {
    @ObservedObject var model: ContentViewModel
    @StateObject private var resultModel = ColorResultViewModel()

    var body: some View {
        VStack {
            Spacer()
            if let color = model.averageColor {
                HStack(alignment: .center) {
                    ColorResultView(color: color, colorName: resultModel.colorName, baseColorName: resultModel.baseColorName)
                    Spacer()
                    ResultTextContainerView(color: color, baseColorName: resultModel.baseColorName, baseColorHex: resultModel.baseColorHex)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .onChange(of: color) { color in
                    resultModel.color = color
                }
                .modifier(FloatToolbarViewModifier(model: model))
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
        .padding([.bottom])
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(model: ContentViewModel())
    }
}
