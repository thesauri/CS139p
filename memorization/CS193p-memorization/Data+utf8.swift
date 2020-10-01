//
//  Data+utf8.swift
//  CS193p-memorization
//
//  Created by Walter Berggren on 2020-10-01.
//  Copyright © 2020 Walter Berggren. All rights reserved.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
