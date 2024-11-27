//
//  ChargeTrackerModule.swift
//  LiveActivityPOC
//
//  Created by Varun Kukade on 26/11/24.
//

import Foundation
import ActivityKit

// You can access Objective-C dependencies/macros in this Swift file because
// you have included the RCTBridgeModule import inside the bridging header.
// The bridging header allows Swift files in your target to access
// the Objective-C dependencies/macros.


//@objc attribute tells the Swift compiler to expose the swift class or method to the Objective-C runtime.

@objc(ChargeTrackerModule) //this registers the module with React Native
class ChargeTrackerModule: NSObject {

 static func areActivitiesEnabled() -> Bool {
     return ActivityAuthorizationInfo().areActivitiesEnabled
 }

 @objc
 func constantsToExport() -> [AnyHashable : Any]! {
   return [
     "recordID": RECORD_ID
   ]
 }
  
 static var isAtLeastIOS16_1: Bool {
     if #available(iOS 16.1, *) {
         return true
     } else {
         return false
     }
 }

 static var isAtLeastIOS16_2: Bool {
     if #available(iOS 16.2, *) {
         return true
     } else {
         return false
     }
 }
  

   static func getLiveActivity(for recordID: Int) -> Activity<ChargeTrackerAttributes>?{
       Activity<ChargeTrackerAttributes>.activities.first(where: {$0.attributes.recordID == recordID})
   }
  
  static func getCurrentContentState(forRecordID id: Int?) -> ChargeTrackerAttributes.ContentState?{
      guard let recordID = id else {
        return nil
      }
      guard let liveActivity = getLiveActivity(for: recordID) else{
          return nil
      }
      if #available(iOS 16.2, *) {
          return liveActivity.content.state
      } else {
          return liveActivity.contentState
      }
  }
  
  static func getCurrentAttributes(forRecordID id: Int?) -> ChargeTrackerAttributes?{
      guard let recordID = id else {
        return nil
      }
      guard let liveActivity = getLiveActivity(for: recordID) else{
          return nil
      }
      return liveActivity.attributes;
  }

  static func ObservePushTokenUpdates() {
     guard let liveActivity = getLiveActivity(for: RECORD_ID) else{
         return
     }
     Task{
        for await pushToken in liveActivity.pushTokenUpdates {
          let pushTokenString = pushToken.reduce("") {
            $0 + String(format: "%02x", $1)
          }
          let authToken = liveActivity.attributes.authToken
         
          // Create the JSON body
          let jsonBody: [String: String] = ["token": pushTokenString]
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
        }
      }
   }
  
  static func ObserveLiveActivityState() {
     guard let liveActivity = getLiveActivity(for: RECORD_ID) else{
         return
     }
     Task{
        for await activityState in liveActivity.activityStateUpdates {
          switch activityState {
              case .dismissed:
                      let authToken = liveActivity.attributes.authToken;
                     
                      // Create the JSON body
                      var someValue = 2
                      let jsonBody: [String: Int] = ["some_property": someValue]
                      let httpBody: Data?

                      do {
                          httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
                      } catch {
                          print("Error converting JSON to Data:", error)
                          return
                      }

                      // Optional binding before calling the API
                      if let httpBody = httpBody {
                          NetworkService.callAPI(url: "", httpMethod: "DELETE", httpBody: httpBody, authToken: authToken)
                      } else {
                          print("httpBody is nil, not calling the API.")
                      }
              default:
                  print("Value is something else")
              }
        }
      }
   }

  //method exported to react native
  @objc
  func isLiveActivityActive(_ callback: RCTResponseSenderBlock) {
    // Check if there's at least one active activity in the activities array
    let isActive = Activity<ChargeTrackerAttributes>.activities.contains { activity in
      return activity.activityState == .active
    }
    callback([isActive])
  }

 //method exported to react native
 @objc
  func startLiveActivity(_ percent: Double, chargeRate: Double, authToken: String) -> Void {
   if (!ChargeTrackerModule.areActivitiesEnabled()) {
         // User disabled Live Activities for the app, nothing to do
         return
   }
   if(!ChargeTrackerModule.isAtLeastIOS16_1){
     //ios version should be alleast 16.1 to support live activity
     return;
   }
   // Preparing data for the Live Activity
  
   // Store recordId to identify existence or access unique live activity later
   let activityAttributes = ChargeTrackerAttributes(recordID: RECORD_ID, authToken: authToken);
   let chargerInfo = ChargeTrackerAttributes.ContentState.ChargeInfo(
     percent: percent, chargeRate: chargeRate
   )
   let contentState = ChargeTrackerAttributes.ContentState(
     chargeInfo: chargerInfo
   )
   do {
     if #available(iOS 16.2, *) {
       //For IOS 16.2 and above: Request to start a new Live Activity
       let activityContent = ActivityContent<ChargeTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
       let _ = try Activity.request(attributes: activityAttributes, content: activityContent, pushType: .token)
     } else {
       //For IOS 16.1: Request to start a new Live Activity
       let _ = try Activity.request(attributes: activityAttributes, contentState: contentState, pushType: .token)
     }
     ChargeTrackerModule.ObservePushTokenUpdates();
     ChargeTrackerModule.ObserveLiveActivityState()
       } catch (let error) {
         // Handle errors
         print("Error requesting Live Activity \(error.localizedDescription).")
       }
 }

 
 static func updateActivity(percent: Double, chargeRate: Double,  recordId: Int) -> Void {
   if (!ChargeTrackerModule.areActivitiesEnabled()) {
         // User disabled Live Activities for the app, nothing to do
         return
   }
   guard let liveActivity = ChargeTrackerModule.getLiveActivity(for: recordId) else{
       return
   }
   if(!ChargeTrackerModule.isAtLeastIOS16_1){
     //ios version should be alleast 16.1 to support live activity
     return;
   }
   do {
          Task  {
            let chargerInfo = ChargeTrackerAttributes.ContentState.ChargeInfo(
              percent: percent, chargeRate: chargeRate
            )
            let contentState = ChargeTrackerAttributes.ContentState(
              chargeInfo: chargerInfo
            )
            if #available(iOS 16.2, *) {
              let activityContent = ActivityContent<ChargeTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
              await liveActivity.update(activityContent)
            } else {
              await liveActivity.update(using: contentState)
            }
          }
      
   } catch (let error) {
     // Handle errors
     print("Error updating Live Activity \(error.localizedDescription).")
   }
 }
  
  //method exported to react native
  @objc
  func updateLiveActivity(_ percent: Double, chargeRate: Double,  recordId: Int) -> Void {
    ChargeTrackerModule.updateActivity(percent: percent, chargeRate: chargeRate, recordId: recordId)
  }

  static func updateLiveActivity(_ percent: Double, chargeRate: Double,  recordId: Int) -> Void {
    updateActivity(percent: percent, chargeRate: chargeRate, recordId: recordId)
  }

 @objc
 func stopLiveActivity(_ isImmediateDismissal: Bool, percent: Double, chargeRate: Double,  recordId: Int) -> Void {
   // A task is a unit of work that can run concurrently in a lightweight thread, managed by the Swift runtime
   // It helps to avoid blocking the main thread
   if (!ChargeTrackerModule.areActivitiesEnabled()) {
         // User disabled Live Activities for the app, nothing to do
         return
   }
   guard let liveActivity = ChargeTrackerModule.getLiveActivity(for: recordId) else{
       return
   }
   if(!ChargeTrackerModule.isAtLeastIOS16_1){
     //ios version should be alleast 16.1 to support live activity
     return;
   }
   Task {
     let chargerInfo = ChargeTrackerAttributes.ContentState.ChargeInfo(
       percent: percent, chargeRate: chargeRate
     )
     let contentState = ChargeTrackerAttributes.ContentState(
       chargeInfo: chargerInfo
     )
     if #available(iOS 16.2, *) {
       let activityContent = ActivityContent<ChargeTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
       await liveActivity.end(isImmediateDismissal ? nil : activityContent, dismissalPolicy: isImmediateDismissal ? .immediate : .default)
     } else {
       await liveActivity.end(using: isImmediateDismissal ? nil : contentState, dismissalPolicy: isImmediateDismissal ? .immediate : .default)
     }

   }
 }
}

@available(iOS 17.0,*)
extension ChargeTrackerModule {
  
  @available(iOS 17.0,*)
  static func showStopChargeView(recordID: Int){
      guard let currentState = getCurrentContentState(forRecordID: recordID) else {
          return
      }
      guard let currentAttributes = getCurrentAttributes(forRecordID: recordID) else {
          return
      }
    updateActivity(percent: currentState.chargeInfo.percent, chargeRate: currentState.chargeInfo.chargeRate, recordId: recordID)
  }
}
