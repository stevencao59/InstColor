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
            BorderedRectView(color: Color(uiColor), cornerRadius: 50, lineWidth: 2, width: 100, height: 50)
            Text(title)
                .bold()
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
    let colorMap: [RGBColor]

    init(favoriteColors: [FavoriteColor]? = nil, selectedColor: UIColor = UIColor(.white), showAlertWindow: Bool = false, containerCotentWidth: Double = 0.0) {
        self.favoriteColors = favoriteColors
        self.selectedColor = selectedColor
        self.showAlertWindow = showAlertWindow
        self.containerCotentWidth = containerCotentWidth
        self.colorMap = Bundle.main.decode("color.json")
        
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
                            let title = uiColor.calculateClosestColor(colorMap: colorMap).Color
                            NavigationLink(destination: ColorDetailView(color: uiColor, showModalButtons: false, selectedDetent: .large)) {
                                FavoriteColorRow(title: title, uiColor: uiColor)
                            }
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteFavorites)
                        .listRowSeparator(.automatic)
                        .listRowSeparatorTint(.white)
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
                    ZStack {
                        Rectangle()
                            .fill(.black)
                        VStack {
                            Image(systemName: "folder.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.screenWidth / 4)
                                .padding()
                            Text("No Favorite Color is saved")
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CloseButtonView()
                        }
                    }
                    .background(.black)
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
