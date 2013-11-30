//
//  FYFAppDelegate.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYFDeepLinkViewController.h"


@interface FYFAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 Stores channels array from remote notification.
 Since app is active, we have to prompt the user manually with an alert.
 After user interacts with the alert, we need to display the correct view.
 */
@property (strong, nonatomic) NSArray* remoteNotificationFlavors;

@property (assign)int isClientPush;

@property (strong, nonatomic) FYFDeepLinkViewController* modal;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
