//
//  Match.h
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MatchStateActive = 0,
    MatchStateGameOver
} MatchState;

@interface Match : NSObject {
    MatchState _state;
    NSArray * _players;
    int _round;
}

@property  MatchState state;
@property (retain) NSArray *players;
@property int round;

- (id)initWithState:(MatchState)state players:(NSArray*)players;

@end