//
//  DifficultySelectionView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/7/24.
//

import SwiftUI

struct DifficultySelectionView: View {
  @State private var startGame = false
  @State private var difficulty = Difficulty.easy
  
  var body: some View {
    VStack {
      ForEach(Difficulty.allCases) { ele in
        VStack {
          Button {
            /// after selecting a difficulty
            /// start a new game with the difficulty
            difficulty = ele
            startGame = true
          } label: {
            Text(NSLocalizedString(ele.rawValue, comment: ""))
              .foregroundColor(Colors.Blue)
          }
          if ele != Difficulty.allCases.last {
            Divider()
          }
        }
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(20)
    .shadow(radius: 5)
    .navigationDestination(isPresented: $startGame) {
      GameView(sudoku: SudokuModel(difficulty: difficulty))
    }
  }
}

#Preview {
  DifficultySelectionView()
}
