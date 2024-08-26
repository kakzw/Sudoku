//
//  MenuView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/7/24.
//

import SwiftUI

struct MenuView: View {
  @Binding var showDifficulties: Bool
  
  @State private var showStats = false
  @State private var showSettings = false
  
  var body: some View {
    VStack {
      Spacer()
      
      // MARK: App Title
      Text("app.title")
        .shadow(radius: 10)
        .font(.system(size: FontSize.appTitle))
        .foregroundColor(Color(.label))
        .shadow(radius: 10)
      
      // MARK: Menu Buttons
      MenuButtonsView(
        showDifficulties: $showDifficulties,
        showStats: $showStats,
        showSettings: $showSettings
      )
      
      Spacer()
    }
    .navigationDestination(isPresented: $showStats) {
      StatisticsView()
    }
    .navigationDestination(isPresented: $showSettings) {
      SettingsView()
    }
  }
}

#Preview {
  MenuView(showDifficulties: .constant(true))
}
