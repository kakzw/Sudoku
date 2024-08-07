//
//  MenuView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/7/24.
//

import SwiftUI

struct MenuView: View {
  @Binding var showDifficulties: Bool
  
  @State private var showSettings = false
  
  var body: some View {
    VStack {
      Spacer()
      
      // MARK: App Title
      Text("app.title")
        .shadow(radius: 10)
        .font(.system(size: FontSize.appTitle))
        .foregroundColor(Color(.label))
      
      // MARK: Menu Buttons
      MenuButtonsView(showDifficulties: $showDifficulties, showSettings: $showSettings)
      
      Spacer()
    }
    .navigationDestination(isPresented: $showSettings) {
      SettingsView()
    }
  }
}

#Preview {
  MenuView(showDifficulties: .constant(true))
}
