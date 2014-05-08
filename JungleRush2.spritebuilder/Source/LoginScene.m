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
    
    
    
    
    ChooseScene *nextScene;
    nextScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:nextScene];
}


-(void)back{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}



@end
