//
//  FavoritesView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct RowTextView: View {
    var text: String
    var color: Double

    var body: some View {
        HStack {
            Text(text)
                .bold()
            Text("\(Int(color * 255))")
        }
    }
}

struct FavoriteColorRow: View {
    var title: String
    var uiColor: UIColor
    
    var body: some View {
        HStack {
            VStack {
                BorderedRectView(color: Color(uiColor), cornerRadius: 10, lineWidth: 1, width: UIScreen.screenWidth / 3, height: defaultItemSize)
                Text(title)
                    .bold()
            }
            Spacer()
            VStack(alignment: .leading) {
                RowTextView(text: "R: ", color: uiColor.components.red)
                RowTextView(text: "G: ", color: uiColor.components.green)
                RowTextView(text: "B: ", color: uiColor.components.blue)
            }
            .font(.footnote)
        }
    }
}

struct FavoritesView: View {
    @State var favoriteColors: [FavoriteColor]?
    @State var selectedColor = UIColor(.white)
    @State private var showAlertWindow = false

    var containerCotentWidth = 0.0

    init(favoriteColors: [FavoriteColor]? = nil, selectedColor: UIColor = UIColor(.white), showAlertWindow: Bool = false, containerCotentWidth: Double = 0.0) {
        self.favoriteColors = favoriteColors
        self.selectedColor = selectedColor
        self.showAlertWindow = showAlertWindow
        self.containerCotentWidth = containerCotentWidth
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func deleteFavorites(at offsets: IndexSet) {
        if var favoriteColors {
            favoriteColors.remove(atOffsets: offsets)
            UserDefaults.standard.setColor(favoriteColors, forKey: favoritColorKey)
            self.favoriteColors = favoriteColors
        }
    }
    
    func clearFavorites() {
        UserDefaults.standard.removeObject(forKey: favoritColorKey)
        self.favoriteColors = nil
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                if let favoriteColors {
                    List {
                        ForEach(favoriteColors) { color in
                            let uiColor = UIColor(red: color.red, green: color.green, blue: color.blue)
                            let title = uiColor.calculateClosestColor(colorMap: Settings.shared.colorMap).Color
                            let colors = [DetectedColor(color: uiColor)]
                            NavigationLink(destination: ColorDetailView(colors: colors, showModalButtons: false, selectedDetent: .large)) {
                                FavoriteColorRow(title: title, uiColor: uiColor)
                            }
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteFavorites)
                        .listRowSeparator(.automatic)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CloseButtonView()
                        }
                        ToolbarItem {
                            Button(action: {
                                showAlertWindow = true
                            }) {
                                Text("Clear")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .navigationTitle("Favorites")
                    .navigationBarTitleDisplayMode(.inline)
                    .scrollContentBackground(.hidden)
                    .background(.black)
                    .alert("Are you sure to clear all favorite colors?", isPresented: $showAlertWindow) {
                        Button("Clear", role: .destructive) {
                            clearFavorites()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
                else {
                    PlaceholderView(placeholderImageName: "folder.badge.plus", placeholderText: "No Favorite Color is saved")
                }
            }
        }
        .foregroundColor(.white)
        .onAppear() {
            favoriteColors = UserDefaults.standard.readColor(forKey: favoritColorKey)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteColorRow(title: "Pure Red", uiColor: UIColor(.red))
    }
}
