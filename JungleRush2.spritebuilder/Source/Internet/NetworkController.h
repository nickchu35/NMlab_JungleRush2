//
//  NetworkController.h
//  JungleRush2
//
//  Created by Apple on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

typedef enum {
    
    NetworkStateNotAvailable,
    NetworkStatePendingAuthentication,
    NetworkStateAuthenticated,
    
    NetworkStateConnectingToServer,
    NetworkStateConnected,
    NetworkStatePendingMatchStatus,
    NetworkStateReceivedMatchStatus,
    
    NetworkStatePendingMatch,
    NetworkStatePendingMatchStart,
    NetworkStateMatchActive,
    
} NetworkState;

@class Match;

@protocol NetworkControllerDelegate
- (void)stateChanged:(NetworkState)state;
- (void)setNotInMatch;
- (void)matchStarted:(Match *)match;
@end

@interface NetworkController : NSObject <NSStreamDelegate>
{
    BOOL _gameCenterAvailable;
    BOOL _userAuthenticated;
    //  id <NetworkControllerDelegate> _delegate;
    NetworkState _state;
    
    //For Socket connection
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    BOOL _inputOpened;
    BOOL _outputOpened;
    
    NSMutableData *_outputBuffer;
    BOOL _okToWrite;
    NSMutableData *_inputBuffer;
    
    BOOL _okToStart;
    NSMutableArray *_totalPlayers;
    
    Player *_myPlayer;
    Match *_myMatch;
    
    //NSString *_myPlayerId;
    //NSString *_myAlias;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (nonatomic, weak) id <NetworkControllerDelegate> delegate;
@property (assign, readonly) NetworkState state;

@property (retain) NSInputStream *inputStream;
@property (retain) NSOutputStream *outputStream;
@property (assign) BOOL inputOpened;
@property (assign) BOOL outputOpened;

@property (retain) NSMutableData *outputBuffer;
@property (assign) BOOL okToWrite;
@property (retain) NSMutableData *inputBuffer;

@property (assign) BOOL okToStart;
@property (retain) NSMutableArray *totalPlayers;
@property (retain) Player *myPlayer;
@property (retain) Match *myMatch;

//@property (copy) NSString *myPlayerId;
//@property (copy) NSString *myAlias;

+ (NetworkController *)sharedInstance;
//- (void)authenticateLocalUser;
- (void)sendPlayerConnected:(BOOL)continueMatch;
- (void)sendStartMatch:(NSArray *)players ;
- (void)sendMoveSelf:(bool)isHeadedLeft posX:(int)posX posY:(int)posY;
- (void)sendNotifyNewGameSelf:(NSArray* ) players;

@end