//
//  MemoryGameTheme.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-12.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

enum MemoryGameThemes: CaseIterable {
    case faces

    static func randomTheme() -> MemoryGameTheme {
        let themeCase = MemoryGameThemes.allCases.randomElement()
        return theme(for: themeCase)
    }

    static func theme(for themeCase: MemoryGameThemes?) -> MemoryGameTheme {
        switch themeCase {
            case .faces: return FacesTheme()
            default: return FacesTheme()
        }
    }
}

protocol MemoryGameTheme {
    var name: String { get }
    var emojis: [String] { get }
    var color: Color { get }
    var numberOfPairsOfCards: Int? { get }
}

struct FacesTheme: MemoryGameTheme {
    var name: String = "Faces"
    var emojis: [String] = ["🦠", "🌭", "🤓", "💨", "🇸🇪"]
    var color: Color = Color.yellow
    var numberOfPairsOfCards: Int? = 5
}
