import React, {useEffect} from 'react';
import {
  Platform,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';
import {ChargeTrackerEventEmitter, ChargeTrackerModule} from './NativeModule';

function App(): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  useEffect(() => {
    const stopChargeSubscription = ChargeTrackerEventEmitter.addListener(
      'onStopChargeInitiated',
      () => {
        console.log('Stop Charge Initiated from live activity');
      },
    );
    return () => {
      stopChargeSubscription.remove();
    };
  }, []);

  const isLiveActivityActive = (): Promise<boolean> => {
    return new Promise(resolve => {
      if (Platform.OS === 'android') {
        return resolve(false);
      }
      ChargeTrackerModule.isLiveActivityActive(value => {
        return resolve(value);
      });
    });
  };

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  const onStart = async () => {
    const isLiveActivityAlreadyStarted = await isLiveActivityActive();
    //start new live activity if its not started already.
    if (!isLiveActivityAlreadyStarted) {
      ChargeTrackerModule.startLiveActivity(10, 45, 'efer2bsdbbsw72');
    }
  };

  const onUpdate = () => {
    ChargeTrackerModule.updateLiveActivity(
      20,
      46,
      ChargeTrackerModule.recordID,
    );
  };

  const onStopImmediate = () => {
    ChargeTrackerModule.stopLiveActivity(
      true,
      100,
      46,
      ChargeTrackerModule.recordID,
    );
  };

  const onStopDefault = () => {
    ChargeTrackerModule.stopLiveActivity(
      false,
      100,
      46,
      ChargeTrackerModule.recordID,
    );
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={[backgroundStyle, {paddingTop: 100}]}>
        <TouchableOpacity style={styles.buttonContainer} onPress={onStart}>
          <Text style={styles.text}>Start Live Activity</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.buttonContainer} onPress={onUpdate}>
          <Text style={styles.text}>Update Live Activity</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.buttonContainer}
          onPress={onStopImmediate}>
          <Text style={styles.text}>Stop Live Activity .Immediately</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.buttonContainer}
          onPress={onStopDefault}>
          <Text style={styles.text}>Stop Live Activity .default</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  buttonContainer: {
    paddingVertical: 20,
    paddingHorizontal: 20,
    backgroundColor: 'black',
    marginBottom: 20,
    width: '70%',
    alignSelf: 'center',
    borderRadius: 20,
  },
  text: {
    color: 'white',
    fontSize: 17,
    textAlign: 'center',
  },
});

export default App;
