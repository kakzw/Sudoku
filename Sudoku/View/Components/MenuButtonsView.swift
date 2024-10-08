//
//  MenuButtonsView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/7/24.
//

import SwiftUI

struct MenuButtonsView: View {
  @Binding var showDifficulties: Bool
  @Binding var showStats: Bool
  @Binding var showSettings: Bool
  
  var body: some View {
    VStack {
      // MARK: New Game Button
      MenuButtonView(
        img: "gamecontroller.fill",
        title: "menu.new") {
        showDifficulties = true
      }
      
      // MARK: Statistics Button
      MenuButtonView(
        img: "chart.bar.fill",
        title: "statistics.title") {
        showStats = true
      }
      
      // MARK: Settings Button
      MenuButtonView(
        img: "gear",
        title: "settings.title") {
        showSettings = true
      }
    }
  }
}

struct MenuButtonView: View {
  var img: String
  var title: LocalizedStringResource
  var action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      HStack {
        Image(systemName: img)
        HStack {
          Spacer()
          Text(title)
          Spacer()
        }
      }
      .padding(.horizontal)
      .frame(width: Screen.width*0.6, height: 50)
      .font(.system(size: FontSize.text))
      .fontWeight(.semibold)
      .background(Color(.label))
      .foregroundStyle(Color(.systemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    .padding(.top)
  }
}

#Preview {
  MenuButtonsView(
    showDifficulties: .constant(false),
    showStats: .constant(false),
    showSettings: .constant(false)
  )
}
