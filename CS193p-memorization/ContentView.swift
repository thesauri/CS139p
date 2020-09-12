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
            ForEach(emojiCardGame.cards.filter { !$0.isMatched }) { card in
                Card(card: card).onTapGesture {
                    self.emojiCardGame.choose(card: card)
                }
            }
        }
            .padding()
            .font(emojiCardGame.cards.count / 2 == 5 ? Font.title : Font.largeTitle)
    }
}

struct Card: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        ZStack() {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange)
            }
        }
            .aspectRatio(2/3, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(emojiCardGame: EmojiMemoryGame())
    }
}
