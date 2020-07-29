//
//  ALCHomeChannelManager.h
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALCHomeChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kALCMyStaticChannelIndex = 2;

/// 频道数据加载完成通知
FOUNDATION_EXTERN NSNotificationName const ALCHomeChannelManagerDidLoadData;

@interface ALCHomeChannelManager : NSObject

/// 我的频道
@property (nonatomic, strong, readonly) NSMutableArray <ALCHomeChannelModel *> *myChannels;

/// 全部频道分类
@property (nonatomic, strong, readonly) NSArray <ALCHomeCategoryModel *> *allCategory;


+ (instancetype)shared;

/// 加载数据 AppDelegate 初始化调用
- (void)loadData;

/// 移动频道模型
/// @param indexPath 原始位置
/// @param toIndexPath 目标位置
- (void)moveChannelAtIndexPath:(NSIndexPath *)indexPath toIndexpath:(NSIndexPath *)toIndexPath;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
