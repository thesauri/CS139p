//
//  Spinning.swift
//  EmojiArt
//
//  Created by Walter Berggren on 2020-10-08.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear { self.isVisible = true }
    }
}

extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
