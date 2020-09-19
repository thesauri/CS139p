//
//  ShapeSetGame.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-17.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ShapeSetGame {
    private var setGame: SetGame<SetShape>

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

    var visibleCards: [ShapeSetGameCard] {
        Array(setGame.cardStack[0..<12])
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
    let roundedRectangleCornerRadius: CGFloat = 8
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
        case .C: return Color.orange
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
