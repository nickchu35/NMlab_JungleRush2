//
//  MessageWriter.h
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MessageWriter : NSObject {
    NSMutableData * _data;
}

@property (retain, readonly) NSMutableData * data;

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeString:(NSString *)value;

@end