//
//  ContentView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/1/24.
//

import SwiftUI

struct ContentView: View {
  private var sudoku = SudokuModel(difficulty: .medium)
  
  var body: some View {
    GameView(sudoku: sudoku)
  }
}

#Preview {
  ContentView()
}
