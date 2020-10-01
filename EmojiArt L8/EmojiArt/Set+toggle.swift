//
//  Set+toggle.swift
//  EmojiArt
//
//  Created by Walter Berggren on 2020-10-01.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

extension Set where Element : Hashable {
    mutating func toggle(_ member: Element) {
        if self.contains(member) {
            self.remove(member)
        } else {
            self.insert(member)
        }
    }
}
