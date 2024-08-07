//
//  Constants.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/2/24.
//

import SwiftUI

let UNDEFINED: Int = -1

/// Enumeration to hold screen related constants
enum Screen {
  /// entire screen's bounds
  static let size: CGRect = UIScreen.main.bounds
  /// width of the screen
  static let width: CGFloat = UIScreen.main.bounds.width
  /// height of the screen
  static let height: CGFloat = UIScreen.main.bounds.height
  /// width of each sudoku cell
  /// - NOTE: sudoku grid uses 95% of the screen
  static let cellWidth: CGFloat = UIScreen.main.bounds.size.width * 0.95 / 9
  /// thickness of the grid lines in sudoku board
  static let lineThickness: CGFloat = 2
}

/// Enumeration to hold font size related constants
enum FontSize {
  static let appTitle: CGFloat = 80
  static let cell: CGFloat = 28
  static let text: CGFloat = 20
  static let description: CGFloat = 12
}

/// Enumeration to hold color related constants
enum Colors {
  static let Blue: Color = Color.blue
  static let Gray: Color = Color(.systemGray)
  static let Default: Color = Color(UIColor(named: "GridBackground")!)
  static let DeepBlue: Color = Color(UIColor(named: "DeepBlue")!)
  static let ActiveBlue: Color = Color(UIColor(named: "ActiveBlue")!)
  static let LightBlue: Color = Color(UIColor(named: "LightBlue")!)
  static let MatteBlack: Color = Color(UIColor(named: "MatteBlack")!)
  static let Golden: Color = Color(UIColor(named: "Golden")!)
}
