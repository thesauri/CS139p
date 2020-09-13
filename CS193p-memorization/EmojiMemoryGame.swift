//
//  EmojiCardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var theme: MemoryGameTheme
    @Published private var memoryGame: MemoryGame<String>

    init() {
        let randomTheme = MemoryGameThemes.randomTheme()
        self.theme = randomTheme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
    }

    static func createMemoryGame(theme: MemoryGameTheme) -> MemoryGame<String> {
        let themeOrRandomPairCount = theme.numberOfPairsOfCards ?? Int.random(in: 2...theme.emojis.count)
        return MemoryGame(numberOfCardPairs: themeOrRandomPairCount) { pairIndex in
            theme.emojis[pairIndex]
        }
    }

    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }

    var themeColor: Color {
        theme.color
    }

    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }
}
