//
//  WaitingForRespond.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/8.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "WaitingForRespond.h"

@implementation WaitingForRespond

-(void)didLoadFromCCB{
    [self startTimer];
    
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeup) userInfo:nil repeats:YES];
}

- (void) timeup{
    CCScene *lobbyScene = [CCBReader loadAsScene:@"PlayerLobby"];
    [[CCDirector sharedDirector] replaceScene:lobbyScene];
}

- (void) stopTimer{
    [timer invalidate];
    timer = nil;
}

@end
