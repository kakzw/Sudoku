//
//  GridView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/3/24.
//

import SwiftUI

struct GridView: View {
  @ObservedObject var sudoku: SudokuModel
  
  private let frameSize: CGFloat = Screen.cellWidth * 9
  
  var body: some View {
    ZStack {
      renderStructure(width: frameSize/9)
      renderOverlayLines(width: frameSize/9)
    }
    .frame(width: frameSize,
           height: frameSize,
           alignment: .center)
  }
  
  // MARK: - Private Functions
  
  /// Render the grid structure
  /// - Parameter width: width of each cell
  /// - Returns: view representing sudoku grid
  private func renderStructure(width: CGFloat) -> some View {
    VStack(spacing: -1) {
      /// iterate through each row
      ForEach(0..<9) { row in
        HStack(spacing: -1) {
          /// iterate through each column
          ForEach(0..<9) { col in
            /// render each cell
            sudoku.render(row: row, col: col, width: width)
              .frame(width: width, height: width)
              .border(Color.black, width: 1)
              .padding(.all, 0)
              .background(sudoku.colorAt(row: row, col: col))
              .onTapGesture {
                /// set the tapped cell as active cell
                sudoku.setActive(row: row, col: col)
              }
          }
        }
      }
    }
  }
  
  /// Render the overlay lines for the grid
  /// - Parameter width: width of each cell
  /// - Returns: overlay lines that separetes squares
  private func renderOverlayLines(width: CGFloat) -> some View {
    /// use GeometryReader to get the size of the container for drawing lines
    GeometryReader { geometry in
      /// create a path to draw lines
      Path { path in
        /// calculate distance between thicker lines (each 3x3 square)
        let factor: CGFloat = width * 3
        /// lines to draw to create 2 thick lines, separating grid into 3x3 sections
        let lines: [CGFloat] = [1, 2]
        
        /// draw vertical lines
        for i: CGFloat in lines {
          /// calculate x position for each vertical line
          let xpos: CGFloat = i * factor
          /// move to the start point of the vertical line
          path.move(to: CGPoint(x: xpos, y: 4))
          /// draw the line from the top to the bottom of the grid
          path.addLine(to: CGPoint(x: xpos, y: geometry.size.height - 4))
        }
        
        /// draw horizontal lines
        for i: CGFloat in lines {
          /// calculate the y position for each horizontal line
          let ypos: CGFloat = i * factor
          path.move(to: CGPoint(x: 4, y: ypos))
          path.addLine(to: CGPoint(x: geometry.size.width - 4, y: ypos))
        }
      }
      .stroke(lineWidth: Screen.lineThickness)
      .foregroundColor(.black)
    }
  }
}

#Preview {
  GridView(sudoku: SudokuModel(difficulty: .medium))
}
