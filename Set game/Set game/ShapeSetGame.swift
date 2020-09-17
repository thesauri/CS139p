//
//  ShapeSetGame.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-17.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ShapeSetGame {
    private var setGame: SetGame<Path>

    init() {
        self.setGame = SetGame { features in
            return Rectangle().path(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
    }

    // MARK: - Access to the model
    var cardStack: [SetGame<Path>.SetCard] {
        setGame.cardStack
    }

    var visibleCards: [SetGame<Path>.SetCard] {
        Array(setGame.cardStack[0..<12])
    }
}
