//
//  ToolBarView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct ToolBarView: View {
    @ObservedObject var model: ContentViewModel

    @State var showAbout: Bool = false
    @State var showFavorites: Bool = false
    @State var showReferences: Bool = false
    @State var showHistory: Bool = false
    
    var containerCotentWidth: CGFloat
    
    init(model: ContentViewModel, containerContentWidth: CGFloat) {
        self.model = model
        self.containerCotentWidth = containerContentWidth
    }
    
    func toggleFavorites() {
        showFavorites.toggle()
    }
    
    func toggleReferences() {
        showReferences.toggle()
    }

    func toggleAbout() {
        showAbout.toggle()
    }

    func toggleHistory() {
        showHistory.toggle()
    }
    
    var body: some View {
        HStack {
            Group {
                Button(action: toggleFavorites) {
                    ImageButtonView(imageName: "heart")
                }
                Button(action: toggleReferences) {
                    ImageButtonView(imageName: "list.bullet")
                }
                Button(action: toggleHistory) {
                    ImageButtonView(imageName: "clock")
                }
                Button(action: toggleAbout) {
                    ImageButtonView(imageName: "questionmark")
                        .foregroundColor(.white)
                }

            }
            .padding([.bottom, .horizontal])
            .scaleEffect(1.2)
            .fullScreenCover(isPresented: $showFavorites) {
                FavoritesView(containerCotentWidth: containerCotentWidth)
            }
            .onChange(of: showFavorites) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
            .fullScreenCover(isPresented: $showReferences) {
                ReferencesView(containerCotentWidth: containerCotentWidth)
            }
            .onChange(of: showReferences) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
            .fullScreenCover(isPresented: $showAbout) {
                AboutView()
            }
            .onChange(of: showAbout) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
            .fullScreenCover(isPresented: $showHistory) {
                HistoryView()
            }
            .onChange(of: showHistory) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(model: ContentViewModel(), containerContentWidth: 300)
    }
}
