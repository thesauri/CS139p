//
//  ThemeEditorView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-10-10.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var themeStore: ThemeStore
    var theme: Theme
    @State private var themeName: String = ""
    @State private var emojiToAdd: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Theme editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Done").padding()
                    })
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Theme name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            self.themeStore.renameTheme(self.theme, newName: self.themeName)
                        }
                    })
                }
                Section(header: Text("Add emoji")) {
                    HStack {
                        TextField("Emoji", text: $emojiToAdd)
                        Button(action: {
                            self.themeStore.addEmojisToTheme(self.theme, newEmojis: self.emojiToAdd)
                            self.emojiToAdd = ""
                        }, label: {
                            Text("Add")
                        })
                    }
                }
                Section(header: Text("Touch to remove emojis")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(self.themeStore.theme(id: self.theme.id.uuidString)?.emojis ?? [], id: \.self) { emoji in
                                Button(action: {
                                    if let theme = self.themeStore.theme(id: self.theme.id.uuidString), theme.emojis.count > 2 {
                                        self.themeStore.removeEmojiFromTheme(self.theme, emoji: emoji)
                                    }
                                }, label: {
                                    Text(emoji).font(.largeTitle)
                                })
                            }
                        }
                    }
                }
                Section(header: Text("Card Count")) {
                    HStack {
                        Text("\(self.themeStore.theme(id: self.theme.id.uuidString)?.numberOfPairsOfCards ?? 0) Pairs")
                        Spacer()
                        Stepper(onIncrement: {
                            if let theme = self.themeStore.theme(id: self.theme.id.uuidString), theme.numberOfPairsOfCards < theme.emojis.count {
                                let numberOfPairsOfCards = theme.numberOfPairsOfCards + 1
                                self.themeStore.updatePairCount(for: theme, numberOfPairsOfCards: numberOfPairsOfCards)
                            }
                        }, onDecrement: {
                            if let theme = self.themeStore.theme(id: self.theme.id.uuidString), theme.numberOfPairsOfCards > 2 {
                                let numberOfPairsOfCards = theme.numberOfPairsOfCards - 1
                                self.themeStore.updatePairCount(for: theme, numberOfPairsOfCards: numberOfPairsOfCards)
                            }
                        }, label: {
                            EmptyView()
                        })
                    }
                }
            }
            Spacer()
        }
        .onAppear { self.themeName = self.theme.name }
    }
}
