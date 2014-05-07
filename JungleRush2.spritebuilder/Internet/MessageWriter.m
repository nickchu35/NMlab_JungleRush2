//
//  MessageWriter.m
//  JungleRush2
//
//  Created by Apple on 2014/5/7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "MessageWriter.h"

@implementation MessageWriter
@synthesize data = _data;

- (id)init {
    if ((self = [super init])) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)writeBytes:(void *)bytes length:(int)length {
    [_data appendBytes:bytes length:length];
}

- (void)writeByte:(unsigned char)value {
    [self writeBytes:&value length:sizeof(value)];
}

- (void)writeInt:(int)intValue {
    int value = htonl(intValue);
    [self writeBytes:&value length:sizeof(value)];
}

- (void)writeString:(NSString *)value {
    const char * utf8Value = [value UTF8String];
    int length = strlen(utf8Value) + 1; // for null terminator
    [self writeInt:length];
    [self writeBytes:(void *)utf8Value length:length];
}

- (void)dealloc {
    /*
     [_data release];
     [super dealloc];
     */
}

@end
