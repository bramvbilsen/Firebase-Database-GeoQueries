#import "FlutterFirebaseDatabaseGeolocationPlugin.h"

@implementation FlutterFirebaseDatabaseGeolocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_firebase_database_geolocation"
            binaryMessenger:[registrar messenger]];
  FlutterFirebaseDatabaseGeolocationPlugin* instance = [[FlutterFirebaseDatabaseGeolocationPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
