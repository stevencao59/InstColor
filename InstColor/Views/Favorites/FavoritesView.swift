//
//  FavoritesView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct FavoritesView: View {
    @State var favoriteColors: [FavoriteColor]?
    
    var body: some View {
        ZStack{
            if let favoriteColors {
                List(favoriteColors) { color in
                    let uiColor = UIColor(red: color.red, green: color.green, blue: color.blue)
                    let title = uiColor.calculateClosestColor()?.English ?? "Unknown Color"
                    HStack {
                        BorderedRectView(color: Color(uiColor), cornerRadius: 15, lineWidth: 5, width: 100, height: 50)
                        Spacer()
                        Text(title)
                            .font(.caption)
                    }
                }
            } else {
                Text("No Favorite Color is saved!")
            }
        }
        .onAppear() {
            favoriteColors = UserDefaults.standard.readColor(forKey: "FavoriteColors")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
