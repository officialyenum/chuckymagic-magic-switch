//
//  Settings.swift
//  MagicSwitch
//
//  Created by Chukwuyenum Opone on 29/02/2020.
//  Copyright © 2020 Chukwuyenum Opone. All rights reserved.
//

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let elementCategory: UInt32 = 0x1        // 01
    static let switchCategory: UInt32 = 0x1 << 1    // 10
}

enum ZPositions {
    static let labelZ = 0
    static let elementZ = 1
    static let ringZ = 2
}
