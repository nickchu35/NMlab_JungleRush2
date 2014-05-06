//
//  NewGamePlaySky.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "NewGamePlaySky.h"

@implementation NewGamePlaySky

- (void)didLoadFromCCB {
// tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //level用加的
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];

 
    bear = (CCSprite*)[CCBReader load:@"AnimalSprite/Bear"];
    bear.position  = ccp(180,80);//ccp(self.contentSize.width/2,self.contentSize.height/2);
    bear.scale = 0.3;
    CCLOG(@"bear was created!");
    [_physicsNode addChild:bear]; //換成physics家看看

    isHeadedLeft = true;
 
// follow the bear
    CCActionFollow *follow = [CCActionFollow actionWithTarget:bear worldBoundary:self.boundingBox];
    [self runAction:follow];
 
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
 
    if(touchLoc.x > bear.position.x && isHeadedLeft){
        [bear setFlipX:true];
        isHeadedLeft = false;
    }
    if(touchLoc.x < bear.position.x && !isHeadedLeft){
        [bear setFlipX:true];
        isHeadedLeft = true;
    }
 
// Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
 
// Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [bear runAction:actionMove];
}


@end
