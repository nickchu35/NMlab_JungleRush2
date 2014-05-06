//
//  ChooseScene.h
//  JungleRush2
//
//  Created by NMlab Mac on 2014/4/25.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface ChooseScene : CCNode
{
    CCNode* _spriteNode;
    size_t character; //1:Bear 2:Leo 3:Dog 4:Squirl
    CCSprite* _animal;
}
@end
