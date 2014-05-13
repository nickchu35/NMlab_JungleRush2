//
//  Player.h
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BEAR = 0,
    LEO,
    DOG,
    SQUIRL
} AnimalType;

typedef enum {
    JUMP = 0,
    MOVE_LEFT,
    MOVE_RIGHT,
    HEADED_RIGHT,
    HEADED_LEFT,
} ActionType;


@interface Player : NSObject {
    NSString * _playerId;
    NSString * _alias;
    
    AnimalType _type;
    ActionType _action;
    
    bool _isLeader;
    bool _isHeadedLeft;
    int _posX;
    int _posY;
    
    int _score;
    
    CCSprite* _reference;
}

@property (copy) NSString *playerId;
@property (copy) NSString *alias;

@property AnimalType type;
@property ActionType action;
@property bool isLeader;
@property bool isHeadedLeft;
@property  int posX;
@property  int posY;
@property int score;

@property (retain) CCSprite* reference;

- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias;
- (void)updatePosition:(BOOL)isHeadedLeft posX:(int)posX posY:(int)posY;
- (void) resetPositionAndChangeLeading;

@end