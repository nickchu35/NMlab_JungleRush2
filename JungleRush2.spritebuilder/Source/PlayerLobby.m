//
//  PlayerLobby.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "PlayerLobby.h"
#import "WaitingForRespond.h"

@implementation PlayerLobby

-(void)didLoadFromCCB{
    //WaitingForRespond* wait;
    //wait = [CCBReader loadAsScene:@"WaitingForRespond"];
    //[_messageboxNode addChild:wait];
}

-(void)run{
    CCScene *playScene = [CCBReader loadAsScene:@"NewGamePlaySkyL"];
    [[CCDirector sharedDirector] replaceScene:playScene];
}

-(void)exit{
    CCScene *chooseScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:chooseScene];
}

@end
