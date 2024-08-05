//
//  Setting.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/4/24.
//

import SwiftUI

final class Setting: ObservableObject {
  /// Singleton instance of this class
  static let shared = Setting()
  
  /// Published properties to trigger view updates when values change
  @Published var isNote = false
}
