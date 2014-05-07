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

- (id)initWithState:(MatchState)state players:(NSArray*)players
{
    if ((self = [super init])) {
        _state = state;
        _players = [players initWithArray:players];
    }
    return self;
}

- (void)dealloc
{/*
    [_players release];
    _players = nil;
    [super dealloc]; */
}

@end