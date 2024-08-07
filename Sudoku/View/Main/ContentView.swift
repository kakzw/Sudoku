//
//  ContentView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/1/24.
//

import SwiftUI

struct ContentView: View {
  @State private var showDifficulties = false
  
  var body: some View {
    NavigationStack {
      ZStack {
        /// when selecting difficulties
        /// make the background darker
        if showDifficulties {
          Color(.systemGray)
            .ignoresSafeArea()
            .onTapGesture {
              /// if background is tapped while selecting difficulties
              /// hide difficulty selection view
              showDifficulties = false
            }
        }
        
        MenuView(showDifficulties: $showDifficulties)
          .opacity(showDifficulties ? 0.4 : 1)
        
        /// when new game button is tapped
        /// display difficulties to select from
        if showDifficulties {
          VStack {
            Spacer()
            DifficultySelectionView()
              .padding(.horizontal)
              .shadow(radius: 10)
            Spacer()
              .frame(height: 50)
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
