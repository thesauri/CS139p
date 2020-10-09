//
//  ThemeChooserView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-10-09.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ThemeChooserView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmojiMemoryGameView(emojiCardGame: EmojiMemoryGame())) {
                    Text("Hello world")
                }
            }
            .navigationBarTitle("Memorize")
        }
    }
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView()
    }
}
