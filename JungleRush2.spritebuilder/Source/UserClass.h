//
//  UserClass.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface UserClass : CCSprite{
    size_t characterNum;
    NSString *userName;
    NSString *userPassword;
}

-(void)setCharacterNum:(size_t)num;
-(void)setUserName:(NSString*)name;
-(NSString*)getUserName;
-(void)setUserPassword:(NSString*)pass;

@end
