//
//  NewGamePlaySkyL.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "NetworkController.h"

@class Match;

@interface NewGamePlaySkyL : CCNode
{
    CCPhysicsNode *_physicsNode;
    CCSprite *animal;
    bool isHeadedLeft;
    Match *match;
    CCLabelBMFont *player1Label;
    CCLabelBMFont *player2Label;
}

@property (retain) Match *match;
@end
