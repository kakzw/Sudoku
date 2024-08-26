//
//  StatisticsView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/8/24.
//

import SwiftUI

struct StatisticsView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss
  @FetchRequest(sortDescriptors: [SortDescriptor(\.difficulty)]) var statsData: FetchedResults<Stats>
  
  @State private var difficulty = Difficulty.easy
  
  var body: some View {
    VStack {
      selection
      Divider()
      
      ScrollView {
        game
        time
        streak
      }
    }
    .navigationTitle("statistics.title")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
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
    }
  }
  
  var selection: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal) {
        HStack {
          ForEach(Difficulty.allCases) { ele in
            Button {
              withAnimation {
                difficulty = ele
                /// scroll to the selected difficulty
                proxy.scrollTo(ele, anchor: .center)
              }
            } label: {
              Text("\(NSLocalizedString(ele.rawValue, comment: ""))")
                .foregroundStyle(difficulty == ele ? Colors.Blue : Color(.label))
                .opacity(0.6)
                .frame(minWidth: Screen.width / 4)
            }
            .id(ele) /// Assign a unique ID to each difficulty
          }
        }
      }
      .scrollIndicators(.hidden)
    }
  }
  
  var game: some View {
    VStack {
      let s = getStats()
      
      // MARK: Title
      HStack {
        Text("statistics.game")
          .font(.system(size: FontSize.text))
          .fontWeight(.bold)
        Spacer()
      }
      
      // MARK: Game Started
      StatisticsContentView(
        img: "squareshape.split.3x3",
        title: "statistics.game.start",
        text: "\(s?.gameStarted ?? 0)"
      )
      
      // MARK: Game Won
      StatisticsContentView(
        img: "crown",
        title: "statistics.game.win",
        text: "\(s?.gameWon ?? 0)"
      )
      
      // MARK: Win Rate
      StatisticsContentView(
        img: "flag",
        title: "statistics.game.rate",
        text: "\(getWinRate(stats: s))"
      )
      
      // MARK: Win No Mistake
      StatisticsContentView(
        img: "flag.slash",
        title: "statistics.game.mistake",
        text: "\(s?.gameMistake ?? 0)"
      )
    }
    .padding()
  }
  
  var time: some View {
    VStack {
      let s = getStats()
      
      // MARK: Title
      HStack {
        Text("statistics.time")
          .fontWeight(.bold)
        Spacer()
      }
      
      // MARK: Best Time
      StatisticsContentView(
        img: "clock.badge.checkmark",
        title: "statistics.best",
        text: getTimeText(s?.bestTime)
      )
      
      // MARK: Average Time
      StatisticsContentView(
        img: "clock",
        title: "statistics.avg",
        text: getTimeText(s?.getAvgTime())
      )
    }
    .padding()
  }
  
  var streak: some View {
    VStack {
      let s = getStats()
      
      // MARK: Title
      HStack {
        Text("statistics.streak")
          .fontWeight(.bold)
        Spacer()
      }
      
      // MARK: Current Win Streak
      StatisticsContentView(
        img: "arrow.right",
        title: "statistics.curr.streak",
        text: "\(s?.currStreak ?? 0)"
      )
      
      // MARK: Best Win Streak
      StatisticsContentView(
        img: "arrow.forward.to.line",
        title: "statistics.best.streak",
        text: "\(s?.bestStreak ?? 0)"
      )
    }
    .padding()
  }
  
  // MARK: - Private Functions
  
  private func getStats() -> Statistic? {
    for ele in statsData {
      if ele.difficulty == difficulty.rawValue {
        return Statistic(
          difficulty: ele.difficulty!,
          gameStarted: Int(ele.gameStarted),
          gameWon: Int(ele.gameWon),
          gameMistake: Int(ele.gameMistake),
          bestTime: Int(ele.bestTime),
          totalTime: Int(ele.totalTime),
          currStreak: Int(ele.currStreak),
          bestStreak: Int(ele.bestStreak)
        )
      }
    }
    return nil
  }
  
  private func getTimeText(_ time: Int?) -> String {
    guard let time = time else { return "-" }
    return Helper().formatTime(time)
  }
  
  private func getWinRate(stats: Statistic?) -> String {
    guard let stats = stats else { return "-" }
    let winRate = (Double(stats.gameWon) / Double(stats.gameStarted)) * 100
    return String(format: "%.0f%%", winRate)
  }
}

struct StatisticsContentView: View {
  var img: String
  var title: LocalizedStringResource
  var text: String
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: img)
          .foregroundStyle(Colors.Blue)
        Spacer()
        Text(text)
          .fontWeight(.semibold)
      }
      
      HStack {
        Text(title)
          .fontWeight(.semibold)
        Spacer()
      }
    }
    .padding(10)
    .background(Color(.systemGray5))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  StatisticsView()
}
