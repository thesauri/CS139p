//
//  Diamond.swift
//  Set game
//
//  Created by Walter Berggren on 2020-09-19.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let topCenter = CGPoint(x: rect.midX, y: 0)
        let rightMiddle = CGPoint(x: rect.width, y: rect.midY)
        let bottomCenter = CGPoint(x: rect.midX, y: rect.height)
        let leftMiddle = CGPoint(x: 0, y: rect.midY)

        var p = Path()
        p.move(to: topCenter)
        p.addLine(to: rightMiddle)
        p.addLine(to: bottomCenter)
        p.addLine(to: leftMiddle)
        p.addLine(to: topCenter)
        return p
    }
}
