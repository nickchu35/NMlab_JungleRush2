//
//  NewGamePlaySkyL.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Player.h"
#import "Match.h"
#import  <CoreMotion/CoreMotion.h>

@class Match;

@interface NewGamePlaySkyL : CCNode
{
    CCPhysicsNode *_physicsNode;
    
    CCSprite* _animal;
    CCSprite* _other;
    
    Player* _p1;
    Player* _p2;
    
    Match* _match;

    
    int absTime;
    int timeInterval;
    NSTimeInterval jumpTime;
    BOOL isOnAir;
    
    
}

@property (nonatomic, retain) CMMotionManager *motionManager;
@property (retain) Match *match;
@property (retain) Player *p1;
@property (retain) Player *p2;

@end

