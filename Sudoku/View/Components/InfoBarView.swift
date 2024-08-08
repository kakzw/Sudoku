//
//  InfoBarView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

struct InfoBarView: View {
  @ObservedObject var sudoku: SudokuModel
  
  @Binding var time: Int
  
  var body: some View {
    HStack {
      // MARK: Difficulty Text
      InfoContentView(title: "info.difficulty", text: "\(NSLocalizedString(sudoku.getDifficulty().rawValue, comment: ""))")
        .padding(.trailing)
      
      // MARK: Error Text
      if Settings.shared.limitErrors {
        InfoContentView(title: "info.error", text: "\(sudoku.getError())/3")
          .padding(.leading)
      }
      
      Spacer()
      
      // MARK: Timer
      if Settings.shared.useTimer {
        InfoContentView(title: "info.time",
                        text: Helper().formatTime(time))
      }
    }
  }
}

struct InfoContentView: View {
  var title: LocalizedStringResource
  var text: String
  
  var body: some View {
    VStack {
      Text("\(title)")
      Text("\(text)")
    }
  }
}

#Preview {
  InfoBarView(sudoku: SudokuModel(difficulty: .medium),
              time: .constant(145))
}
