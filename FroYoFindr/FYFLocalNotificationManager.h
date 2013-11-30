//
//  FYFLocalNotificationManager.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/17/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//


@interface FYFLocalNotificationManager : NSObject


+ (id)sharedManager;

- (void)clientPushNotification;
- (void)goodByeSurveyNotification;
- (void)sharedInterestImmediateNotification;

@property (assign)BOOL clientPushNotificationSent;
@property (assign)BOOL goodByeSurveyNotificationSent;

@end
