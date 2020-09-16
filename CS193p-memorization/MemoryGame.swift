//
//  CardGame.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-04.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    private var potentialSelectedCardIndex: Int?
    private(set) var score: Int = 0

    init(numberOfCardPairs: Int, cardContentFactory: ((Int) -> CardContent)) {
        cards = Array<Card>()
        for cardIndex in 0..<numberOfCardPairs {
            let content = cardContentFactory(cardIndex)
            cards.append(Card(content: content, id: cardIndex*2))
            cards.append(Card(content: content, id: cardIndex*2+1))
        }
        cards = cards.shuffled()
    }

    mutating func choose(card: Card) {
        let chosenCardIndex = cards.firstIndex(matching: card)!

        if cards[chosenCardIndex].isMatched || cards[chosenCardIndex].isFaceUp {
            return
        }

        if let previouslyChosenCardIndex = potentialSelectedCardIndex {
            let haveMatchingContent = cards[chosenCardIndex].content == cards[previouslyChosenCardIndex].content
            if haveMatchingContent {
                cards[chosenCardIndex].isFaceUp = true
                cards[chosenCardIndex].isMatched = true
                cards[previouslyChosenCardIndex].isMatched = true
                potentialSelectedCardIndex = nil

                score += 2
            } else {
                cards[chosenCardIndex].isFaceUp = true
                potentialSelectedCardIndex = nil

                score += cards[chosenCardIndex].isSeen ? -1 : 0
                score += cards[previouslyChosenCardIndex].isSeen ? -1 : 0
            }
            cards[chosenCardIndex].isSeen = true
            cards[previouslyChosenCardIndex].isSeen = true
        } else {
            turnAllCardsFaceDown()
            cards[chosenCardIndex].isFaceUp = true
            potentialSelectedCardIndex = chosenCardIndex
        }
    }

    mutating func turnAllCardsFaceDown() {
        for cardIndex in cards.indices {
            cards[cardIndex].isFaceUp = false
        }
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
