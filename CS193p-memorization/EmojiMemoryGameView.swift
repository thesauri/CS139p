//
//  ContentView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-03.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var emojiCardGame: EmojiMemoryGame

    var body: some View {
        NavigationView {
            Grid(emojiCardGame.cards) { card in
                Card(card: card, themeColor: self.emojiCardGame.theme.color).onTapGesture {
                    self.emojiCardGame.choose(card: card)
                }
                .padding()
            }
            .navigationBarTitle(emojiCardGame.theme.name)
            .navigationBarItems(trailing:
                Button("New game") {
                    self.emojiCardGame.restartGame()
                }
            )
        }
    }
}

struct Card: View {
    var card: MemoryGame<String>.Card
    var themeColor: Color

    var body: some View {
        GeometryReader() { geometry in
            ZStack() {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(self.themeColor)
                    Text(self.card.content)
                        .font(.system(size: self.emojiSizeScalingFactor * min(geometry.size.width, geometry.size.height)))
                } else {
                    if !self.card.isMatched {
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .fill(self.themeColor)
                    }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }

    // MARK: - Constants
    let emojiSizeScalingFactor: CGFloat = 0.75
    let cornerRadius: CGFloat = 10.0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(emojiCardGame: EmojiMemoryGame())
    }
}
