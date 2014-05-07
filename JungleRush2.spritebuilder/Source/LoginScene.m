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
    [_nameTextField setSelected:true];
    [_nameTextField setVisible:false];
}
-(void)go{
    UserClass *user;
    [user setUserName:@"Nick"];
    //NSString *str = [user getUserName];
    NSString *str2 = [_nameTextField string];
    //NSLog(@"%@",str);
    NSLog(@"%@",str2);
    
    
    
    
    ChooseScene *nextScene;
    nextScene = [CCBReader loadAsScene:@"ChooseScene"];
    [[CCDirector sharedDirector] replaceScene:nextScene];
}



@end
