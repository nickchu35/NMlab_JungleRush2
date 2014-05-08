//
//  PlayerLobby.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface PlayerLobby : CCNode{
    NSMutableArray *playerArray;
    CCNode* _messageboxNode;
    
    CCNode* _p1NameNode;
    CCNode* _p2NameNode;
    CCNode* _p3NameNode;
    CCNode* _p4NameNode;
    CCNode* _p1AnimalNode;
    CCNode* _p2AnimalNode;
    CCNode* _p3AnimalNode;
    CCNode* _p4AnimalNode;
}
@end
