//
//  Item.swift
//  Remiders
//
//  Created by Noel Mac on 1/22/25.
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
