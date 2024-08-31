//
//  SudokuModel.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/1/24.
//

import SwiftUI
import CoreData

/// Enumeration for the type of input in a sudoku cell
enum InputType {
  case sys  /// system defined value (part of initial puzzle)
  case user /// user defined value (entered by user)
  case error  /// error value (incorrect entry by user)
}

/// Struct representing a cell in sudoku grid
struct Cell {
  var val: Int
  var inputType: InputType
  var note = Set<Int>()
  var backgroundColor = Colors.Default
}

/// Struct representing the state of a cell
/// - NOTE: used for undo functionality
struct CellState {
  var val: Int
  var inputType: InputType
  var note: Set<Int>
  var numFrequency: Array<Int>
  var row: Int
  var col: Int
}

final class SudokuModel: ObservableObject {
  
  // MARK: - Variables
  
  @Published private var sudoku: [[Cell]]
  @Published var gameCompleted = false
  @Published var failed = false
  private var difficulty: Difficulty
  private var solution: [[Cell]]
  private var activeCell: (row: Int, col: Int)? /// currently selected cell
  private var prevActionStack = [CellState]() /// stack for undo actions
  private var errorCount = 0
  private var numFrequency = Array(repeating: 0, count: 9)
  
  // MARK: - Initialization
  
  init(difficulty: Difficulty) {
    self.difficulty = difficulty
    let sudoku = Solutions().getRandomSudoku(difficulty: difficulty)
    self.solution = sudoku
    self.sudoku = []
    loadGrid(solution: sudoku)  /// load grid with the sudoku puzzle
  }
  
  // MARK: - Public Functions
  
  /// Render the cell based on its state
  /// - Parameters:
  ///   - row: row of the cell in the sudoku grid
  ///   - col: column of the cell in the sudoku grid
  ///   - width: width of the cell
  ///   - fontSize: font size to be used for displaying cell's value
  ///   - isSolution: boolean flag indicating whether to use the solution grid or current sudoku grid
  /// - Returns: view of the cell
  func render(row: Int, col: Int, width: CGFloat, fontSize: CGFloat, isSolution: Bool = false) -> some View {
    let grid = isSolution ? self.solution : self.sudoku
    
    let cell = grid[row][col]
    
    /// if no value is inserted in the cell yet, return the note if any
    if cell.val == UNDEFINED { return AnyView(getNote(cell.note, width: width)) }
    
    if cell.inputType == .sys {
      return AnyView(Text("\(cell.val)")
        .font(.system(size: fontSize))
        .foregroundStyle(Color(.label)))
    } else if cell.inputType == .user {
      return AnyView(Text("\(cell.val)")
        .font(.system(size: fontSize))
        .foregroundStyle(Colors.Golden))
    } else {
      return AnyView(Text("\(cell.val)")
        .font(.system(size: fontSize))
        .foregroundStyle(Color(.systemPink)))
    }
  }
  
  /// Set a value to a cell
  /// - Parameters:
  ///   - val: value to set
  ///   - row: row of the cell
  ///   - col: column of the cell
  /// - Returns: whether the value was successfully set
  func setVal(_ val: Int, row: Int, col: Int) -> Bool {
    if val <= 0 || val > 9 { return false }
    if row < 0 || row >= 9 { return false }
    if col < 0 || col >= 9 { return false }
    
    let cell = sudoku[row][col]
    
    /// cannot change predefined value
    if cell.inputType == .sys { return false }
    /// if same number if already entered in the cell, return true
    if cell.val == val { return true }
    
    /// save the current state before making changes
    /// - NOTE: used to undo action
    let currentState = CellState(
      val: cell.val,
      inputType: cell.inputType,
      note: cell.note,
      numFrequency: numFrequency,
      row: row,
      col: col
    )
    prevActionStack.append(currentState)
    
    /// if inserting the value as note
    if Settings.shared.isNote {
      /// if value inserted as note is already in the note, remove it
      if cell.note.contains(val) {
        sudoku[row][col].note.remove(val)
      } else {
        sudoku[row][col].note.insert(val)
      }
      return true
    }
    
    /// if the value is wrong, set input type to error and increment error count
    if val == solution[row][col].val {
      sudoku[row][col].inputType = .user
      numFrequency[val-1] += 1
    } else {
      sudoku[row][col].inputType = .error
      errorCount += 1
      /// if limiting errors and made 3 mistakes, game over
      if Settings.shared.limitErrors && errorCount >= 3 {
        failed = true
        gameCompleted = true
        return true
      }
    }
    
    if Settings.shared.autoRemoveNotes {
      /// auto removes the value inserted from notes in same row, column and square
      removeValFromNote(val: val, row: row, col: col)
    }
    
    /// remove notes from the active cell
    sudoku[row][col].note.removeAll()
    
    /// update the cell with new value
    sudoku[row][col].val = val
    
    /// highlight the inserted value in the grid
    highlightSameVal(val)
    
    /// check if the grid is fully filled
    gameCompleted = isFull()
    return true
  }
  
