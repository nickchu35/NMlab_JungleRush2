//
//  UserClass.m
//  JungleRush2
//
//  Created by NMlab Mac on 2014/5/6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "UserClass.h"

@implementation UserClass

-(void)setCharacterNum:(size_t)num{
    characterNum = num;
}

-(void)setUserName:(NSString*)name{
   userName = name;
}

-(void)setUserPassword:(NSString*)pass{
    userPassword = pass;
}

-(NSString*)getUserName{
    return userName;
}

@end
