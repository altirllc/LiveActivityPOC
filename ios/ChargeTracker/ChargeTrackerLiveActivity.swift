//
//  ChargeTrackerLiveActivity.swift
//  ChargeTracker
//
//  Created by Varun Kukade on 26/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

@DynamicIslandExpandedContentBuilder
    private func showExpandedUI(
       percent: Double,
       recordID: Int
    ) -> DynamicIslandExpandedContent<some View> {
      DynamicIslandExpandedRegion(.bottom) {
        ExpandedUI(
          percent: percent,
          recordID: recordID,
          isLockScreenView: false
        )
      }
}

struct ChargeTrackerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ChargeTrackerAttributes.self) { context in
            // Lock screen/banner UI goes here
          ExpandedUI(
            percent: context.state.chargeInfo.percent,
            recordID: context.attributes.recordID,
            isLockScreenView: true
          ).padding(.all, 20)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here
              showExpandedUI(
                percent: context.state.chargeInfo.percent,
                recordID: context.attributes.recordID
              )
            } compactLeading: {
              Text("\(Int(context.state.chargeInfo.chargeRate))kW")
            } compactTrailing: {
                Text("\(Int(context.state.chargeInfo.percent))%")
            } minimal: {
                Text("\(Int(context.state.chargeInfo.percent))%")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.white)
        }
    }
}

extension ChargeTrackerAttributes {
    fileprivate static var preview: ChargeTrackerAttributes {
        ChargeTrackerAttributes(recordID: 1)
    }
}

extension ChargeTrackerAttributes.ContentState {
  fileprivate static var sample: ChargeTrackerAttributes.ContentState {
    let chargeInfo = ChargeTrackerAttributes.ContentState.ChargeInfo(
         percent: 10, chargeRate: 20, amount: 30
       )
    return ChargeTrackerAttributes.ContentState(chargeInfo: chargeInfo)
  }
}

#Preview("Notification", as: .content, using: ChargeTrackerAttributes.preview) {
   ChargeTrackerLiveActivity()
} contentStates: {
    ChargeTrackerAttributes.ContentState.sample
}
