//
//  NetworkController.m
//  JungleRush2
//
//  Created by Apple on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//
#import "NetworkController.h"
#import "MessageWriter.h"
#import "MessageReader.h"
#import "Player.h"

@interface NetworkController (PrivateMethods)
- (BOOL)writeChunk;
@end

typedef enum {
    MESSAGE_PLAYER_CONNECTED = 0,
    MESSAGE_NOT_IN_MATCH,
    MESSAGE_NOTIFY_NEW_PLAYER,
    MESSAGE_NOTIFY_PLAYER_OFF,
    MESSAGE_INVITE_PLAYER,
    MESSAGE_CONFORM_INVITTATION,
    MESSAGE_REJECT_INVITATION,
    MESSAGE_START_MATCH,
    MESSAGE_MATCH_STARTED,
    MESSAGE_MOVED_SELF,
    MESSAGE_PLAYER_MOVED,
    MESSAGE_GAME_OVER,
    MESSAGE_RESTART_MATCH,
    MESSAGE_NOTIFY_READY,
} MessageType;

@implementation NetworkController
@synthesize gameCenterAvailable = _gameCenterAvailable;
@synthesize userAuthenticated = _userAuthenticated;
@synthesize delegate = _delegate;
@synthesize state = _state;

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize inputOpened = _inputOpened;
@synthesize outputOpened = _outputOpened;

@synthesize outputBuffer = _outputBuffer;
@synthesize okToWrite = _okToWrite;
@synthesize inputBuffer = _inputBuffer;

@synthesize totalPlayers = _totalPlayers;

#pragma mark - Helpers

static NetworkController *sharedController = nil;
+ (NetworkController *) sharedInstance {
    if (!sharedController) {
        sharedController = [[NetworkController alloc] init];
    }
    return sharedController;
}

- (BOOL)isGameCenterAvailable {
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (osVersionSupported);
}

- (void)setState:(NetworkState)state {
    _state = state;
    if (_delegate) {
        [_delegate stateChanged:_state];
    }
}

- (void)setNotInMatch{
}

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self setState:_state];
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (_gameCenterAvailable) {
            _state = NetworkStateNotAvailable;
            [self connect];
            _totalPlayers = [[NSMutableArray alloc] initWithCapacity:40];
            /*            NSNotificationCenter *nc =
             [NSNotificationCenter defaultCenter];
             [nc addObserver:self
             selector:@selector(authenticationChanged)
             name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
             */        }
    }
    return self;
}

#pragma mark - Message sending / receiving

- (void)processMessage:(NSData *)data {
    MessageReader * reader = [[MessageReader alloc] initWithData:data];
    
    unsigned char msgType = [reader readByte];
    if (msgType == MESSAGE_NOT_IN_MATCH) {
        [self setState:NetworkStateReceivedMatchStatus];
        [_delegate setNotInMatch];
    }
}

- (void)sendData:(NSData *)data {
    
    if (_outputBuffer == nil) return;
    
    int dataLength = data.length;
    dataLength = htonl(dataLength);
    [_outputBuffer appendBytes:&dataLength length:sizeof(dataLength)];
    [_outputBuffer appendData:data];
    if (_okToWrite) {
        [self writeChunk];
        NSLog(@"Wrote message");
    } else {
        NSLog(@"Queued message");
    }
}

- (void)sendPlayerConnected:(BOOL)continueMatch {
    [self setState:NetworkStatePendingMatchStatus];
    
    MessageWriter * writer = [[MessageWriter alloc] init];
    [writer writeByte:MESSAGE_PLAYER_CONNECTED];
    
    /*//Authenticate Player
     [writer writeString:[GKLocalPlayer localPlayer].playerID];
     [writer writeString:[GKLocalPlayer localPlayer].alias];
     //*/
    
    //Debug mode:
    [writer writeString:@"12345"];
    [writer writeString:@"larry"];
    
    //
    
    [writer writeByte:continueMatch];
    [self sendData:writer.data];
}

- (void)sendStartMatch:(NSArray *)players {
    [self setState:NetworkStatePendingMatchStart];
    
    MessageWriter * writer = [[MessageWriter alloc] init];
    [writer writeByte:MESSAGE_START_MATCH];
    
    [writer writeByte:players.count];
    for(NSString *playerId in players) {
        [writer writeString:playerId];
    }
    [self sendData:writer.data];
    
}

#pragma mark - Server communication

- (void)connect {
    
    self.outputBuffer = [NSMutableData data];
    self.inputBuffer = [NSMutableData data];
    [self setState:NetworkStateConnectingToServer];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 5566, &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (void)disconnect {
    
    [self setState:NetworkStateConnectingToServer];
    
    if (_inputStream != nil) {
        self.inputStream.delegate = nil;
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream close];
        self.inputStream = nil;
    }
    if (_outputStream != nil) {
        self.outputStream.delegate = nil;
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream close];
        self.outputStream = nil;
        self.outputBuffer = nil;
    }
}

