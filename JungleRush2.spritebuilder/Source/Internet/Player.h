//
//  Player.h
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject {
    NSString * _playerId;
    NSString * _alias;
    int _posX;
}

@property (retain) NSString *playerId;
@property (retain) NSString *alias;
@property  int posX;

- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias posX:(int)posX;

@end