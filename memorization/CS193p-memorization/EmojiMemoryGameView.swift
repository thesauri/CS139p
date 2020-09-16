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
                    withAnimation(.linear(duration: 0.75)) {
                        self.emojiCardGame.choose(card: card)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Score: \(emojiCardGame.score)")
            .navigationBarItems(
                leading: Text(emojiCardGame.theme.name),
                trailing: Button("New game") {
                    withAnimation(.easeInOut) {
                        self.emojiCardGame.restartGame()
                    }
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
            self.body(for: geometry.size)
        }
    }

    @State private var animatedBonusRemaining: Double = 0
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if self.card.isFaceUp || !self.card.isMatched {
            ZStack() {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-animatedBonusRemaining*360-90),
                            clockwise: true
                        )
                        .onAppear {
                            self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(
                            startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                            clockwise: true
                        )
                    }
                }
                .padding(5)
                .opacity(0.4)
                Text(self.card.content)
                    .font(.system(size: self.fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 0.75).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: self.card.isFaceUp, themeColor: self.themeColor)
            .transition(AnyTransition.scale)
        }
    }

    // MARK: - Constants
    private let emojiSizeScalingFactor: CGFloat = 0.75
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
