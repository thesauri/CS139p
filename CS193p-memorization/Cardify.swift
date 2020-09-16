//
//  Cardify.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-16.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var themeColor: Color

    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .stroke(themeColor)
                content
            } else {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill(self.themeColor)
            }
        }
            .aspectRatio(2/3, contentMode: .fit)
    }

    // MARK: - Drawing constants
    private let cornerRadius: CGFloat = 10.0
}

extension View {
    func cardify(isFaceUp: Bool, themeColor: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, themeColor: themeColor))
    }
}
