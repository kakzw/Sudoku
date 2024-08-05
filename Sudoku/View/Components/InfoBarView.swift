//
//  InfoBarView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

struct InfoBarView: View {
  @ObservedObject var sudoku: SudokuModel
  
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State private var time = 0
  
  var body: some View {
    HStack {
      InfoContentView(title: "Difficulty", text: "\(sudoku.getDifficulty().rawValue)")
        .padding(.trailing)
      InfoContentView(title: "Errors", text: "\(sudoku.getError())/3")
        .padding(.leading)
      Spacer()
      InfoContentView(title: "Time", text: "\(formatTime(time))")
        .onReceive(timer) { _ in
          time += 1
        }
    }
  }
  
  // MARK: - Private Functions
  
  /// Format the time into minutes and seconds
  /// - Parameter time: time in seconds
  /// - Returns: string of minutes and seconds
  private func formatTime(_ time: Int) -> String {
    let min = time / 60
    let sec = time % 60
    
    let secStr = sec < 10 ? "0\(sec)" : "\(sec)"
    
    return "\(min):\(secStr)"
  }
}

struct InfoContentView: View {
  var title: String
  var text: String
  
  var body: some View {
    VStack {
      Text("\(title)")
      Text("\(text)")
    }
  }
}

#Preview {
  InfoBarView(sudoku: SudokuModel(difficulty: .medium))
}
