import {NativeEventEmitter, NativeModule, NativeModules} from 'react-native';

type TChargeTrackerModule = {
  recordID: number;
  updateLiveActivity: (
    percent: number,
    chargeRate: number,
    recordId: number,
  ) => void;
  startLiveActivity: (
    percent: number,
    chargeRate: number,
    authToken: string,
  ) => void;
  stopLiveActivity: (
    isImmediateDismissal: boolean,
    percent: number,
    chargeRate: number,
    recordId: number,
  ) => void;
  isLiveActivityActive: (callback: (value: boolean) => void) => void;
};

// Instantiate the native module with the type
const ChargeTrackerModule =
  NativeModules.ChargeTrackerModule as TChargeTrackerModule;

const ChargeTrackerEventEmitterModule =
  NativeModules.ChargeTrackerEventEmitter as NativeModule;

//instantiate the event emitter from separate native module
const ChargeTrackerEventEmitter = new NativeEventEmitter(
  ChargeTrackerEventEmitterModule,
);

// Export the typed module
export {ChargeTrackerModule, ChargeTrackerEventEmitter};
