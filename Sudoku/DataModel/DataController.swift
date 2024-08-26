//
//  DataController.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/10/24.
//

import SwiftUI
import CoreData

struct Statistic {
  let id = UUID()
  let difficulty: String
  let gameStarted: Int
  let gameWon: Int
  let gameMistake: Int
  let bestTime: Int
  let totalTime: Int
  let currStreak: Int
  let bestStreak: Int
  
  func getAvgTime() -> Int {
    return totalTime / gameStarted
  }
}

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "StatisticsModel")
  
  init() {
    container.loadPersistentStores { desc, error in
      if let error = error {
        print("Failed to load the data \(error.localizedDescription)")
      }
    }
  }
  
  /// Save changes to the context
  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data saved")
    } catch {
      print("could not save the data...")
    }
  }
  
  func addStats(_ stats: Statistic, context: NSManagedObjectContext) {
    let s = Stats(context: context)
    s.id = stats.id
    s.difficulty = stats.difficulty
    s.gameStarted = Int32(stats.gameStarted)
    s.gameWon = Int32(stats.gameWon)
    s.gameMistake = Int32(stats.gameMistake)
    s.bestTime = Int32(stats.bestTime)
    s.totalTime = Int32(stats.totalTime)
    s.currStreak = Int32(stats.currStreak)
    s.bestStreak = Int32(stats.bestStreak)
    
    save(context: context)
  }
  
  func editStats(_ stats: Stats, s: Statistic, context: NSManagedObjectContext) {
    stats.id = s.id
    stats.difficulty = s.difficulty
    stats.gameStarted = Int32(s.gameStarted)
    stats.gameWon = Int32(s.gameWon)
    stats.gameMistake = Int32(s.gameMistake)
    stats.bestTime = Int32(s.bestTime)
    stats.totalTime = Int32(s.totalTime)
    stats.currStreak = Int32(s.currStreak)
    stats.bestStreak = Int32(s.bestStreak)
    
    save(context: context)
  }
  
  func getStats(difficulty: Difficulty) -> Stats? {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.difficulty)]) var stats: FetchedResults<Stats>
    for s in stats {
      if s.difficulty == difficulty.rawValue {
        return s
      }
    }
    
    return nil
  }
}
