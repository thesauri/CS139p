//
//  ContentView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-03.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var emojiCardGame: EmojiMemoryGame

    var body: some View {
        HStack() {
            ForEach(emojiCardGame.cards.filter { !($0.isMatched && !$0.isFaceUp) }) { card in
                Card(card: card).onTapGesture {
                    self.emojiCardGame.choose(card: card)
                }
            }
        }
            .padding()
    }
}

struct Card: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader() { geometry in
            ZStack() {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(Color.orange)
                    Text(self.card.content)
                        .font(.system(size: self.emojiSizeScalingFactor * min(geometry.size.width, geometry.size.height)))
                } else {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .fill(Color.orange)
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
        ContentView(emojiCardGame: EmojiMemoryGame())
    }
}
