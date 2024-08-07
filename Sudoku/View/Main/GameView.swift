//
//  GameView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

struct GameView: View {
  @Environment(\.dismiss) var dismiss
  
  var sudoku: SudokuModel
  
  @State private var showSettings = false
  
  var body: some View {
    VStack {
      InfoBarView(sudoku: sudoku)
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
