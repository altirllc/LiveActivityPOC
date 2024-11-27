//
//  ChargeTrackerLiveActivityIntent.swift
//  LiveActivityPOC
//
//  Created by Varun Kukade on 27/11/24.
//

import Foundation
import AppIntents
import SwiftUI
import UIKit

@available(iOS 17.0, *)
public struct StopChargeIntent: LiveActivityIntent {
  public init() {
  }

  @Parameter(title:"RecordID")
  var recordID : Int

  init(recordID: Int){
      self.recordID = recordID
  }
  
  public static var openAppWhenRun: Bool = false

  public static var title: LocalizedStringResource = "Stop Charge"
  
  
  public func perform() async throws -> some IntentResult {
    ChargeTrackerModule.showStopChargeView(recordID: recordID);
    guard let currentAttributes = ChargeTrackerModule.getCurrentAttributes(forRecordID: recordID) else {
        return .result()
    }
    let authToken = currentAttributes.authToken;
   
    // Create the JSON body
    let jsonBody: [String: String] = ["some_property": "some_value"]
    let httpBody: Data?

    do {
        httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
    } catch {
        print("Error converting JSON to Data:", error)
        return
    }

    // Optional binding before calling the API
    if let httpBody = httpBody {
        NetworkService.callAPI(url: "", httpMethod: "POST", httpBody: httpBody, authToken: authToken)
    } else {
        print("httpBody is nil, not calling the API.")
    }
    return .result()
  }
}
