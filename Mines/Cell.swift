//
//  MinesModel.swift
//  Mines
//
//  Created by Philip Donlon on 3/12/24.
//

import Foundation
import SwiftUI

class Cell : ObservableObject, Hashable, Identifiable {
    
    var id = UUID()
    @Published var opened: Bool = false
    var minesDetected: Int = 0
    var isMine: Bool = false
    @Published var isFlagged: Bool = false
    var board = [[Cell]]()
    
    init() {
    }

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.opened == rhs.opened && lhs.minesDetected == rhs.minesDetected && lhs.isMine == rhs.isMine && lhs.isFlagged == rhs.isFlagged
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(opened)
        hasher.combine(minesDetected)
        hasher.combine(isMine)
        hasher.combine(isFlagged)
    }
    
}

struct CellView: View {
    
    var onFlip: () -> Void
    
    @State var isShowingInspector = false
    @FocusState var isButtonFocused: Bool?
    @State var lastButtonPressed: UUID?
    @ObservedObject var cell: Cell

    var size = 100.0
    
    var colorHashmap: [Int: Color] = [0: .gray, 1: .green, 2: .red, 3: .yellow, 4: .orange, 5: .purple, 6: .pink, 7: .gray, 8: .white]
    var numberEmojis = [" ","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣"]

    var body: some View {
        ZStack {
            // This Rectangle will fill the entire frame
            Rectangle()
                .fill(cell.opened ? (colorHashmap[cell.minesDetected] ?? .white) : .clear)

            Group {
                if cell.opened {
                    Button(action: {
                        lastButtonPressed = cell.id
                        print()
                    },  label: {
                         if cell.isMine {
                                                          
                            Text("💣").frame(width: size, height: size)
                        }
                        else {
                            Text("\(numberEmojis[cell.minesDetected])").frame(width: size, height: size)
                        }
                    }).frame(width: size, height: size)
                        .clipShape(.rect)

                }
                else
                {
                    Button(action: {
                        lastButtonPressed = cell.id
                        if !cell.isFlagged {
                            onFlip()
                        }
                        else {
                            cell.isFlagged.toggle()
                        }
                    }, label: {
                        if cell.isFlagged {
                            Text("🚩").frame(width: size, height: size)
                        }
                        else
                        {
                            Text(" ").frame(width: size, height: size)
                        }
                    }
                    )
//                    .buttonStyle(.bordered)
//                        .buttonBorderShape(.roundedRectangle)
                        .frame(width: size, height: size)
                        .clipShape(.rect)
                    .onPlayPauseCommand {
                        cell.isFlagged.toggle()
                        print("FLAGGED")
                    }
                    .padding(0)
                }
            }
        }
        .focused($isButtonFocused, equals: lastButtonPressed == cell.id)
        .frame(width: size, height: size)
        .border(Color.black, width: 1)
    }

}


