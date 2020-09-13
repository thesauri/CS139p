//
//  EmojiCardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published var theme: MemoryGameThemes.Theme
    @Published private var memoryGame: MemoryGame<String>

    init() {
        let randomTheme = MemoryGameThemes.randomTheme()
        self.theme = randomTheme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
    }

    private func randomizeThemeAndRestartGame() {
        let randomTheme = MemoryGameThemes.randomTheme()
        self.theme = randomTheme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
    }

    static func createMemoryGame(theme: MemoryGameThemes.Theme) -> MemoryGame<String> {
        let themeOrRandomPairCount = theme.numberOfPairsOfCards ?? Int.random(in: 2...theme.emojis.count)
        return MemoryGame(numberOfCardPairs: themeOrRandomPairCount) { pairIndex in
            theme.emojis[pairIndex]
        }
    }

    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }

    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }

    func restartGame() {
        randomizeThemeAndRestartGame()
    }
}
