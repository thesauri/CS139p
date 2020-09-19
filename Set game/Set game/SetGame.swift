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
        cardStack.shuffle()
    }

    struct SetCard: Identifiable {
        let id: Int
        let features: Features
        let content: CardContent
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
