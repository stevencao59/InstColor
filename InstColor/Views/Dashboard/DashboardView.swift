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
                                .bold()
                            HStack {
                                BorderedRectView(color: Color(baseColor), cornerRadius: 40, lineWidth: 1, width: 15, height: 15)
                                Text("\(baseColorName)")
                                    .foregroundColor(.white)
                            }
                        }
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding([.trailing])
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
    @StateObject var resultModel: ColorResultViewModel
    
    init(model: ContentViewModel) {
        self.model = model
        self._resultModel = StateObject(wrappedValue: ColorResultViewModel(camera: model.cameraManager))
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                ColorResultView(model: resultModel)
                Spacer()
                ResultTextContainerView(color: resultModel.color, baseColorName: resultModel.baseColorName, baseColorHex: resultModel.baseColorHex)
            }
            .padding()
            .background(.black)
            .onChange(of: model.averageColor) { color in
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
        .padding([.bottom])
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(model: ContentViewModel())
    }
}
