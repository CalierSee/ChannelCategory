//
//  ALCHomeChannelManager.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeChannelManager.h"

/// 频道数据加载完成通知
NSNotificationName const ALCHomeChannelManagerDidLoadData = @"ALCHomeChannelManagerDidLoadData";

@interface ALCHomeChannelManager ()

/// 全部频道分类
@property (nonatomic, strong) NSArray <ALCHomeCategoryModel *> *allCategory;

@end

@implementation ALCHomeChannelManager

+ (instancetype)shared {
    static ALCHomeChannelManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ALCHomeChannelManager alloc]init];
    });
    return instance;
}

#pragma mark - private method
- (void)loadData {
    NSMutableArray * categorys = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        ALCHomeCategoryModel * category = [[ALCHomeCategoryModel alloc]init];
        category.category = i;
        category.channels = [NSMutableArray array];
        int count = arc4random_uniform(20) + 10;
        if (i == 0) {
            count = 2;
        }
        for (int j = 0; j < count; j++) {
            ALCHomeChannelModel * channel = [[ALCHomeChannelModel alloc]init];
            channel.title = @(i * 100 + j).description;
            channel.category = i;
            [category.channels addObject:channel];
        }
        [categorys addObject:category];
    }
    self.allCategory = categorys.copy;
    [[NSNotificationCenter defaultCenter] postNotificationName:ALCHomeChannelManagerDidLoadData object:nil];
}

- (void)moveChannelAtIndexPath:(NSIndexPath *)indexPath toIndexpath:(NSIndexPath *)toIndexPath {
    ALCHomeChannelModel * model = self.allCategory[indexPath.section].channels[indexPath.row];
    [self.allCategory[indexPath.section].channels removeObjectAtIndex:indexPath.row];
    [self.allCategory[toIndexPath.section].channels insertObject:model atIndex:toIndexPath.row];
    
    if (toIndexPath.section == 0) {
        if (toIndexPath.section != indexPath.section) {
            model.newly = YES;
        }
        model.canMove = YES;
    }
    else {
        model.newly = NO;
        model.canMove = NO;
    }
}

#pragma mark - getter & setter

- (NSMutableArray<ALCHomeChannelModel *> *)myChannels {
    return self.allCategory.firstObject.channels;
}

@end
