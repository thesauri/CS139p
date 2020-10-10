//
//  ThemeChooserView.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-10-09.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct ThemeChooserView: View {
    @EnvironmentObject var themeStore: ThemeStore
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.allThemes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(emojiCardGame: EmojiMemoryGame(theme: theme))) {
                        GeometryReader { geometry in
                            HStack {
                                Circle()
                                    .foregroundColor(Color(theme.color))
                                    .frame(width: geometry.size.height, height: geometry.size.height)
                                VStack(alignment: .leading) {
                                    Text(theme.name)
                                    Text(theme.emojis.joined()).font(.footnote)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.themeStore.allThemes[$0] }.forEach { theme in
                        self.themeStore.removeTheme(theme)
                    }
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    self.themeStore.addUntitledTheme()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }), trailing: EditButton()
            )
            .navigationBarTitle("Memorize")
            .environment(\.editMode, $editMode)
        }
    }
}