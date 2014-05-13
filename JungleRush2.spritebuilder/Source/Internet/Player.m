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
@synthesize type = _type;
@synthesize action = _action;
@synthesize isLeader = _isLeader;
@synthesize isHeadedLeft = _isHeadedLeft;
@synthesize posX = _posX;
@synthesize posY = _posY;
@synthesize reference = _reference;
@synthesize score=_score;


- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias
{
    if ((self = [super init])) {
        _playerId = playerId;
        _alias = alias;
        _isHeadedLeft = false;
        _posX = 100;
        _posY = 80;
        _type=BEAR;
        _score=0;
        
    }
    return self;
}

- (void)updatePosition:(BOOL)isHeadedLeft posX:(int)posX posY:(int)posY{
    _isHeadedLeft = isHeadedLeft;
    _posX = posX;
    _posY = posY;
}

-(void) resetPositionAndChangeLeading{
    _posX=100;
    _posY=80;
   
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