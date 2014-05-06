//
//  OptionScene.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/4/25.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "OptionScene.h"

@implementation OptionScene

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)backToMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