- (void)reconnect {
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

- (void)checkForMessages {
    while (true) {
        if (_inputBuffer.length < sizeof(int)) {
            return;
        }
        
        int msgLength = *((int *) _inputBuffer.bytes);
        msgLength = ntohl(msgLength);
        if (_inputBuffer.length < msgLength) {
            return;
        }
        
        NSData * message = [_inputBuffer subdataWithRange:NSMakeRange(4, msgLength)];
        [self processMessage:message];
        
        int amtRemaining = _inputBuffer.length - msgLength - sizeof(int);
        if (amtRemaining == 0) {
            self.inputBuffer = [[NSMutableData alloc] init];
        } else {
            NSLog(@"Creating input buffer of length %d", amtRemaining);
            self.inputBuffer = [[NSMutableData alloc] initWithBytes:_inputBuffer.bytes+4+msgLength length:amtRemaining];
        }
        
    }
}

- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened input stream");
            _inputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                // TODO: Send message to server
                [self sendPlayerConnected:true];
            }
        }
        case NSStreamEventHasBytesAvailable: {
            if ([_inputStream hasBytesAvailable]) {
                NSLog(@"Input stream has bytes...");
                // TODO: Read bytes
                NSInteger       bytesRead;
                uint8_t         buffer[32768];
                
                bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    NSLog(@"Network read error");
                } else if (bytesRead == 0) {
                    NSLog(@"No data read, reconnecting");
                    [self reconnect];
                } else {
                    NSLog(@"Read %d bytes", bytesRead);
                    [_inputBuffer appendData:[NSData dataWithBytes:buffer length:bytesRead]];
                    [self checkForMessages];
                }
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO); // should never happen for the input stream
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (BOOL)writeChunk {
    int amtToWrite = MIN(_outputBuffer.length, 1024);
    if (amtToWrite == 0) return FALSE;
    
    NSLog(@"Amt to write: %d/%d", amtToWrite, _outputBuffer.length);
    
    int amtWritten = [self.outputStream write:_outputBuffer.bytes maxLength:amtToWrite];
    if (amtWritten < 0) {
        [self reconnect];
    }
    int amtRemaining = _outputBuffer.length - amtWritten;
    if (amtRemaining == 0) {
        self.outputBuffer = [NSMutableData data];
    } else {
        NSLog(@"Creating output buffer of length %d", amtRemaining);
        self.outputBuffer = [NSMutableData dataWithBytes:_outputBuffer.bytes+amtWritten length:amtRemaining];
    }
    NSLog(@"Wrote %d bytes, %d remaining.", amtWritten, amtRemaining);
    _okToWrite = FALSE;
    return TRUE;
}

- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened output stream");
            _outputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                // TODO: Send message to server
                [self sendPlayerConnected:true];
            }
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            BOOL wroteChunk = [self writeChunk];
            if (!wroteChunk) {
                _okToWrite = TRUE;
            }
            NSLog(@"Ok to send");
            // TODO: Write bytes
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (aStream == _inputStream) {
            [self inputStreamHandleEvent:eventCode];
        } else if (aStream == _outputStream) {
            [self outputStreamHandleEvent:eventCode];
        }
    });
}

#pragma mark - Players Management

- (void)addNewPlayer:(NSString*)playerId name:(NSString*)alias{
    Player* player = [[Player alloc] initWithPlayerId:playerId alias:alias posX:0];
    [_totalPlayers addObject:player];
}

- (void)deletePlayer:(NSString*)playerId name:(NSString*)alias{
    
    for(id obj in _totalPlayers){
        if([[obj playerId] isEqualToString:playerId]){
           [_totalPlayers removeObject:obj];
            return;
        }
    }
}


#pragma mark - Authentication
/*
 - (void)authenticationChanged {
 
 if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
 NSLog(@"Authentication changed: player authenticated.");
 [self setState:NetworkStateAuthenticated];
 _userAuthenticated = TRUE;
 [self connect];
 } else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
 NSLog(@"Authentication changed: player not authenticated");
 _userAuthenticated = FALSE;
 [self disconnect];
 [self setState:NetworkStateNotAvailable];
 }
 
 }
 
 - (void)authenticateLocalUser {
 
 if (!_gameCenterAvailable) return;
 
 NSLog(@"Authenticating local user...");
 if ([GKLocalPlayer localPlayer].authenticated == NO) {
 [self setState:NetworkStatePendingAuthentication];
 [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
 } else {
 NSLog(@"Already authenticated!");
 }
 }
 */
@end
