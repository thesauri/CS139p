//
//  MemoryGameTheme.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-12.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct MemoryGameThemes {
    static let themes: [Theme] = [
        Theme(name: "Faces", emojis: ["🦠", "🌭", "🤓", "💨", "🇸🇪"], color: Color.yellow),
        Theme(name: "Happy Faces", emojis: ["😁", "🤓", "🙂", "😍", "😎"], color: Color.yellow, numberOfPairsOfCards: 5),
        Theme(name: "Sad Faces", emojis: ["😔", "🙁", "😩", "🥺", "😭"], color: Color.red, numberOfPairsOfCards: 5),
        Theme(name: "Fruits", emojis: ["🍎", "🍐", "🍆", "🍑", "🍌"],  color: Color.green),
        Theme(name: "Vehicles", emojis: ["🚗", "✈️", "🚂", "🛺", "🚀"], color: Color.blue),
        Theme(name: "Weapons", emojis: ["💣", "⚔️", "🔫", "🔪", "💩"], color: Color.black)
    ]

    static func randomTheme() -> Theme {
        MemoryGameThemes.themes.randomElement()!
    }

    struct Theme {
        var name: String
        var emojis: [String]
        var color: Color
        var numberOfPairsOfCards: Int?
    }
}
