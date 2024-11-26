//
//  ChargeTrackerModule.m
//  LiveActivityPOC
//
//  Created by Varun Kukade on 26/11/24.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h> //This import allows to use obj-c macros.

//RCT_EXTERN_MODULE and RCT_EXTERN_METHOD Macros exposes class and methods to obj-c runtime


@interface RCT_EXTERN_MODULE(ChargeTrackerModule, NSObject)

+ (bool)requiresMainQueueSetup {
 return NO;
}

RCT_EXTERN_METHOD(startLiveActivity:(nonnull double *)percent
                 chargeRate:(nonnull double *)chargeRate
                 authToken:(nonnull NSString *)authToken)
RCT_EXTERN_METHOD(updateLiveActivity:(nonnull double *)percent
                 chargeRate:(nonnull double *)chargeRate
                 recordId:(NSInteger)recordId)
RCT_EXTERN_METHOD(stopLiveActivity:(BOOL)isImmediateDismissal
                 percent:(nonnull double *)percent
                 chargeRate:(nonnull double *)chargeRate
                 recordId:(NSInteger)recordId)
RCT_EXTERN_METHOD(isLiveActivityActive: (RCTResponseSenderBlock)callback)


@end
