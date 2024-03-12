//
//  MinesModel.swift
//  Mines
//
//  Created by Philip Donlon on 3/12/24.
//

import Foundation

class Cell : Hashable {
    
    var opened: Bool = false
    var minesDetected: Int = 0
    var isMine: Bool = false
    var flagged: Bool = false
    
    init() {
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs === rhs
    }
    
}
