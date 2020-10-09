//
//  EmojiCardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published var theme: MemoryGameThemes.Theme {
        didSet {
            printThemeAsJson()
        }
    }

    @Published private var memoryGame: MemoryGame<String>

    init(theme: MemoryGameThemes.Theme) {
        self.theme = theme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: theme)
        printThemeAsJson()
    }

    private func randomizeThemeAndRestartGame() {
        let randomTheme = MemoryGameThemes.randomTheme()
        self.theme = randomTheme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
    }

    private static func createMemoryGame(theme: MemoryGameThemes.Theme) -> MemoryGame<String> {
        let themeOrRandomPairCount = theme.numberOfPairsOfCards
        return MemoryGame(numberOfCardPairs: themeOrRandomPairCount) { pairIndex in
            theme.emojis[pairIndex]
        }
    }

    private func printThemeAsJson() {
        let encoder = JSONEncoder()
        if let themeAsJson = (try? encoder.encode(theme))?.utf8 {
            print(themeAsJson)
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
        randomizeThemeAndRestartGame()
    }
}
