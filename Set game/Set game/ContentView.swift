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
            Card(card: card)
        }
    }
}

struct Card: View {
    let card: ShapeSetGameCard

    var body: some View {
        VStack {
            ForEach(0..<self.card.numberOfShapes) { index in
                if self.card.isFilled {
                    self.card.content
                        .fill(self.card.color)
                } else {
                    self.card.content
                        .stroke(self.card.color)
                }
            }
            .opacity(card.opacity)
        }
    .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
