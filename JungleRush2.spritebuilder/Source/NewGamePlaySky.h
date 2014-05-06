//
//  NewGamePlaySky.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface NewGamePlaySky : CCNode
{
    CCPhysicsNode *_physicsNode;
    CCSprite *bear;
    bool isHeadedLeft;
    CCNode *_levelNode;
}


@end
