//
//  ContentView.swift
//  Mines
//
//  Created by Philip Donlon on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = BoardModelView()
    @State private var showingGameOverPopup = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                EnumeratedForEach(viewModel.board)
                { rowIdx, row in
                    HStack(spacing: 0) {
                        EnumeratedForEach(row) { colIdx, cell in
                            CellView(onFlip:  {
                                viewModel.openCell(x: rowIdx, y: colIdx)
                            }, cell: cell)
                        }
                    }
                }
                .imageScale(.large)
                .foregroundStyle(.tint)
            }
            .disabled(showingGameOverPopup)
            .padding()
            .onAppear() {
                viewModel.syncTiles(every: 0.01)
            }
            if showingGameOverPopup {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .ignoresSafeArea() // This dims the background
                
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.black)
                    
                    Button(action: {
                        showingGameOverPopup = false
                        viewModel.resetGame()
                    }) {
                        Text("Try Again?")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(width: 500, height: 500)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
            }

        }.onReceive(viewModel.$isGameOver) { isGameOver in
            if isGameOver {
                showingGameOverPopup = true
            }
        }
    }
}
