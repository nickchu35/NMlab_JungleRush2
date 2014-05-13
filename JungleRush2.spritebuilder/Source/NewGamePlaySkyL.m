//
//  NewGamePlaySkyL.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "NewGamePlaySkyL.h"
#import "NetworkController.h"

@implementation NewGamePlaySkyL

@synthesize match = _match;
@synthesize p1 = _p1;
@synthesize p2 = _p2;

    - (void)didLoadFromCCB {
        
        // tell this scene to accept touches
        self.userInteractionEnabled = TRUE;
        [self matchStarted];
        
        //determine type of animal
        if (_p1.type == BEAR)
            _animal = (CCSprite*)[CCBReader load:@"AnimalSprite/Bear"];
        _animal.position  = ccp(100, 80);   //ccp(self.contentSize.width/2,self.contentSize.height/2);
        _animal.scale = 0.3;
        CCLOG(@"animal was created!");
        
        if (_p2.type == BEAR)
            _other = (CCSprite*)[CCBReader load:@"AnimalSprite/Bear"];
        _other.position = ccp(100, 80);
        _other.scale = 0.3;
        CCLOG(@"other was created!");
        
        
        
        _p1.reference = _animal;
        _p2.reference = _other;
        _p1.isHeadedLeft = false;
        _p2.isHeadedLeft = false;
        
        [_physicsNode addChild:_animal]; //換成physics家看看
        [_physicsNode addChild:_other];
        
        
        // follow the bear
        CCActionFollow *follow = [CCActionFollow actionWithTarget:_animal worldBoundary:self.boundingBox];
        [self runAction:follow];
        
        [[OALSimpleAudio sharedInstance] playBg:@"TokyoDrift.mp3" loop:YES];  //add music
        
        _motionManager = [[CMMotionManager alloc] init];
        if (_motionManager.accelerometerAvailable) {
            _motionManager.accelerometerUpdateInterval = 1.0/10.0;
            [_motionManager startAccelerometerUpdates];
        } else {
            NSLog(@"This device has no accelerometer.");
        }
        
        [self schedule:@selector(checkOver:) interval:1];
        
        [NetworkController sharedInstance].myMatch.round=0;
        
    }
    
    -(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
       
      /*
       
        CGPoint touchLoc = [touch locationInNode:self];
        
        if(touchLoc.x > _animal.position.x && _p1.isHeadedLeft ){
            [_animal setFlipX:false];
            _p1.isHeadedLeft = false;
        }
        if(touchLoc.x < _animal.position.x && !_p1.isHeadedLeft ){
            [_animal setFlipX:true];
            _p1.isHeadedLeft = true;
        }
        
        // Log touch location
        CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
        CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
        [_animal runAction:actionMove];
       
       */
        
        CGPoint _jumpForce=ccp(0,4000.f);
        [_animal.physicsBody applyImpulse:_jumpForce];
        
        jumpTime=0.f;
        isOnAir=TRUE;
        
    }



- (void)matchStarted{
    
    _match = [NetworkController sharedInstance].myMatch;
    
    
    NSLog(@"obj1 is %@ , obj2 is %@",((Player* ) [_match.players objectAtIndex:0]).playerId,((Player*)[_match.players objectAtIndex:1]).playerId);
    
    
    if( [((Player*)[_match.players objectAtIndex:0]).playerId isEqualToString: [NetworkController sharedInstance].myPlayer.playerId ] ){
        _p1=[_match.players objectAtIndex:0];
        _p2 = [_match.players objectAtIndex:1];
    }
    else{
        _p1=[_match.players objectAtIndex:1];
        _p2 = [_match.players objectAtIndex:0];
        
        
    }
    
    if(_match.round==0){
        
        ((Player*)[_match.players objectAtIndex:0]).isLeader=TRUE;
        ((Player*)[_match.players objectAtIndex:1]).isLeader=FALSE;
        
    }else{
        
        ((Player*)[_match.players objectAtIndex:1]).isLeader=TRUE;
        ((Player*)[_match.players objectAtIndex:0]).isLeader=FALSE;
    
    }
    
    absTime=0;
    timeInterval=0;
    isOnAir=FALSE;

    NSLog(@"P1 is %@ ",_p1.playerId);
    
}

- (void)update:(CCTime)dt {
    
    if (_motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
        //NSLog(@"(%f,%f,%f)",accelerometerData.acceleration.x, accelerometerData.acceleration.y ,accelerometerData.acceleration.z);   //陀螺儀debug
        if ( accelerometerData.acceleration.z < 0 ) {
            
            if(accelerometerData.acceleration.y > 0 ){
                [_animal setFlipX:true];
                _p1.isHeadedLeft = true;
                CGPoint force;                                                                       //Nick
                if(accelerometerData.acceleration.y < 0.4){
                    CGFloat yForce = (CGFloat)accelerometerData.acceleration.y * (-10);
                    force = ccp( yForce , 0.f);
                }
                else force = ccp(-4,0);
                CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:0.1f position:force];//Nick
                [_animal runAction:actionMove];
            }
            else if (accelerometerData.acceleration.y < 0){
                [_animal setFlipX:false];
                _p1.isHeadedLeft = false;
                CGPoint force;                                                                       //Nick
                if(accelerometerData.acceleration.y < 0.4){
                    CGFloat yForce = (CGFloat)accelerometerData.acceleration.y * (10);
                    force = ccp( yForce , 0.f);
                }
                else force = ccp(4,0);
                CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:0.1f position:force];//Nick
                [_animal runAction:actionMove];
            }
            else{
                
                
            }
        }
    }
    else{
       // NSLog(@"Motion is not available");
    }
    
    jumpTime+=dt;
    
    if( jumpTime>0.5f && isOnAir==TRUE){
        
        CGPoint downForce=ccp(0,-10000.f);
        [_animal.physicsBody applyImpulse:downForce];
        isOnAir=FALSE;
        
    }
    
    //send
     [[NetworkController sharedInstance] sendMoveSelf:_p1.isHeadedLeft posX:_animal.position.x posY:_animal.position.y];
    
    CGPoint position1=ccp(_animal.position.x,_animal.position.y);
    CGPoint position2;
    
    
    for (Player *obj in _match.players ){
        
        if(obj == _p1)
            continue;
        if (obj.isHeadedLeft)
            [obj.reference setFlipX:true];
        else
            [obj.reference setFlipX:false];

        obj.reference.position = ccp(obj.posX, obj.posY);
        position2=obj.reference.position;
        
    }
    
}

-(void) checkOver:(CCTime)dt{
    
    
    // NonLeader calculate the result
    CGPoint position1=ccp(_animal.position.x,_animal.position.y);
    CGPoint position2;
    
    
    for (Player *obj in _match.players ){
        if(obj == _p1)
            continue;
        obj.reference.position = ccp(obj.posX, obj.posY);
        position2=obj.reference.position;
        
    }
    
    
    
    if(!_p1.isLeader){
        CGPoint posDifference = ccpSub(position1,position2);
        float distanceToMove = ccpLength(posDifference);
        
        if(distanceToMove> self.contentSize.width/4){
            timeInterval++;
            if(timeInterval>3)
                [self sendNotifyNewGame];
        }else{
            timeInterval=0;
        }
        
    }else{
        
        if(absTime>15)
            [self sendNotifyNewGame];
    }

    
}

-(void)sendNotifyNewGame{
    
    NSLog(@"I am sendNotifyNewGame");
    [[NetworkController sharedInstance] sendNotifyNewGameSelf:[NetworkController sharedInstance].totalPlayers];
    
}

@end
