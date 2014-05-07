//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)play {
    CCScene *loginScene = [CCBReader loadAsScene:@"LoginScene"];
    [[CCDirector sharedDirector] replaceScene:loginScene];
}

- (void)option {
    CCScene *optionScene = [CCBReader loadAsScene:@"OptionScene"];
    [[CCDirector sharedDirector] replaceScene:optionScene];
}

- (void)help {
    CCScene *helpScene = [CCBReader loadAsScene:@"HelpScene"];
    [[CCDirector sharedDirector] replaceScene:helpScene];
}

- (void)loginWithFacebook {
}

@end
