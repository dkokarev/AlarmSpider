//
//  Session.h
//  AlarmSpider
//
//  Created by danny on 02.03.16.
//  Copyright © 2016 danny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger check;
@property (nonatomic, assign, readonly) NSInteger timeToEnd;

- (instancetype)initWithCookies:(NSArray *)cookies;

@end
