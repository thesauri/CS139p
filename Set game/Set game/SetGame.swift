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

    init(cardContentFactory: ((Features) -> CardContent)) {
        cardStack = []
        let featureVersions = FeatureVersion.allCases
        for index in 0..<81 {
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
    }

    struct SetCard: Identifiable {
        let id: Int
        let features: Features
        let content: CardContent
        var isSelected: Bool = false
    }

    mutating func select(card: SetCard) {
        if let chosenCardIndex = cardStack.firstIndex(matching: card) {
            cardStack[chosenCardIndex].isSelected.toggle()
        }

        if selectedCards.count == 3 {
            if areMatch(cards: selectedCards) {
                print("Yay!")
            } else {
                print("Nay")
            }
        }
    }

    var selectedCards: [SetCard] {
        cardStack.filter { $0.isSelected }
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
