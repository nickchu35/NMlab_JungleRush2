//
//  LoginScene.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "LoginScene.h"

@implementation LoginScene

-(void)go{
    CCScene *chooseScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:chooseScene];
}

@end
