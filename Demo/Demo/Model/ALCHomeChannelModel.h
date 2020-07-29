//
//  ALCHomeChannelModel.h
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ALCHomeChannelCategory) {
    ALCHomeChannelCategoryMy,
    ALCHomeChannelCategoryHot,
    ALCHomeChannelCategoryLife,
    ALCHomeChannelCategorySport,
    ALCHomeChannelCategoryArt,
    ALCHomeChannelCategoryOther
};

@class ALCHomeChannelModel;

@interface ALCHomeCategoryModel : NSObject

/// 分类标题
@property (nonatomic, copy) NSString *title;

/// 描述
@property (nonatomic, copy) NSString *subTitle;

/// 频道
@property (nonatomic, strong) NSMutableArray <ALCHomeChannelModel *> * channels;

/// 分类
@property (nonatomic, assign) ALCHomeChannelCategory category;

@end

@interface ALCHomeChannelModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 频道所属分类
@property (nonatomic, assign) ALCHomeChannelCategory category;

/// 是否新增为我的频道
@property (nonatomic, assign, getter=isNewly) BOOL newly;

/// 是否可以移动
@property (nonatomic, assign, getter=isCanMove) BOOL canMove;

@end

NS_ASSUME_NONNULL_END