  /// Undo the last action
  func undo() {
    /// get the previous state from previous action stack
    guard let prevState = prevActionStack.popLast() else { return }
    
    /// reload the previous state
    sudoku[prevState.row][prevState.col].val = prevState.val
    sudoku[prevState.row][prevState.col].inputType = prevState.inputType
    sudoku[prevState.row][prevState.col].note = prevState.note
    numFrequency = prevState.numFrequency
  }
  
  /// Automatically adds possible values as notes to all cells that have not been entered
  func autoAddNote() {
    for row in 0..<9 {
      for col in 0..<9 {
        if sudoku[row][col].val == UNDEFINED {
          addNote(row: row, col: col)
        }
      }
    }
  }
  
  /// Set the active cell
  /// - NOTE: this function is called when any cell is selected
  /// - Parameters:
  ///   - row: row of the cell
  ///   - col: column of the cell
  func setActive(row: Int, col: Int) {
    /// store previously active cell
    let prev = activeCell
    /// update active cell
    activeCell = (row: row, col: col)
    
    /// change the background color of all cells to default
    removeHighlight()
    
    /// if the selected cell is the active cell, deselect the cell
    if prev?.row == activeCell?.row && prev?.col == activeCell?.col {
      activeCell = nil
    } else {
      if Settings.shared.highlightAreas {
        /// highlight cells in the same row as selected cell
        highlightRow(row)
        /// highlight cells in the same column
        highlightCol(col)
        /// highlight cells in the same square
        highlightSquare(row: row, col: col)
      }
      
      /// if selected cell has value in it, highlight cells that has identical values
      if Settings.shared.highlightIdenticalNum && sudoku[row][col].val != UNDEFINED {
        highlightSameVal(sudoku[row][col].val)
      }
      
      /// highlight the selected cell
      sudoku[row][col].backgroundColor = Colors.ActiveBlue
    }
  }
  
  /// Returns currently selected cell
  /// - Returns: row and column of the active cell
  func getActive() -> (row: Int, col: Int)? {
    return activeCell
  }
  
  /// Returns difficulty of current sudoku puzzle
  func getDifficulty() -> Difficulty {
    return difficulty
  }
  
  /// Returns number of errors made
  func getError() -> Int {
    return errorCount
  }
  
  /// Returns frequency of a given number in sudoku grid
  /// - Parameter num: number to get the frequency for (should be between 1 and 9)
  /// - Returns: frequency of the number in grid, or -1 if the number is out of the valid range
  func getFrequency(of num: Int) -> Int {
    /// if the number is outside the valid range (1 to 9), return -1
    if num <= 0 || num > 9 { return -1 }
    return numFrequency[num-1]
  }
  
  /// Deletes value from selected cell
  /// - NOTE: this function is called when delete button is tapped
  func deleteActiveCell() {
    /// if no cell is selected, cannot perform deletion
    guard let activeCell = activeCell else { return }
    
    let row = activeCell.row
    let col = activeCell.col
    
    /// predefined cell (cell with input type of system) cannot be deleted
    if sudoku[row][col].inputType == .sys { return }
    
    /// if the cell has no value, cannot be deleted
    if sudoku[row][col].val == UNDEFINED { return }
    
    /// update frequency before deletion
    let index = sudoku[row][col].val - 1
    numFrequency[index] -= 1
    
    /// perform deletion
    sudoku[row][col].val = UNDEFINED
  }
  
