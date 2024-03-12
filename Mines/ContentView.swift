//
//  ContentView.swift
//  Mines
//
//  Created by Philip Donlon on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var board: [[Cell]] = []
    
    
    var body: some View {
        VStack {
            ForEach(board, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        if cell.opened {
                            Text("Bye")
                                .frame(width: 100)
                        }
                        else
                        {
                            Button(action: {
                                print("hi")
                            }, label: {
                                Text("Hi")
                            })
                            .frame(width: 100)
                        }
                        
                    }
                }
            }
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .onAppear() {
            let height = 10
            let width = 10
            
            for _ in 0..<height {
                var row: [Cell] = []
                for _ in 0..<width {
                    let cell = Cell()
                    row.append(cell)
                }
                board.append(row)
            }

            //mark some cells in the middle as opened for debugging
            board[4][4].opened = true
            board[4][5].opened = true
            board[5][4].opened = true
            board[5][5].opened = true

        }
    }
    
    mutating func startGame() {
        makeBoard()
    }
    
    mutating func makeBoard() {
        
        let height = 10
        let width = 10
        
        for _ in 0..<height {
            var row: [Cell] = []
            for _ in 0..<width {
                let cell = Cell()
                row.append(cell)
            }
            board.append(row)
        }
    }
}

#Preview {
    ContentView()
}
