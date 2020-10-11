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
    @State private var editingTheme: Theme?

    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.allThemes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(emojiCardGame: EmojiMemoryGame(theme: theme))) {
                        GeometryReader { geometry in
                            HStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(theme.color))
                                        .frame(width: geometry.size.height, height: geometry.size.height)
                                    if self.editMode == .active {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                if self.editMode == .active && self.editingTheme == nil {
                                                    self.editingTheme = theme
                                                }
                                        }
                                    }
                                }
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
            .sheet(item: self.$editingTheme) { theme in
                ThemeEditor(theme: theme)
                    .environmentObject(self.themeStore)
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
