//
//  BoardModelView.swift
//  Mines
//
//  Created by Philip Donlon on 3/12/24.
//

import Foundation
import SwiftUI
import Combine

var bombCount = 10
let height = 10
let width = 10

class BoardModelView: ObservableObject {
    
    var timerSubscriber: AnyCancellable?
    var toOpen = Set<HashableTuple>()
    var bombLocations = Set<HashableTuple>()
    @State var lastUUIDFocused: UUID?
    
    @Published var board = [[Cell]]()
    @Published var isGameOver = false

    var firstTouch = true

    init() {
        makeBoard()
    }
    
    func makeBoard() {
        
        board = []
        
        for _ in 0..<height {
            var row: [Cell] = []
            for _ in 0..<width {
                let cell = Cell()
                row.append(cell)
                print("id:\(cell.id)")

            }
            board.append(row)
        }
    }

    func setlastFocused(id : UUID)
    {
        lastUUIDFocused = id
    }
    
    func addBombs(excludedX: Int, excludedY: Int) {

        bombLocations.removeAll()

        while bombLocations.count < bombCount {
            let x = Int.random(in: 0..<10)
            let y = Int.random(in: 0..<10)
            
            //makes sure no mines are placed around the first touch or repeat mine locations
            if board[x][y].isMine || ( ( x <= excludedX+1 && x >= excludedX-1) && ( y <= excludedY+1 && y >= excludedY-1) ) {
                continue
            }
            board[x][y].isMine = true
            bombLocations.insert(HashableTuple(x, y))
        }
    }

    func setSurrounding() {
        for x in 0..<height {
            for y in 0..<width {
                if board[x][y].isMine {
                    continue
                }
                var surrounding = 0
                for i in -1...1 {
                    for j in -1...1 {
                        if x + i < 0 || x + i >= height || y + j < 0 || y + j >= width {
                            continue
                        }
                        if board[x + i][y + j].isMine {
                            surrounding += 1
                        }
                    }
                }
                board[x][y].minesDetected = surrounding
            }
        }
    }

    //Breadth First Search (Flood Fill Algorithmß)
    func searchCell(_ x: Int, _ y: Int) {
        var queue = [(Int, Int)]()
        queue.append((x, y))

        while !queue.isEmpty {
            let (x, y) = queue.removeFirst()

            if board[x][y].isMine {
                continue
            }

            for i in -1...1 {
                for j in -1...1 {
                    if x + i < 0 || x + i >= height || y + j < 0 || y + j >= width {
                        continue
                    }
                    if !board[x + i][y + j].opened && !toOpen.contains(HashableTuple(x+i, y+j)) && !board[x + i][y + j].isMine {
                        toOpen.insert(HashableTuple(x+i, y+j))
                        if board[x+i][y+j].minesDetected == 0 {
                            queue.append((x + i, y + j))
                        }
                    }
                }
            }
        }
    }
    
    func openCell(x: Int, y: Int) {
        
        if isGameOver {
            return
        }
        
        if firstTouch {
            firstTouch = false
            addBombs(excludedX: x, excludedY: y)
            setSurrounding()
        }

        if board[x][y].isMine {
            gameOver()
            return
        }

        if board[x][y].minesDetected == 0 {
            searchCell(x,y)
        }
        else {
            toOpen.insert(HashableTuple(x, y))
        }
    }

    func gameOver() {
        print("Game Over")
        isGameOver = true
    }

    func explodeRemainingBombs() {
        for tuple in bombLocations {
            board[tuple.values.0][tuple.values.1].opened = true
        }
    }

    func syncTiles(every interval: TimeInterval) {
        timerSubscriber = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.tileFlip()
            }
    }

    func tileFlip() {
        
        if isGameOver {
            explodeRemainingBombs()
            return
        }
        
        if toOpen.count > 0 {
            let tuple = toOpen.removeFirst()
            board[tuple.values.0][tuple.values.1].opened = true
        }
    }
    
    func resetGame() {
     
        makeBoard()
        firstTouch = true
        isGameOver = false
        
    }

}
