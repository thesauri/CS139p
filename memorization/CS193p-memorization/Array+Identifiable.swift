//
//  Array+match.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-09-10.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        self.firstIndex { currentElement in
            currentElement.id == matching.id
        }
    }
}
