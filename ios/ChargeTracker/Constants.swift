//
//  Constants.swift
//  ChargeTrackerExtension
//
//  Created by Varun Kukade on 26/11/24.
//

import Foundation
import SwiftUI

let RECORD_ID = 1;

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

var widgetUrl: String {
      return "livechatpoc://live-activity"
}

var addFundsWidgetURL: String {
  return "livechatpoc://live-activity/add-funds"
}
