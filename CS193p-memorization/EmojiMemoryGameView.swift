//
//  ContentView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-03.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var emojiCardGame: EmojiMemoryGame

    var body: some View {
        NavigationView {
            Grid(emojiCardGame.cards) { card in
                Card(card: card, themeColor: self.emojiCardGame.theme.color).onTapGesture {
                    self.emojiCardGame.choose(card: card)
                }
                .padding()
            }
            .navigationBarTitle("Score: \(emojiCardGame.score)")
            .navigationBarItems(
                leading: Text(emojiCardGame.theme.name),
                trailing: Button("New game") {
                    self.emojiCardGame.restartGame()
                }
            )
        }
    }
}

struct Card: View {
    var card: MemoryGame<String>.Card
    var themeColor: Color

    var body: some View {
        GeometryReader() { geometry in
            ZStack() {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(self.themeColor)
                    Pie(
                        startAngle: Angle.degrees(0-90),
                        endAngle: Angle.degrees(110-90),
                        clockwise: true
                    )
                        .padding(5)
                        .opacity(0.4)
                    Text(self.card.content)
                        .font(.system(size: self.fontSize(for: geometry.size)))
                } else {
                    if !self.card.isMatched {
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .fill(self.themeColor)
                    }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }

    // MARK: - Constants
    private let emojiSizeScalingFactor: CGFloat = 0.75
    private let cornerRadius: CGFloat = 10.0
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[1])
        return EmojiMemoryGameView(emojiCardGame: game)
    }
}
