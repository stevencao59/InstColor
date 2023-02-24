//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat,
                       nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct NavigationView: View {
    @ObservedObject var model: ContentViewModel

    @State var imageName = "viewfinder"
    @State var sizeWeight = 1
    @State var thumbViewSizeDelta = 0
    
    init(model: ContentViewModel) {
        self.model = model
        self.sizeWeight = Int(model.scaleAmount)
        self.thumbViewSizeDelta = Int(model.thumbViewSizeDelta)
    }
    
    func assignScale(value: Int) {
        model.scaleAmount = Double(value)
    }
    
    func assignDelta(value: Int) {
        model.thumbViewSizeDelta = Double(value)
    }
    
    var body: some View {
        VStack {
            VStack {
                BannerContentView(adUnitId: adUnitID, showBanner: model.isCameraReady)
                    .padding([.bottom])
                ToolBarView(model: model, containerContentWidth: model.containerCotentWidth)
                
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .foregroundColor(.white)
            .background (GeometryReader { geo in
                Color.clear.preference(key: NavigationHeightPreferenceKey.self, value: geo.size.height)
            })
            Spacer()
        }
        .onPreferenceChange(NavigationHeightPreferenceKey.self) {
            model.navigationHeight = $0
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(model: ContentViewModel())
  }
}
