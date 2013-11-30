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
 Stores flavor array passed in with remote notification.
 When app is active, we prompt the user manually with an alert.
 So,after user interacts with the alert, we need to display the correct view for the flavor passed in.
 */
@property (strong, nonatomic) NSArray* remoteNotificationFlavors;

/**
	Flag for whether or not the recieved push is from a client, rather than from Parse.
 */
@property (assign)int isClientPush;


/**
	View controller used to display an appropriate image based on flavor passed in with push.
 */
@property (strong, nonatomic) FYFDeepLinkViewController* modal;


/**
	App uses tabbed navigation.
 */
@property (strong, nonatomic) UITabBarController *tabBarController;


@end
