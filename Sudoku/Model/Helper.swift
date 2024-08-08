//
//  Helper.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/8/24.
//

import SwiftUI

class Helper {
  /// Format the time into minutes and seconds
  /// - Parameter time: time in seconds
  /// - Returns: string of minutes and seconds
  func formatTime(_ time: Int) -> String {
    let min = time / 60
    let sec = time % 60
    
    let secStr = sec < 10 ? "0\(sec)" : "\(sec)"
    
    return "\(min):\(secStr)"
  }
}
