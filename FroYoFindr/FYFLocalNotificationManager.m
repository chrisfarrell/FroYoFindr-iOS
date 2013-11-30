//
//  FYFLocalNotificationManager.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/17/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFLocalNotificationManager.h"

@implementation FYFLocalNotificationManager


+ (id)sharedManager {
    static FYFLocalNotificationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _clientPushNotificationSent = NO;
        _goodByeSurveyNotificationSent = NO;
    }
    return self;
}


- (void)clientPushNotification
{
    
    if(!_clientPushNotificationSent){
        NSLog(@"First Notification");
        _clientPushNotificationSent = YES;
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"Tell others nearby know how cool this is!";
        localNotification.alertAction = @"BOOM!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }

}

- (void)goodByeSurveyNotification
{
    
    if(!_goodByeSurveyNotificationSent){
        NSLog(@"Goodbye/Survey Notification");
        
        _goodByeSurveyNotificationSent = YES;
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"Thanks for coming to the Push demo!";
        localNotification.alertAction = @"See Ya!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }

}

- (void)sharedInterestImmediateNotification
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Looks like we have something in common.";
    localNotification.alertAction = @"Check it out!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
