//
//  GameView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

struct GameView: View {
  var sudoku: SudokuModel
  
  var body: some View {
    VStack {
      InfoBarView(sudoku: sudoku)
      GridView(sudoku: sudoku)
      KeyboardView(sudoku: sudoku)
    }
    .padding()
  }
}

#Preview {
  GameView(sudoku: SudokuModel(difficulty: .medium))
}