  /// Returns background color of a cell at specified position
  /// - Parameters:
  ///   - row: row of the cell
  ///   - col: column of the cell
  ///   - isSolution: boolean flag indicating whether to use the solution grid or current sudoku grid
  /// - Returns: background color of the cell
  func colorAt(row: Int, col: Int, isSolution: Bool) -> Color {
    /// if solution, background color should be default color for all cells
    if isSolution { return Colors.Default }
    return sudoku[row][col].backgroundColor
  }
  
  func saveData(time: Int, fetchResult: FetchedResults<Stats>, context: NSManagedObjectContext) {
    let won = !Settings.shared.limitErrors || errorCount < 3
    
    var prevStats: Stats? = nil
    for res in fetchResult {
      if res.difficulty == difficulty.rawValue { prevStats = res }
    }
    
    guard let prevStats = prevStats else {
      let stats = Statistic(
        difficulty: difficulty.rawValue,
        gameStarted: 1, 
        gameWon: won ? 1 : 0,
        gameMistake: errorCount == 0 ? 0 : 1,
        bestTime: time,
        totalTime: time,
        currStreak: won ? 1 : 0,
        bestStreak: won ? 1 : 0
      )
      
      DataController().addStats(stats, context: context)
      return
    }
    
    DataController().editStats(
      prevStats,
      s: Statistic(
        difficulty: difficulty.rawValue,
        gameStarted: Int(prevStats.gameStarted) + 1,
        gameWon: Int(won ? prevStats.gameWon + 1 : prevStats.gameWon),
        gameMistake: Int(errorCount == 0 ? prevStats.gameMistake : prevStats.gameMistake + 1),
        bestTime: min(Int(prevStats.bestTime), time),
        totalTime: Int(prevStats.totalTime) + time,
        currStreak: won ? Int(prevStats.currStreak) + 1 : 0,
        bestStreak: Int(won ? (max(prevStats.currStreak+1, prevStats.bestStreak)) : prevStats.bestStreak)
      ),
      context: context
    )
  }
  
  // MARK: - Private Functions
  
  /// Load the grid with the sudoku puzzle
  /// Only inserts number with input type of system
  /// since that is predefined cell
  /// - Parameter solution: solution of current sudoku puzzle
  private func loadGrid(solution: [[Cell]]) {
    /// initialize grid with undefined value and input type of user
    sudoku = Array(repeating: Array(repeating: Cell(val: UNDEFINED, inputType: .user), count: 9), count: 9)
    
    for row in 0..<9 {
      for col in 0..<9 {
        /// if any cell is predifined cell
        /// make it same as corresponding solution cell
        /// (assign predefined value and change input type to system)
        if solution[row][col].inputType == .sys {
          sudoku[row][col] = solution[row][col]
          let index = sudoku[row][col].val - 1
          numFrequency[index] += 1
        }
      }
    }
  }
  
  /// Render the notes in the cell
  /// - Parameters:
  ///   - note: all values added as notes
  ///   - width: width of the cell
  /// - Returns: view that should be displayed in the cell
  private func getNote(_ note: Set<Int>, width: CGFloat) -> some View {
    /// if there are no notes, return empty text view
    if note.isEmpty {
      return AnyView(Text(" "))
    }
    
    /// if there are notes, create a view displaying the notes
    return AnyView(
      VStack {
        /// iterate through 3 rows
        ForEach(0..<3) { i in
          HStack {
            /// iterate through 3 columns
            ForEach(1..<4) { j in
              /// calculate the value that corresponds to this position in the grid
              let val = i * 3 + j
              
              /// check if the note contains the value
              if note.contains(val) {
                /// if the note contains the value, display it
                Text("\(val)")
                  .frame(width: width/9, height: width/9)
                  .minimumScaleFactor(0.5)
                  .lineLimit(1)
              } else {
                /// if the note does not contain the value, display an empty space
                Text(" ")
                  .frame(width: width/9, height: width/9)
                  .minimumScaleFactor(0.5)
                  .lineLimit(1)
              }
            }
          }
        }
      }
    )
  }
  
