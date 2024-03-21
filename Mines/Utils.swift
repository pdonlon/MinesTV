//
//  Utils.swift
//  Mines
//
//  Created by Philip Donlon on 3/13/24.
//

import Foundation
import SwiftUI

struct EnumeratedForEach<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView

    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }

    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.0) { idx, item in
            content(idx, item)
        }
    }
}

struct HashableTuple: Hashable, CustomStringConvertible {
    let values: (Int, Int)

    init(_ value1: Int, _ value2: Int) {
        self.values = (value1, value2)
    }
        func hash(into hasher: inout Hasher) {
        hasher.combine(values.0)
        hasher.combine(values.1)
    }

    static func == (lhs: HashableTuple, rhs: HashableTuple) -> Bool {
        return lhs.values == rhs.values
    }

    var description: String {
        return "(\(values.0), \(values.1))"
    }
}
