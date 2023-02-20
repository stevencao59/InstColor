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

struct DominantColorsView: View {
    let colors: [UIColor]?
    
    var body: some View {
        HStack {
            if let colors {
                ForEach(colors, id: \.self) { color in
                    BorderedRectView(color: Color(color), cornerRadius: 20, lineWidth: 1, width: 20, height: 20)
                }
                Spacer()
                Text("Dominant Colors: \(colors.count)")
                    .bold()
                    .font(.footnote)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .animation(.easeIn, value: colors)
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
                if model.frameSource == .wholeImage {
                    DominantColorsView(colors: resultModel.dominantColors)
                } else {
                    ColorResultView(model: resultModel)
                    Spacer()
                    if let color = resultModel.color {
                        ResultTextContainerView(color: color, baseColorName: resultModel.baseColorName, baseColorHex: resultModel.baseColorHex)
                    }
                }
            }
            .padding()
            .background(.black)
            .onChange(of: model.averageColor) { color in
                resultModel.color = color
            }
            .onChange(of: model.dominantColors) { colors in
                resultModel.dominantColors = colors
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
