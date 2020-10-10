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
            }
            Spacer()
        }
        .onAppear { self.themeName = self.theme.name }
    }
}
