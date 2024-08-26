//
//  GameCompleteView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/8/24.
//

import SwiftUI

struct GameCompleteView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  
  @FetchRequest(sortDescriptors: [SortDescriptor(\.difficulty)]) var statsData: FetchedResults<Stats>
  
  var sudoku: SudokuModel
  var time: Int
  
  @State private var startNewGame = false
  @State private var showMainView = false
  
  var body: some View {
    VStack {
      Spacer()
      
      // MARK: Title
      Text("complete.title")
        .font(.system(size: 40))
      
      // MARK: Sudoku Grid
      GridView(sudoku: sudoku,
               frameSize: Screen.cellWidth * 9 * 0.6,
               cellFontSize: FontSize.cell * 0.6,
               isSolution: true)
      .padding(.vertical)
      
      // MARK: Stats
      stats
        .background(Colors.LightCyan)
        .cornerRadius(20)
        .padding(.horizontal)
      
      Spacer()
      
      // MARK: Buttons
      continueButton
      
      mainButton
        .padding(.bottom)
    }
    .background(Colors.Cyan)
    .navigationBarBackButtonHidden()
    .navigationDestination(isPresented: $startNewGame) {
      GameView(sudoku: SudokuModel(difficulty: sudoku.getDifficulty()))
    }
    .navigationDestination(isPresented: $showMainView) {
      ContentView()
    }
    .onAppear {
      sudoku.saveData(time: time,
                      fetchResult: statsData,
                      context: managedObjContext)
    }
  }
  
  var stats: some View {
    VStack {
      // MARK: Difficulty Stats
      StatsView(
        img: "chart.bar.fill",
        title: "info.difficulty",
        text: "\(NSLocalizedString(sudoku.getDifficulty().rawValue, comment: ""))"
      )
      
      /// if used timer, display time
      if Settings.shared.useTimer {
        Divider()
        
        // MARK: Time Stats
        StatsView(img: "clock.fill",
                  title: "info.time",
                  text: Helper().formatTime(time))
      }
    }
    .padding()
  }
  
  var continueButton: some View {
    Button {
      startNewGame = true
    } label: {
      Text("complete.new")
        .fontWeight(.semibold)
    }
    .frame(width: Screen.width * 0.8, height: 50)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 25))
  }
  
  var mainButton: some View {
    Button {
      showMainView = true
    } label: {
      Text("complete.main")
        .fontWeight(.semibold)
    }
    .frame(width: Screen.width * 0.8, height: 50)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 25))
  }
}

struct StatsView: View {
  var img: String
  var title: LocalizedStringResource
  var text: String
  
  var body: some View {
    HStack {
      Image(systemName: img)
      Text(title)
      Spacer()
      Text(text)
    }
    .foregroundStyle(Color(.label))
  }
}

#Preview {
  GameCompleteView(sudoku: SudokuModel(difficulty: .extreme), time: 145)
}
