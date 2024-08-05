//
//  KeyboardView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/3/24.
//

import SwiftUI

struct KeyboardView: View {
  @ObservedObject var sudoku: SudokuModel
  @ObservedObject var setting = Setting.shared
  
  var body: some View {
    VStack {
      optionRow
      numRow
    }
  }
  
  var optionRow: some View {
    HStack {
      Spacer()
      
      // MARK: Undo Button
      Button {
        sudoku.undo()
      } label: {
        OptionBtnView(img: "arrow.counterclockwise", text: "Undo")
      }
      
      Spacer()
      
      // MARK: Delete Button
      Button {
        sudoku.deleteActiveCell()
      } label: {
        OptionBtnView(img: "eraser.line.dashed", text: "Delete")
      }
      
      Spacer()
      
      // MARK: Note Button
      Button {
        setting.isNote.toggle()
      } label: {
        OptionBtnView(img: "square.and.pencil", text: "Note")
      }
      
      Spacer()
      
      // MARK: Hint Button
      Button {
        // TODO: add a button that shows hint
      } label: {
        OptionBtnView(img: "lightbulb", text: "Hint")
      }
      
      Spacer()
    }
  }
  
  /// Render the row with number buttons
  var numRow: some View {
    HStack(spacing: -1) {
      ForEach(1..<10) { num in
        Button {
          insertVal(num)
        } label: {
          Text("\(num)")
            .font(.system(size: fontSize * 1.2))
            .foregroundStyle(
              setting.isNote ? Colors.Gray : Colors.Blue
            )
        }
        .opacity(sudoku.getFrequency(of: num) >= 9 ? 0 : 1)
        .frame(width: Screen.cellWidth, height: Screen.cellWidth)
        .padding(.all, 0)
      }
    }
  }
  
  // MARK: - Private Functions
  
  /// Insert the value into the active cell
  /// - Parameter val: value to insert
  private func insertVal(_ val: Int) {
    guard let active = sudoku.getActive() else { return }
    
    if sudoku.setVal(val, row: active.row, col: active.col) {
      sudoku.objectWillChange.send()
    }
  }
}

struct OptionBtnView: View {
  var img: String
  var text: String
  
  private let btnSize: CGFloat = Screen.cellWidth / 2
  
  var body: some View {
    VStack {
      Image(systemName: "\(img)")
        .frame(width: btnSize)
        .foregroundStyle(Colors.Golden)
      Text("\(text)")
        .foregroundStyle(Color(.label))
        .font(.system(size: btnSize))
    }
  }
}

#Preview {
  KeyboardView(sudoku: SudokuModel(difficulty: .medium))
}
