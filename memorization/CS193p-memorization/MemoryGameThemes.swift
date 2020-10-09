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
        Theme(name: "Random", emojis: ["🦠", "🌭", "🤓", "💨", "🇸🇪"], color: Colors.peterRiver, numberOfPairsOfCards: 5),
        Theme(name: "Happy Faces", emojis: ["😁", "🤓", "🙂", "😍", "😎"], color: Colors.sunFlower, numberOfPairsOfCards: 5),
        Theme(name: "Sad Faces", emojis: ["😔", "🙁", "😩", "🥺", "😭"], color: Colors.alizarin, numberOfPairsOfCards: 5),
        Theme(name: "Fruits", emojis: ["🍎", "🍐", "🍆", "🍑", "🍌"],  color: Colors.emerald, numberOfPairsOfCards: 5),
        Theme(name: "Vehicles", emojis: ["🚗", "✈️", "🚂", "🛺", "🚀"], color: Colors.wetAsphalt, numberOfPairsOfCards: 5),
        Theme(name: "Weapons", emojis: ["💣", "⚔️", "🔫", "🔪", "💩"], color: Colors.wetAsphalt, numberOfPairsOfCards: 5)
    ]

    struct Colors {
        static let wetAsphalt: UIColor.RGB = UIColor.RGB(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        static let peterRiver: UIColor.RGB = UIColor.RGB(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        static let sunFlower: UIColor.RGB = UIColor.RGB(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        static let alizarin: UIColor.RGB = UIColor.RGB(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        static let emerald: UIColor.RGB = UIColor.RGB(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    }

    static func randomTheme() -> Theme {
        MemoryGameThemes.themes.randomElement()!
    }

    struct Theme: Identifiable, Codable {
        let id: UUID = UUID()
        var name: String
        var emojis: [String]
        var color: UIColor.RGB
        var numberOfPairsOfCards: Int
    }
}