  /// Checks if sudoku grid is completely filled and correct
  /// - Returns: boolean value indicating whether all cells in the grid have been filled with correct values
  private func isFull() -> Bool {
    for row in 0..<9 {
      for col in 0..<9 {
        /// if any cell's value does not match solution, return false
        if sudoku[row][col].val != solution[row][col].val { return false }
      }
    }
    
    /// remove highlight from all cells
    /// before navigating to `GameCompleteView`
    removeHighlight()
    return true
  }
  
  /// Change the background color of all cells back to default color
  private func removeHighlight() {
    /// iterate through all cells and change the background color to default color
    for row in 0..<9 {
      for col in 0..<9 {
        sudoku[row][col].backgroundColor = Colors.Default
      }
    }
  }
  
  /// Highlight the entire row of the active cell
  /// - Parameter row: row of active cell
  private func highlightRow(_ row: Int) {
    /// in the specified row, iterate through all columns and highlight them
    for col in 0..<9 {
      sudoku[row][col].backgroundColor = Colors.LightBlue
    }
  }
  
  /// Highlight the entire column of the active cell
  /// - Parameter col: column of active cell
  private func highlightCol(_ col: Int) {
    /// iterate through all rows, and highlight specified column
    for row in 0..<9 {
      sudoku[row][col].backgroundColor = Colors.LightBlue
    }
  }
  
  /// Highlight the 3x3 square of the active cell
  /// - Parameters:
  ///   - row: row of active cell
  ///   - col: column of active cell
  private func highlightSquare(row: Int, col: Int) {
    /// this points to upper left corner of the square
    let row: Int = (row / 3) * 3
    let col: Int = (col / 3) * 3
    
    for i in 0..<3 {
      for j in 0..<3 {
        sudoku[row+i][col+j].backgroundColor = Colors.LightBlue
      }
    }
  }
  
  /// Highlight all cells with the same value as the active cell
  /// - Parameter val: value of active cell
  private func highlightSameVal(_ val: Int) {
    for row in 0..<9 {
      for col in 0..<9 {
        if sudoku[row][col].val == val {
          sudoku[row][col].backgroundColor = Colors.DeepBlue
        }
      }
    }
  }
  
  /// Removes a specified value from the notes of all cells in the same row, column, and 3x3 square
  /// - Parameters:
  ///   - val: value to be removed from the notes
  ///   - row: row of the cell where the value was placed
  ///   - col: column of the cell where the value was placed
  private func removeValFromNote(val: Int, row: Int, col: Int) {
    /// remove the value from notes in the same row
    for i in 0..<9 {
      sudoku[row][i].note.remove(val)
    }
    
    /// remove the value from notes in the same column
    for i in 0..<9 {
      sudoku[i][col].note.remove(val)
    }
    
    /// remove the value from notes in the same square
    /// calculate the starting row and column indices of the square
    let row: Int = (row / 3) * 3
    let col: Int = (col / 3) * 3
    /// iterate through each cell in the square
    for i in 0..<3 {
      for j in 0..<3 {
        sudoku[row+i][col+j].note.remove(val)
      }
    }
  }
  
  /// Adds possible values as notes to a specified cell,
  /// excluding values already present in the same row, column or square
  /// - Parameters:
  ///   - row: row of the cell to add notes to
  ///   - col: column of the cell to add notes to
  private func addNote(row: Int, col: Int) {
    /// initialize a set with all possible values (1-9)
    var numSet: Set<Int> = [1,2,3,4,5,6,7,8,9]
    
    /// remove values already present in the same row from the set of possible values
    for i in 0..<9 {
      numSet.remove(sudoku[row][i].val)
    }
    
    /// remove values already present in the same column from the set of possible values
    for i in 0..<9 {
      numSet.remove(sudoku[i][col].val)
    }
    
    /// remove values already present in the same 3x3 square from the set of possible values
    /// calculate the starting row and column indices of the square
    let squareRow: Int = (row / 3) * 3
    let squareCol: Int = (col / 3) * 3
    for i in 0..<3 {
      for j in 0..<3 {
        numSet.remove(sudoku[squareRow+i][squareCol+j].val)
      }
    }
    
    /// add the remaining possible values as notes to the cell
    sudoku[row][col].note = []
    for num in numSet {
      sudoku[row][col].note.insert(num)
    }
  }
}
