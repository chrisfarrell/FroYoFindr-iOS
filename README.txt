Create your own project for this code.
Install the pods, this will create a workspace to use going forward.
$ pod install

Add a 'FYFKeys.h' file:

    #define MINOR_109_BLACK 109
    #define MINOR_114_PINK 114

    #define PARSE_APP_ID @"your_key"
    #define PARSE_CLIENT_KEY @"your_key"
    #define TESTFLIGHT_KEY @"your_key"

    #define ROXIMITY_UUID    @"your_key"
    #define ROX_BEACON_ID    @"com.your.id"

    #define APP_UUID         @"your_key"
    #define FYF_BEACON_ID    @"com.your.id"


Uses Cocoapods for
 - Testflight
 - Parse
 - CocoaLumberjack

Uses Parse
- to store preferences and locality
- to send Push notifications
- for Cloud Cloud feature to keep a log of push notifications

To do
- add xc tests
- add comments for doxygen
- add beacon recognition and advertising 
- recognize a beacon and then send a Push from the device to people nearby with same preference
- recognize a beacon for 'goodby' message/survey
- enable app to see itself on other devices and do something
- immediate, nearby and far?
- maybe a screen with totals for people nearby with each preference?

