//
//  CardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>

    init(numberOfCardPairs: Int, cardContentFactory: ((Int) -> CardContent)) {
        cards = Array<Card>()
        for cardIndex in 0..<numberOfCardPairs {
            let content = cardContentFactory(cardIndex)
            cards.append(Card(content: content, id: cardIndex*2))
            cards.append(Card(content: content, id: cardIndex*2+1))
        }
        cards = cards.shuffled()
    }

    func choose(card: Card) {
        print("Card chosen: \(card)")
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
