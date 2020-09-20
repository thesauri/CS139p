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
        NavigationView {
            VStack {
                game()
                dealThreeMoreCardsButton()
            }
            .navigationBarTitle("Set game")
            .navigationBarItems(trailing: Button("New Game") {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.shapeSetGame.newGame()
                }
            })
        }
    }

    func game() -> some View {
        GeometryReader { geometry in
            Grid(self.shapeSetGame.dealtCards) { card in
                Card(card: card)
                    .padding()
                    .onTapGesture {
                        self.shapeSetGame.select(card: card)
                }
            }
        }
    }

    func dealThreeMoreCardsButton() -> some View {
        Button(action: {
            self.shapeSetGame.dealThreeMoreCards()
        }) {
            Text("Deal 3 More Cards")
        }
        .disabled(shapeSetGame.isDeckEmpty)
        .padding()
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
        .transition(AnyTransition.offset(randomOffset(radius: 1000)))
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

    func randomOffset(radius: Int) -> CGSize {
        let angle = Double.random(in: 0..<2*Double.pi)
        let x = Double(radius) * cos(angle)
        let y = Double(radius) * sin(angle)
        return CGSize(width: x, height: y)
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
