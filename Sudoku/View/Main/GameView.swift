//
//  GameView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI
import Combine

struct GameView: View {
  @Environment(\.dismiss) var dismiss
  
  @ObservedObject var sudoku: SudokuModel
  
  private let timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var timerCancellable: Cancellable? = nil
  @State private var time = 0
  @State private var showSettings = false
  
  var body: some View {
    VStack {
      InfoBarView(sudoku: sudoku, time: $time)
        .onReceive(timer) { _ in
          if sudoku.gameCompleted {
            timerCancellable?.cancel()
          } else {
            time += 1
          }
        }
        .onAppear {
          timerCancellable = timer.connect()
        }
        .onDisappear {
          timerCancellable?.cancel()
        }
      GridView(sudoku: sudoku)
      KeyboardView(sudoku: sudoku)
    }
    .padding()
    .navigationTitle("game.title")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
    .navigationDestination(isPresented: $showSettings) {
      SettingsView()
    }
    .navigationDestination(isPresented: $sudoku.gameCompleted) {
      GameCompleteView(
        sudoku: sudoku,
        failed: sudoku.failed,
        time: time
      )
    }
    .toolbar {
      // MARK: Back Button
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("back.button")
          }
        }
        .foregroundStyle(Color(.label))
      }
      
      // MARK: Setting Button
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showSettings = true
        } label: {
          Image(systemName: "gear")
        }
        .foregroundStyle(Color(.label))
      }
    }
    .onAppear {
      Settings.shared.isNote = false
    }
  }
}

#Preview {
  GameView(sudoku: SudokuModel(difficulty: .medium))
}
