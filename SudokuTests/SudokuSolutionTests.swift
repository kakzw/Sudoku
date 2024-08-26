//
//  SudokuSolutionTests.swift
//  SudokuSolutionTests
//
//  Created by Kento Akazawa on 8/6/24.
//

import XCTest
@testable import Sudoku

final class SudokuSolutionTests: XCTestCase {
  
  private var solutions: Solutions!
  
  override func setUpWithError() throws {
    solutions = Solutions()
  }
  
  override func tearDownWithError() throws {
    solutions = nil
  }
  
  // MARK: - Test Functions
  
  /// Test to validate all sudoku solutions
  func testSolutions() {
    for difficulty in Difficulty.allCases {
      for sudoku in solutions.getSudoku(difficulty: difficulty) {
        validateSolution(of: sudoku)
      }
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  // MARK: - Private Functions
  
  /// Validate the entire sudoku solution by checking rows, columns, and 3x3 squares
  /// - Parameter sudoku: sudoku to validate
  private func validateSolution(of sudoku: [[Cell]]) {
    XCTAssertTrue(validateRow(of: sudoku))
    XCTAssertTrue(validateCol(of: sudoku))
    XCTAssertTrue(validateSquare(of: sudoku))
  }
  
  /// Validate all rows in sudoku
  /// - Parameter sudoku: 2D array representing sudoku, where each element is a `Cell` object
  /// - Returns: boolean indicating whether each row in the sudoku contains numbers 1 through 9 exactly once
  private func validateRow(of sudoku: [[Cell]]) -> Bool {
    /// iterate through each row in sudoku
    for row in 0..<9 {
      /// create a set to track the numbers in the current row
      var numSet = Set<Int>()
      
      /// iterate through each column in the current row
      for col in 0..<9 {
        /// value of the current cell
        let val = sudoku[row][col].val
        
        /// if value is already in the set (indicating a duplicate), return false
        /// otherwise, add the value to the set
        if numSet.contains(val) { return false }
        numSet.insert(val)
      }
      
      /// ensure the row contains all numbers from 1 to 9
      for i in 1...9 {
        /// if any number from 1-9 is not found in the set, the row is invalid
        if !numSet.contains(i) { return false }
      }
    }
    
    return true
  }
  
  /// Validate all columns in sudoku
  /// - Parameter sudoku: 2D array representing sudoku
  /// - Returns: boolean indicating whether each column in the sudoku contains numbers 1 through 9 exactly once
  private func validateCol(of sudoku: [[Cell]]) -> Bool {
    /// iterate through each column in sudoku
    for col in 0..<9 {
      /// create a set to track the numbers in the current row
      var numSet = Set<Int>()
      
      /// iterate through each row in sudoku
      for row in 0..<9 {
        /// value of the current cell
        let val = sudoku[row][col].val
        
        /// if value is already in the set (indicating a duplicate), return false
        /// otherwise, add the value to the set
        if numSet.contains(val) { return false }
        numSet.insert(val)
      }
      
      /// ensure the row contains all numbers from 1 to 9
      for i in 1...9 {
        if !numSet.contains(i) { return false }
      }
    }
    
    return true
  }
  
  /// Validate all 3x3 squares in sudoku
  /// - Complexity: O(1) considering all sudoku puzzle is limited to 9x9 and
  ///               this function iterates through each cell only once
  /// - Parameter sudoku: 2D array representing sudoku
  /// - Returns: boolean indicating whether each 3x3 square in sudoku contains numbers 1 through 9 exactly once
  private func validateSquare(of sudoku: [[Cell]]) -> Bool {
    /// iterate through each 3x3 square in the grid
    for l in 0..<3 {
      for r in 0..<3 {
        /// create a set to track the numbers in the current 3x3 square
        var numSet = Set<Int>()
        
        /// iterate over each cell in the current 3x3 square
        for i in 0..<3 {
          for j in 0..<3 {
            /// calculate row and column indices for the current cell
            let row = l*3 + i
            let col = r*3 + j
            /// value of the current cell
            let val = sudoku[row][col].val
            
            /// if value is already in the set (indicating a duplicate), return false
            /// otherwise, add the value to the set
            if numSet.contains(val) { return false }
            numSet.insert(val)
          }
        }
        
        /// ensure the row contains all numbers from 1 to 9
        for i in 1...9 {
          if !numSet.contains(i) { return false }
        }
      }
    }
    
    return true
  }
}
