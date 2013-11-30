//
//  Logging.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/30/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "DDLog.h"

#ifdef DEBUG
    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


