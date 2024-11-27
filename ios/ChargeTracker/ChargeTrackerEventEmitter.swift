//
//  ChargeTrackerEventEmitter.swift
//  LiveActivityPOC
//
//  Created by Varun Kukade on 27/11/24.
//

import Foundation

@objc(ChargeTrackerEventEmitter)
class ChargeTrackerEventEmitter: RCTEventEmitter {

  public static var emitter: ChargeTrackerEventEmitter?
  
  public static var events = ["onStopChargeInitiated"];

  override init() {
    super.init()
    ChargeTrackerEventEmitter.emitter = self
  }

  override func supportedEvents() -> [String]! {
    return ChargeTrackerEventEmitter.events;
  }
}
