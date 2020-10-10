//
//  MemoryGameTheme.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-12.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI
import Combine

class ThemeStore: ObservableObject {
    @Published private var themes = [String:Theme]()
    private var autosave: AnyCancellable?

    init() {
        let defaultsKey = "MemorizationGameThemeStore"
        themes = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        autosave = $themes.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
        if themes.isEmpty {
            addDefaultThemes()
        }
    }

    private func addDefaultThemes() {
        let themes = [
            Theme(name: "Random", emojis: ["🦠", "🌭", "🤓", "💨", "🇸🇪"], color: ThemeColors.peterRiver, numberOfPairsOfCards: 5),
            Theme(name: "Happy Faces", emojis: ["😁", "🤓", "🙂", "😍", "😎"], color: ThemeColors.sunFlower, numberOfPairsOfCards: 5),
            Theme(name: "Sad Faces", emojis: ["😔", "🙁", "😩", "🥺", "😭"], color: ThemeColors.alizarin, numberOfPairsOfCards: 5),
            Theme(name: "Fruits", emojis: ["🍎", "🍐", "🍆", "🍑", "🍌"],  color: ThemeColors.emerald, numberOfPairsOfCards: 5),
            Theme(name: "Vehicles", emojis: ["🚗", "✈️", "🚂", "🛺", "🚀"], color: ThemeColors.wetAsphalt, numberOfPairsOfCards: 5),
            Theme(name: "Weapons", emojis: ["💣", "⚔️", "🔫", "🔪", "💩"], color: ThemeColors.wetAsphalt, numberOfPairsOfCards: 5)
        ]
        for theme in themes {
            addTheme(theme)
        }
    }

    // MARK: - Access
    var allThemes: [Theme] {
        [Theme](themes.values).sorted { $0.name < $1.name }
    }

    // MARK: - Intents
    func addTheme(_ theme: Theme) {
        self.themes[theme.name] = theme
    }

    func addUntitledTheme() {
        let defaultTheme = Theme(name: "Untitled", emojis: ["🇸🇪", "🇫🇮"], color: ThemeColors.wetAsphalt, numberOfPairsOfCards: 2)
        addTheme(defaultTheme)
    }

    func removeTheme(_ theme: Theme) {
        self.themes[theme.name] = nil
    }
}

struct ThemeColors {
    static let wetAsphalt: UIColor.RGB = UIColor.RGB(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    static let peterRiver: UIColor.RGB = UIColor.RGB(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    static let sunFlower: UIColor.RGB = UIColor.RGB(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
    static let alizarin: UIColor.RGB = UIColor.RGB(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    static let emerald: UIColor.RGB = UIColor.RGB(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
}

struct Theme: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    var name: String
    var emojis: [String]
    var color: UIColor.RGB
    var numberOfPairsOfCards: Int
}

extension Dictionary where Key == String, Value == Theme {
    var asPropertyList: [String:String] {
        var nameToEncodedTheme = [String:String]()
        let encoder = JSONEncoder()
        for (name, theme) in self {
            nameToEncodedTheme[name] = try! encoder.encode(theme).utf8
        }
        return nameToEncodedTheme
    }

    init(fromPropertyList plist: Any?) {
        self.init()
        let nameToEncodedTheme = plist as? [String:String] ?? [:]
        let decoder = JSONDecoder()
        for (name, encodedTheme) in nameToEncodedTheme {
            let encodedThemeData = encodedTheme.data(using: .utf8)!
            let theme = try! decoder.decode(Theme.self, from: encodedThemeData)
            self[name] = theme
        }
    }
}
