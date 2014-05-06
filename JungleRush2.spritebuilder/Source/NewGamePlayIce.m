//
//  NewGamePlayIce.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/4/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "NewGamePlayIce.h"

@implementation NewGamePlayIce

- (void)test {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    bear = (CCSprite*)[CCBReader load:@"AnimalSprite/Bear"];
    bear.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    bear.scale = 0.5;
    CCLOG(@"bear was created!");
    [self addChild:bear];
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
