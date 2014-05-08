//
//  Player.m
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize playerId = _playerId;
@synthesize alias = _alias;
@synthesize posX = _posX;

- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias posX:(int)posX
{
    if ((self = [super init])) {
        _playerId = [playerId initWithString:playerId];
        _alias = [alias initWithString:alias];
        _posX = posX;
    }
    return self;
}

- (void)dealloc
{/*
    [_playerId release];
    _playerId = nil;
    [_alias release];
    _alias = nil;
    [super dealloc];*/
}

@end