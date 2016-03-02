//
//  Session.m
//  AlarmSpider
//
//  Created by danny on 02.03.16.
//  Copyright © 2016 danny. All rights reserved.
//

#import "Session.h"

@implementation Session

- (instancetype)initWithCookies:(NSArray *)cookies {
    if (!cookies) {
        return nil;
    }
    self = [super init];
    if (self) {
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.name isEqualToString:@"testapp_check"]) {
                _check = cookie.value.integerValue;
            } else if ([cookie.name isEqualToString:@"testapp_session"]) {
                _sessionId = cookie.value;
            } else if ([cookie.name isEqualToString:@"testapp_time"]) {
                _time = cookie.value.integerValue;
            }
        }
    }
    return self;
}

- (NSInteger)timeToEnd {
    return self.check - self.time;
}

@end
