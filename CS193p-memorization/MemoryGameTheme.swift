//
//  MemoryGameTheme.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-12.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

enum MemoryGameThemes: CaseIterable {
    case mixedTheme
    case happyFaces
    case sadFaces
    case fruits
    case vehicles
    case weapons

    static func randomTheme() -> MemoryGameTheme {
        let themeCase = MemoryGameThemes.allCases.randomElement()
        return theme(for: themeCase)
    }

    static func theme(for themeCase: MemoryGameThemes?) -> MemoryGameTheme {
        switch themeCase {
            case .mixedTheme: return MixedTheme()
            case .happyFaces: return HappyFaces()
            case .sadFaces: return SadFaces()
            case .fruits: return Fruits()
            case .vehicles: return Vehicles()
            case .weapons: return Weapons()
            default: return MixedTheme()
        }
    }
}

protocol MemoryGameTheme {
    var name: String { get }
    var emojis: [String] { get }
    var color: Color { get }
    var numberOfPairsOfCards: Int? { get }
}

struct MixedTheme: MemoryGameTheme {
    var name: String = "Faces"
    var emojis: [String] = ["🦠", "🌭", "🤓", "💨", "🇸🇪"]
    var color: Color = Color.yellow
    var numberOfPairsOfCards: Int?
}

struct HappyFaces: MemoryGameTheme {
    var name: String = "Happy Faces"
    var emojis: [String] = ["😁", "🤓", "🙂", "😍", "😎"]
    var color: Color = Color.yellow
    var numberOfPairsOfCards: Int? = 5
}

struct SadFaces: MemoryGameTheme {
    var name: String = "Sad Faces"
    var emojis: [String] = ["😔", "🙁", "😩", "🥺", "😭"]
    var color: Color = Color.red
    var numberOfPairsOfCards: Int? = 5
}

struct Fruits: MemoryGameTheme {
    var name: String = "Fruits"
    var emojis: [String] = ["🍎", "🍐", "🍆", "🍑", "🍌"]
    var color: Color = Color.green
    var numberOfPairsOfCards: Int?
}

struct Vehicles: MemoryGameTheme {
    var name: String = "Vehicles"
    var emojis: [String] = ["🚗", "✈️", "🚂", "🛺", "🚀"]
    var color: Color = Color.blue
    var numberOfPairsOfCards: Int?
}

struct Weapons: MemoryGameTheme {
    var name: String = "Weapons"
    var emojis: [String] = ["💣", "⚔️", "🔫", "🔪", "💩"]
    var color: Color = Color.black
    var numberOfPairsOfCards: Int?
}
