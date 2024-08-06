//
//  Solutions.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/2/24.
//

import SwiftUI

enum Difficulty: String {
  case easy = "Easy"
  case medium = "Medium"
  case hard = "Hard"
}

final class Solutions {
  private var easySudoku: [[[Cell]]]
  private var mediumSudoku: [[[Cell]]]
  private var hardSudoku: [[[Cell]]]
  
  // - MARK: - Initialization
  
  init() {
    self.easySudoku = []
    self.mediumSudoku = [medium1]
    self.hardSudoku = []
  }
  
  // MARK: - Public Functions
  
  /// Returns a random sudoku puzzle based on specified difficulty level
  /// - Parameter difficulty: difficulty level of desired sudoku puzzle
  /// - Returns: 2D array of cell representing sudoku grid for specified difficulty
  func getRandomSudoku(difficulty: Difficulty) -> [[Cell]] {
    switch difficulty {
    case .easy:
      let index = Int.random(in: 0..<easySudoku.count)
      return easySudoku[index]
    case .medium:
      let index = Int.random(in: 0..<mediumSudoku.count)
      return mediumSudoku[index]
    case .hard:
      let index = Int.random(in: 0..<hardSudoku.count)
      return hardSudoku[index]
    }
  }
  
  // MARK: - List of easy sudoku
  
  private let easy1: [[Cell]] = [
    [Cell(val: 1, inputType: .sys), Cell(val: 5, inputType: .sys), Cell(val: 9, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 4, inputType: .sys), Cell(val: 2, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 8, inputType: .user), Cell(val: 6, inputType: .sys)],
    [Cell(val: 2, inputType: .sys), Cell(val: 7, inputType: .sys), Cell(val: 4, inputType: .sys), Cell(val: 5, inputType: .sys), Cell(val: 6, inputType: .sys), Cell(val: 8, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 1, inputType: .sys), Cell(val: 9, inputType: .user)],
    [Cell(val: 8, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 7, inputType: .sys), Cell(val: 4, inputType: .sys), Cell(val: 5, inputType: .user), Cell(val: 2, inputType: .sys)],
    [Cell(val: 7, inputType: .user), Cell(val: 1, inputType: .sys), Cell(val: 8, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 2, inputType: .user), Cell(val: 6, inputType: .user), Cell(val: 5, inputType: .user), Cell(val: 4, inputType: .sys), Cell(val: 3, inputType: .user)],
    [Cell(val: 4, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 8, inputType: .user), Cell(val: 5, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 6, inputType: .user), Cell(val: 2, inputType: .user), Cell(val: 7, inputType: .user)],
    [Cell(val: 5, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 2, inputType: .user), Cell(val: 4, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 3, inputType: .sys), Cell(val: 1, inputType: .sys), Cell(val: 9, inputType: .sys), Cell(val: 8, inputType: .user)],
    [Cell(val: 3, inputType: .user), Cell(val: 2, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 8, inputType: .user), Cell(val: 5, inputType: .sys), Cell(val: 9, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 4, inputType: .user)],
    [Cell(val: 9, inputType: .sys), Cell(val: 8, inputType: .sys), Cell(val: 5, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 3, inputType: .sys), Cell(val: 4, inputType: .user), Cell(val: 2, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 1, inputType: .user)],
    [Cell(val: 6, inputType: .user), Cell(val: 4, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 2, inputType: .sys), Cell(val: 1, inputType: .sys), Cell(val: 9, inputType: .sys), Cell(val: 8, inputType: .sys), Cell(val: 3, inputType: .sys), Cell(val: 5, inputType: .user)]
  ]
  
  // MARK: - List of medium sudoku
  
  private let medium1: [[Cell]] =  [
    [Cell(val: 2, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 8, inputType: .user), Cell(val: 4, inputType: .user), Cell(val: 7, inputType: .sys), Cell(val: 5, inputType: .user), Cell(val: 3, inputType: .sys), Cell(val: 9, inputType: .user), Cell(val: 6, inputType: .user)],
    [Cell(val: 7, inputType: .sys), Cell(val: 5, inputType: .user), Cell(val: 3, inputType: .sys), Cell(val: 9, inputType: .sys), Cell(val: 1, inputType: .sys), Cell(val: 6, inputType: .sys), Cell(val: 2, inputType: .user), Cell(val: 8, inputType: .user), Cell(val: 4, inputType: .user)],
    [Cell(val: 4, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 3, inputType: .user), Cell(val: 8, inputType: .sys), Cell(val: 2, inputType: .user), Cell(val: 1, inputType: .sys), Cell(val: 5, inputType: .sys), Cell(val: 7, inputType: .user)],
    [Cell(val: 5, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 1, inputType: .sys), Cell(val: 8, inputType: .user), Cell(val: 9, inputType: .sys), Cell(val: 4, inputType: .sys), Cell(val: 6, inputType: .user), Cell(val: 7, inputType: .user), Cell(val: 2, inputType: .user)],
    [Cell(val: 8, inputType: .user), Cell(val: 2, inputType: .user), Cell(val: 7, inputType: .user), Cell(val: 1, inputType: .sys), Cell(val: 6, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 5, inputType: .user), Cell(val: 4, inputType: .user), Cell(val: 9, inputType: .user)],
    [Cell(val: 6, inputType: .user), Cell(val: 4, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 5, inputType: .user), Cell(val: 2, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 8, inputType: .sys), Cell(val: 3, inputType: .user), Cell(val: 1, inputType: .user)],
    [Cell(val: 9, inputType: .user), Cell(val: 6, inputType: .sys), Cell(val: 2, inputType: .sys), Cell(val: 7, inputType: .user), Cell(val: 3, inputType: .user), Cell(val: 8, inputType: .user), Cell(val: 4, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 5, inputType: .sys)],
    [Cell(val: 3, inputType: .user), Cell(val: 7, inputType: .sys), Cell(val: 4, inputType: .user), Cell(val: 6, inputType: .user), Cell(val: 5, inputType: .sys), Cell(val: 1, inputType: .user), Cell(val: 9, inputType: .user), Cell(val: 2, inputType: .sys), Cell(val: 8, inputType: .sys)],
    [Cell(val: 1, inputType: .user), Cell(val: 8, inputType: .sys), Cell(val: 5, inputType: .user), Cell(val: 2, inputType: .user), Cell(val: 4, inputType: .user), Cell(val: 9, inputType: .sys), Cell(val: 7, inputType: .sys), Cell(val: 6, inputType: .sys), Cell(val: 3, inputType: .user)]
  ]
  
  // MARK: - Test Functions
  
  func getSudoku(difficulty: Difficulty) -> [[[Cell]]] {
    switch difficulty {
    case .easy:
      return easySudoku
    case .medium:
      return mediumSudoku
    case .hard:
      return hardSudoku
    }
  }
}
