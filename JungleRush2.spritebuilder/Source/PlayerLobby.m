//
//  PlayerLobby.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "PlayerLobby.h"

@implementation PlayerLobby


-(void)run{
    CCScene *playScene = [CCBReader loadAsScene:@"NewGamePlaySkyL"];
    [[CCDirector sharedDirector] replaceScene:playScene];
}

-(void)back{
    CCScene *chooseScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:chooseScene];
}

@end
