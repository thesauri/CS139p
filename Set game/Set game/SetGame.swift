//
//  SetGame.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-16.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import Foundation

struct SetGame<CardContent> {
    private(set) var cardStack: [SetCard]
    private var indexOfNextUndealtCard: Int = 0
    private var shouldResetSelected = false

    init(cardContentFactory: ((Features) -> CardContent)) {
        cardStack = []
        let featureVersions = FeatureVersion.allCases
        for index in 0..<15 {
            let numberOfShapes = featureVersions[index % 3]
            let shapeType = featureVersions[(index / 3) % 3]
            let shading = featureVersions[(index / 9) % 3]
            let color = featureVersions[(index / 27) % 3]
            let features = Features(numberOfShapes: numberOfShapes, shapeType: shapeType, shading: shading, color: color)
            let cardContent = cardContentFactory(features)
            let currentSetCard = SetCard(id: index, features: features, content: cardContent)
            cardStack.append(currentSetCard)
        }
//        cardStack.shuffle()
        for position in 0..<12 {
            dealCard(at: position)
        }
    }

    struct SetCard: Identifiable {
        let id: Int
        let features: Features
        let content: CardContent
        var dealtState: DealtState = DealtState.inDeck
        var isSelected: Bool = false
        var wasIncorrectlyMatched: Bool = false
    }

    enum DealtState {
        case inDeck
        case dealtAtPosition(Int)
        case matched
    }

    mutating func select(card: SetCard) {
        if shouldResetSelected {
            resetSelectedCards()
            resetIncorrectlyMatchedMarking()
            shouldResetSelected = false
        }

        if let chosenCardIndex = cardStack.firstIndex(matching: card) {
            cardStack[chosenCardIndex].isSelected.toggle()
        }

        if selectedCards.count == 3 {
            print("Hey!")
            if areMatch(cards: selectedCards) {
                selectedCardIndices.forEach { cardIndex in
                    let matchedCardPosition = positionOf(card: cardStack[cardIndex])!
                    cardStack[cardIndex].dealtState = DealtState.matched
                    dealCard(at: matchedCardPosition)
                }
                print("Hey!")
            } else {
                selectedCardIndices.forEach { cardIndex in
                    cardStack[cardIndex].wasIncorrectlyMatched = true
                }
                print("Set was incorrectly matched")
                print(cardStack)
            }
            shouldResetSelected = true
        }
    }

    var selectedCards: [SetCard] {
        cardStack.filter { $0.isSelected }
    }

    var selectedCardIndices: [Int] {
        selectedCards.map { cardStack.firstIndex(matching: $0)! }
    }

    mutating func resetSelectedCards() {
        cardStack.indices.forEach { cardIndex in
            cardStack[cardIndex].isSelected = false
        }
    }

    mutating func resetIncorrectlyMatchedMarking() {
        cardStack.indices.forEach { cardIndex in
            cardStack[cardIndex].wasIncorrectlyMatched = false
        }
    }

    mutating func dealCard(at position: Int) {
        if indexOfNextUndealtCard >= cardStack.count {
            return
        }

        cardStack[indexOfNextUndealtCard].dealtState = DealtState.dealtAtPosition(position)
        indexOfNextUndealtCard += 1
    }

    func positionOf(card: SetCard) -> Int? {
        switch card.dealtState {
        case let .dealtAtPosition(position): return position
        default: return nil
        }
    }

    func areMatch(cards: [SetCard]) -> Bool {
        let numberOfShapes = cards.map { $0.features.numberOfShapes }
        let shapeType = cards.map { $0.features.shapeType }
        let shading = cards.map { $0.features.shading }
        let color = cards.map { $0.features.color }
        return areMatch(featureVersions: numberOfShapes) &&
            areMatch(featureVersions: shapeType) &&
            areMatch(featureVersions: shading) &&
            areMatch(featureVersions: color)
    }

    func areMatch(featureVersions: [FeatureVersion]) -> Bool {
        let featureVersionSet: Set<FeatureVersion> = Set(featureVersions)
        let areDistinctOrSame = featureVersionSet.count == featureVersions.count || featureVersionSet.count == 1
        return areDistinctOrSame
    }
}

struct Features {
    let numberOfShapes: FeatureVersion
    let shapeType: FeatureVersion
    let shading: FeatureVersion
    let color: FeatureVersion
}

enum FeatureVersion: CaseIterable {
    case A
    case B
    case C
}
