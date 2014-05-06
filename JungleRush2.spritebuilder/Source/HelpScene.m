//
//  HelpScene.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/4/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "HelpScene.h"

@implementation HelpScene

- (void)backToMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
