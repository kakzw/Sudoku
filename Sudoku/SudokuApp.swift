//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/1/24.
//

import SwiftUI

@main
struct SudokuApp: App {
  @StateObject private var dataController = DataController()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
  }
}
