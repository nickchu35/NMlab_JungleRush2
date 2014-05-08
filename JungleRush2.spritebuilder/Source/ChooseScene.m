//
//  ChooseScene.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/4/25.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "ChooseScene.h"

@implementation ChooseScene

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    character = 1;
    [self loadAnimal];
}

- (void)start {
    CCScene *lobbyScene = [CCBReader loadAsScene:@"PlayerLobby"];
    [[CCDirector sharedDirector] replaceScene:lobbyScene];
}

- (void)backToMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)prev{
    if(character == 1){
        character = 4;
    }
    else character--;
    [self loadAnimal];
}

- (void)next{
    if(character == 4){
        character = 1;
    }
    else character++;
    [self loadAnimal];
}

- (void)loadAnimal{
    double _size = 1.5;;
    NSString *path = @"WalkingAnimalSprite/Walking";
    NSString *animalName = @"Bear";
    if(character == 1){
        animalName = @"Bear";
        _size = 0.75;
    }
    else if(character == 2){
        animalName = @"Leo";
        _size = 1.75;
    }
    else if (character == 3){
        animalName = @"Dog";
    }
    else{
        animalName = @"Squirl";
        _size = 1.75;
    }
    [_spriteNode removeChild:_animal cleanup: YES];
    NSString* full = [NSString stringWithFormat:@"%@%@", path, animalName];
    _animal = (CCSprite*)[CCBReader load:full];
    _animal.scale = _size;
    CCLOG(@"animal was created!");
    [_spriteNode addChild:_animal];
}

-(void)stateChanged:(NetworkState)state {
    switch(state) {
        case NetworkStateNotAvailable:
            NSLog(@"Not Available");
            break;
        case NetworkStatePendingAuthentication:
            NSLog(@"Pending Authentication");
            break;
        case NetworkStateAuthenticated:
            NSLog(@"Authenticated");
            break;
        case NetworkStateConnectingToServer:
            NSLog(@"Connecting to Server");
            break;
        case NetworkStateConnected:
            NSLog(@"Connected");
            break;
        case NetworkStatePendingMatchStatus:
            NSLog(@"Pending Match Status");
            break;
        case NetworkStateReceivedMatchStatus:
            NSLog(@"Received Match Status");
            break;
    }
}

@end
