//
//  ALCHomeChannelCell.h
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALCHomeChannelModel;
NS_ASSUME_NONNULL_BEGIN

@interface ALCHomeChannelCell : UICollectionViewCell

- (void)configureWithModel:(ALCHomeChannelModel *)model editEnabled:(BOOL)enabled;

- (void)editEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
