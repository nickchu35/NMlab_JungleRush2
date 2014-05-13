//
//  LoginScene.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "LoginScene.h"
#import "ChooseScene.h"
#import "UserClass.h"
#import "CCTextField.h"


@implementation LoginScene

-(void)didLoadFromCCB{
}


-(void)login{
   // [NetworkController sharedInstance].myAlias = [_accountField string];
   // [NetworkController sharedInstance].myPlayerId = [_pwdField string];
    
    [[NetworkController sharedInstance].myPlayer initWithPlayerId:[_pwdField string] alias:[_accountField  string]];
    
    [[NetworkController sharedInstance] sendPlayerConnected:true];
    
    CCScene *nextScene;
    nextScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:nextScene];
}


-(void)back{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}



@end
