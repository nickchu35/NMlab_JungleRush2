//
//  NetworkController.h
//  JungleRush2
//
//  Created by Apple on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface NetworkController : NSObject <NSStreamDelegate>{
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

    NSMutableArray *_totalPlayers;
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

@property (retain) NSMutableArray *totalPlayers;

+ (NetworkController *)sharedInstance;
//- (void)authenticateLocalUser;

@end