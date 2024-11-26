import ActivityKit
import WidgetKit
import SwiftUI
import Foundation

struct ExpandedUI: View {
  
  @Environment(\.colorScheme) var colorScheme
  
    var isAtLeastIOS17_0: Bool {
        if #available(iOS 17.0, *) {
            return true
        } else {
            return false
        }
    }

    // Required arguments for the component
    var percent: Double
    let recordID: Int
    let isLockScreenView: Bool
  
    var color: Color {
      return colorScheme == .dark ? Color(hex: 0xffffff) : Color(hex: 0x000000)
    }
  
    var buttonTextcolor: Color {
      return colorScheme == .dark ? Color(hex: 0x000000) : Color(hex: 0xffffff)
    }
  

    var body: some View {
      VStack(alignment: .leading) {
        // Left Partition (Texts)
        VStack(alignment: .leading, spacing: 4) {
          Text("Vehicle Charging \(String(format: "%.1f", percent))%")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(color)

        }
        if(isAtLeastIOS17_0) {
          Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
              VStack {
                Text("Stop charge")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(buttonTextcolor)
              }
              .frame(maxWidth: .infinity)
              .frame(height: 30)
              .background(color)
              .cornerRadius(25)
          }
          .buttonStyle(PlainButtonStyle())
          
          Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
              VStack {
                Text("Add Funds")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(buttonTextcolor)
              }
              .frame(maxWidth: .infinity)
              .frame(height: 30)
              .background(color)
              .cornerRadius(25)
          }
          .buttonStyle(PlainButtonStyle())
          
        }
      }
    }
}

