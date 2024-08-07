//
//  Settings.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

final class Settings: ObservableObject {
  /// Singleton instance of this class
  static let shared = Settings()
  
  /// Published properties to trigger view updates when values change
  @Published var isNote = false
  @Published var useTimer = true
  @Published var limitErrors = true
  @Published var highlightAreas = true
  @Published var highlightIdenticalNum = true
  @Published var hideUsedNum = true
  @Published var autoRemoveNotes = true
}
