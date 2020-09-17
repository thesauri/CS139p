//
//  ContentView.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-16.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var shapeSetGame = ShapeSetGame()

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    func body(for size: CGSize) -> some View {
        Grid(shapeSetGame.visibleCards) { card in
            card.content
        }
    }
}

struct Card: View {
    let card: SetGame<Path>.SetCard

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.orange)
            card.content
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
