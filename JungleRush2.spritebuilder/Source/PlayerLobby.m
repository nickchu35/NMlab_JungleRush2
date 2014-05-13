//
//  PlayerLobby.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "PlayerLobby.h"
#import "WaitingForRespond.h"
#import "Player.h"
#import "NetworkController.h"

@implementation PlayerLobby

-(void)didLoadFromCCB{
    //WaitingForRespond* wait;
    //wait = [CCBReader loadAsScene:@"WaitingForRespond"];
    //[_messageboxNode addChild:wait];
    
    NSString *_path = @"WalkingAnimalSprite/Walking";
    
    NSString *_myAnimalName;
    if([NetworkController sharedInstance].myPlayer.type == BEAR){
        _myAnimalName = @"Bear";

    }
    else if([NetworkController sharedInstance].myPlayer.type == LEO){
        _myAnimalName = @"Leo";
        
    }
    else if ([NetworkController sharedInstance].myPlayer.type == DOG){
        _myAnimalName = @"Dog";
        
    }
    else{
        _myAnimalName = @"Squirl";
    }
    
    [_p1AnimalNode removeChild:_myAnimal cleanup: YES];
    NSString* full = [NSString stringWithFormat:@"%@%@", _path, _myAnimalName];
    _myAnimal = (CCSprite*)[CCBReader load:full];
    _myAnimal.scale = 0.5;
    CCLOG(@"animal was created!");
    [_p1AnimalNode addChild:_myAnimal];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NetworkController sharedInstance].myPlayer.playerId fontName:@"Arial" fontSize:24];    //by nick
    [_p1NameNode addChild:label];//by nick
    
        
    
    _layoutBox = [[CCLayoutBox alloc] init];
    _layoutBox.anchorPoint = ccp(0.5, 0.5);
    
    [self schedule:@selector(changeScene:) interval:0.1];
    [self schedule:@selector(playersUpdate:) interval:5];

}

+(id) sharedInstance {
    
    return self;
}

-(void)run{
    
    NSArray *players = [NetworkController sharedInstance].totalPlayers;
    [[NetworkController sharedInstance] sendStartMatch:players];
  
   
}

-(void) changeScene :(CCTime) dt{
    
    if([NetworkController sharedInstance].okToStart){
        
        CCScene *playScene = [CCBReader loadAsScene:@"NewGamePlaySkyL"];
        [[CCDirector sharedDirector] replaceScene:playScene];
        [self unschedule:@selector(_cmd)];
        
    }
    
}


-(void) playersUpdate:(CCTime)delta {
   
    
    
    NSArray* player=[NetworkController sharedInstance].totalPlayers;
    
    NSString *_path = @"WalkingAnimalSprite/Walking";
    NSString *_animalName;
    
    for(Player* obj in player)
    {
        if (obj == [NetworkController sharedInstance].myPlayer )
            continue;
        
        if( obj.type== BEAR){
            _animalName = @"Bear";
        
        }
        else if(obj.type == LEO){
            _animalName = @"Leo";
        
        }
        else if (obj.type == DOG){
            _animalName = @"Dog";
        
        }
        else{
            _animalName = @"Squirl";
        }
    
        [_p2AnimalNode removeChild:_animal1 cleanup: YES];
        NSString* full = [NSString stringWithFormat:@"%@%@", _path, _animalName];
        _animal1 = (CCSprite*)[CCBReader load:full];
        _animal1.scale = 0.1;
        CCLOG(@"animal was created!");
        [_p2AnimalNode addChild:_animal1];
    }
    
    
}




-(void)exit{
    CCScene *chooseScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:chooseScene];
}

-(void)appendLayout:(Player*)player{
    CCButton* button = [CCButton buttonWithTitle:player.playerId];
    [_layoutBox addChild:button];
}

-(void)deleteLayout:(Player*)player{
    for(int i = 0; i < [[_layoutBox children] count]; i++)
        if([[[[_layoutBox children] objectAtIndex:i] title] isEqualToString:player.alias])
            [_layoutBox removeChild:[[_layoutBox children] objectAtIndex:i]];
}

@end
