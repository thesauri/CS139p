//
//  ShapeSetGame.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-17.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    @Published private var setGame: SetGame<SetShape>

    init() {
        self.setGame = SetGame { features in
            let setShape = SetShape(shapeType: features.shapeType)
            return setShape
        }
    }

    // MARK: - Access to the model
    var cardStack: [ShapeSetGameCard] {
        setGame.cardStack
    }

    var dealtCards: [ShapeSetGameCard] {
        let dealtUnsortedCards = setGame.cardStack.filter { card in
            switch card.dealtState {
            case .dealtAtPosition(_): return true
            default: return false
            }
        }
        let dealtCardsInOrder = dealtUnsortedCards.sorted {
            switch ($0.dealtState, $1.dealtState) {
            case let (.dealtAtPosition(aPosition), .dealtAtPosition(bPosition)):
                return aPosition < bPosition
            default: return false
            }
        }
        return dealtCardsInOrder
    }

    var isDeckEmpty: Bool {
        setGame.cardStack.filter { card in
            switch card.dealtState {
            case .inDeck: return true
            default: return false
            }
        }.count == 0
    }

    // MARK: - Intents
    func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
    }

    func select(card: ShapeSetGameCard) {
        setGame.select(card: card)
    }

    func newGame() {
        self.setGame = SetGame { features in
            let setShape = SetShape(shapeType: features.shapeType)
            return setShape
        }
    }
}

struct SetShape: Shape {
    let shapeType: FeatureVersion

    func path(in rect: CGRect) -> Path {
        switch shapeType {
        case .A: return Rectangle().path(in: rect)
        case .B: return RoundedRectangle(cornerRadius: roundedRectangleCornerRadius).path(in: rect)
        case .C: return Diamond().path(in: rect)
        }
    }

    // MARK: - Shape constants
    let roundedRectangleCornerRadius: CGFloat = 16
}

extension ShapeSetGameCard {
    var numberOfShapes: Int {
        switch self.features.numberOfShapes {
        case .A: return 1
        case .B: return 2
        case .C: return 3
        }
    }

    var color: Color {
        switch self.features.color {
        case .A: return Color.green
        case .B: return Color.yellow
        case .C: return Color.blue
        }
    }

    var isFilled: Bool {
        let filledIfNotOutlined = self.features.shading != FeatureVersion.C
        return filledIfNotOutlined
    }

    var opacity: Double {
        switch self.features.shading {
        case .A: return 1.0
        case .B: return 0.5
        case .C: return 1.0
        }
    }
}

typealias ShapeSetGameCard = SetGame<SetShape>.SetCard
