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
            let currentFeatures = (
                featureVersions[index % 3],
                featureVersions[(index / 3) % 3],
                featureVersions[(index / 9) % 3],
                featureVersions[(index / 27) % 3]
            )
            let cardContent = cardContentFactory(currentFeatures)
            let currentSetCard = SetCard(id: index, features: currentFeatures, content: cardContent)
            cardStack.append(currentSetCard)
        }
        cardStack.shuffle()
    }

    struct SetCard: Identifiable {
        let id: Int
        let features: Features
        let content: CardContent
    }

    typealias Features = (FeatureVersion, FeatureVersion, FeatureVersion, FeatureVersion)

    enum FeatureVersion: CaseIterable {
        case A
        case B
        case C
    }
}
