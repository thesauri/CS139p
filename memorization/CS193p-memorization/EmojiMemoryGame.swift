//
//  EmojiCardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published var theme: Theme

    @Published private var memoryGame: MemoryGame<String>

    init(theme: Theme) {
        self.theme = theme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let themeOrRandomPairCount = theme.numberOfPairsOfCards
        return MemoryGame(numberOfCardPairs: themeOrRandomPairCount) { pairIndex in
            theme.emojis[pairIndex]
        }
    }

    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }

    var score: Int {
        memoryGame.score
    }

    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }

    func restartGame() {
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }
}
