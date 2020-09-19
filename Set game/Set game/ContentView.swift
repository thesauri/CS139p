//
//  ContentView.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-16.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var shapeSetGame = ShapeSetGame()

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    func body(for size: CGSize) -> some View {
        Grid(shapeSetGame.dealtCards) { card in
            Card(card: card)
                .padding()
                .onTapGesture {
                    self.shapeSetGame.select(card: card)
            }
        }
    }
}

struct Card: View {
    let card: ShapeSetGameCard

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(card.wasIncorrectlyMatched ? Color.red : card.color, lineWidth: card.isSelected ? selectedLineWidth : unselectedLineWidth)
            content(of: card)
        }
    }

    func content(of card: ShapeSetGameCard) -> some View{
        VStack {
            ForEach(0..<card.numberOfShapes) { index in
                if card.isFilled {
                    card.content
                        .fill(card.color)
                } else {
                    card.content
                        .stroke(card.color)
                }
            }
            .opacity(card.opacity)
        }
        .padding()
    }

    // MARK: - Drawing constants
    let cardCornerRadius: CGFloat = 16
    let selectedLineWidth: CGFloat = 4
    let unselectedLineWidth: CGFloat = 1
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
