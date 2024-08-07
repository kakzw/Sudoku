//
//  SettingsView.swift
//  Sudoku
//
//  Created by Kento Akazawa on 8/7/24.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  
  @ObservedObject private var settings = Settings.shared
  
  var body: some View {
    ScrollView {
      general
    }
    .navigationTitle("settings.title")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
    .toolbar {
      // MARK: Back Button
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("back.button")
          }
        }
        .foregroundStyle(Color(.label))
      }
    }
  }
  
  var general: some View {
    Section {
      // MARK: Error Limit
      SettingsContentView(
        toggle: $settings.limitErrors,
        img: "exclamationmark.triangle.fill",
        text: "settings.error",
        description: "settings.error.description"
      )
      
      // MARK: Highlight Areas
      SettingsContentView(
        toggle: $settings.highlightAreas,
        img: "square.stack.fill",
        text: "settings.areas",
        description: "settings.areas.description"
      )
      
      // MARK: Highlight Identical Numbers
      SettingsContentView(
        toggle: $settings.highlightIdenticalNum,
        img: "square.fill.on.square.fill",
        text: "settings.identical",
        description: "settings.identical.description"
      )
      
      // MARK: Hide Used Numbers
      SettingsContentView(
        toggle: $settings.hideUsedNum,
        img: "eye.slash.fill",
        text: "settings.used",
        description: "settings.used.description"
      )
      
      // MARK: Auto-Remove Notes
      SettingsContentView(
        toggle: $settings.autoRemoveNotes,
        img: "note.text",
        text: "settings.notes",
        description: "settings.notes.description"
      )
      
      // MARK: Timer
      SettingsContentView(
        toggle: $settings.useTimer,
        img: "timer",
        text: "settings.timer",
        description: "settings.timer.description"
      )
    }
    .padding([.top, .horizontal])
  }
}

struct SettingsContentView: View {
  @Binding var toggle: Bool
  var img: String
  var text: LocalizedStringResource
  var description: LocalizedStringResource
  
  var body: some View {
    VStack(alignment: .leading) {
      Toggle(isOn: $toggle) {
        Image(systemName: img)
        Text(text)
          .font(.system(size: FontSize.text))
      }
      .tint(Colors.Blue)
      
      Text(description)
        .font(.system(size: FontSize.description))
        .foregroundStyle(Color(.systemGray))
    }
  }
}

#Preview {
  SettingsView()
}
