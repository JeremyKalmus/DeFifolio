//
//  Item.swift
//  DeFifolio
//
//  Created by Jeremy Kalmus on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
