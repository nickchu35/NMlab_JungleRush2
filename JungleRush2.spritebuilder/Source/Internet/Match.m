//
//  Match.m
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Match.h"

@implementation Match
@synthesize state = _state;
@synthesize players = _players;
@synthesize round=_round;

- (id)initWithState:(MatchState)state players:(NSArray*)players
{
    if ((self = [super init])) {
        _state = state;
        _players = players;
        _round=0;
    }
    return self;
}

- (void)dealloc
{



}

@end