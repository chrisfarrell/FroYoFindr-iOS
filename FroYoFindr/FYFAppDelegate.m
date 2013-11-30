//
//  FYFAppDelegate.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFAppDelegate.h"
#import "FYFLocationManager.h"
#import "FYFKeys.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@implementation FYFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [TestFlight takeOff:TESTFLIGHT_KEY];
    
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    
    UITabBar *tb = _tabBarController.tabBar;
    NSArray *items = tb.items;
    for (UITabBarItem *tbi in items) {
        UIImage *image = tbi.image;
        tbi.selectedImage = image;
        tbi.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    self.modal = [_tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FYFDeepLinkViewController"];
    
    [FYFLocationManager sharedManager];
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    if (notification) {
        [self processLocalNotification:notification];
    }
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)processLocalNotification:(UILocalNotification *)notification
{
    NSString *action = notification.alertAction;
    if ([action  isEqualToString: @"BOOM!"]) {
        //display modal that shows how many people nearby share your preference
        //and provides a button to send a client push to those people
        [[_tabBarController selectedViewController] presentViewController:[_tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FYFClientPushViewController"] animated:YES completion:nil];
    }else if([action  isEqualToString: @"See Ya!"]){ /**< when user passes near the 'goodbye beacon' */
        //display a modal that says 'thank you' and presents a survey
        [[_tabBarController selectedViewController] presentViewController:[_tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FYFThankYouViewController"] animated:YES completion:nil];
    }else if([action isEqualToString:@"Check it out!"]){
        //display a modal that displays something special related to locality and preference
        [[_tabBarController selectedViewController] presentViewController:[_tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FYFSharedImmediateViewController"] animated:YES completion:nil];
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSString* message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSArray* flavors = [userInfo objectForKey:FLAVORS];
    _isClientPush = (int)[userInfo objectForKey:@"isClientPush"];
    BOOL canSeeRoxBeacon = [[FYFLocationManager sharedManager] isInRangeOfBlackRoximityBeacon];
    
    [self setRemoteNotificationFlavors:flavors];
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message Received"
                                                            message:[NSString stringWithFormat:@"%@", message]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }else{
        [self showModalForChannel];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self showModalForChannel];
}

- (void)showModalForChannel
{
    NSString* action = (NSString*)[self.remoteNotificationFlavors objectAtIndex:0];
    
    int index = -1;

    if([action isEqualToString:CHOCOLATE]){
        index = 0;
    }else if([action isEqualToString:VANILLA]){
        index = 1;
    }else if([action isEqualToString:STRAWBERRY]){
        index = 2;
    }

    if(index >= 0){
        [_modal showImageAtIndex:index];
        if(_isClientPush == 1){
            _isClientPush = 0;
            //maybe add a label to the modal?
        }
        [[_tabBarController selectedViewController] presentViewController:_modal animated:YES completion:nil];
    }
    [self setRemoteNotificationFlavors:nil];
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
