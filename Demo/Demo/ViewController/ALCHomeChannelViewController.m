//
//  ALCHomeChannelViewController.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeChannelViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "ALCHomeChannelCell.h"
#import "ALCHomeChannelManager.h"
#import "ALCHomeMyChannelCollectionReusableView.h"
#import "ALCHomeCateogryEmptyCollectionReusableView.h"
#import <JXCategoryView/JXCategoryView.h>

static const CGFloat kALCTitleVeiwHeight = 44;

@interface ALCHomeChannelViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JXCategoryViewDelegate>

/// 关闭按钮
@property (nonatomic, weak) UIButton *closeButton;

/// 搜索按钮
@property (nonatomic, weak) UIButton *searchButton;

/// collectionView
@property (nonatomic, strong) UICollectionView *mainContainer;

///// flowLayout
@property (nonatomic, strong) __kindof UICollectionViewFlowLayout *flowLayout;

/// 长按手势（长按编辑频道）
@property (nonatomic, strong) UILongPressGestureRecognizer *editGestureRecognizer;

/// 是否正在编辑我的频道
@property (nonatomic, assign, getter=isEditEnabled) BOOL editChannel;

/// 分类header
@property (nonatomic, weak) UICollectionReusableView *categoryHeader;

/// 分类视图
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

/// 分类视图在collectionView中的y值
@property (nonatomic, assign) CGFloat categoryViewOriginY;

/// 我的频道header
@property (nonatomic, strong) ALCHomeMyChannelCollectionReusableView *myChannelHeader;

/// 长按手势识别的频道对应IndexPath
@property (nonatomic, strong) NSIndexPath *movingIndexPath;

/// 是否识别长按手势
@property (nonatomic, assign, getter=isEditGestureActive) BOOL editGestureActive;

/// 移动中的Cell
@property (nonatomic, weak) ALCHomeChannelCell *editingCell;

/// collectionView是否已经调整contentSize
@property (nonatomic, assign, getter=isAdjustContentSize) BOOL adjustContentSize;

@end

@implementation ALCHomeChannelViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.adjustContentSize) {
        [self calculateContentSize];
        self.adjustContentSize = YES;
    }
}

#pragma mark - UI
/// 界面布局
- (void)setupUI {
    // TODO: 暗黑模式适配
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * titleView = [self generateTitleView];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(kALCTitleVeiwHeight);
    }];
    
    [self.view addSubview:self.mainContainer];
    [self.mainContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //添加手势
    [self.mainContainer addGestureRecognizer:self.editGestureRecognizer];
}

/// 标题视图 包括关闭按钮以及搜索按钮
- (UIView *)generateTitleView {
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor clearColor];
    
    //关闭
    [titleView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.equalTo(titleView).offset(10);
        make.size.mas_equalTo(CGSizeMake(kALCTitleVeiwHeight, kALCTitleVeiwHeight));
    }];
    
    //搜索
    [titleView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView).offset(-10);
        make.centerY.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(kALCTitleVeiwHeight, kALCTitleVeiwHeight));
    }];
    
    return titleView;
}

#pragma mark - Private Methods
/// 数据加载
- (void)loadData {
    [self.mainContainer reloadData];
}

- (void)beginOrEndEditChannel {
    self.editChannel = !self.editChannel;
    self.myChannelHeader.editButton.selected = self.editChannel;
    for (ALCHomeChannelCell * cell in self.mainContainer.visibleCells) {
        [cell editEnabled:self.editChannel];
    }
}

/// 移动频道
/// @param indexPath 位置
- (void)moveChannelAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = 0;
    NSInteger row = [ALCHomeChannelManager shared].allCategory[section].channels.count;
    if (indexPath.section == ALCHomeChannelCategoryMy) {
        section = [ALCHomeChannelManager shared].allCategory[indexPath.section].channels[indexPath.row].category;
        row = 0;
    }
    NSIndexPath * targetIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
    [self moveChannelAtIndexPath:indexPath toIndexPath:targetIndexPath];
    [self.mainContainer moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
    ALCHomeChannelCell * cell = (ALCHomeChannelCell *)[self.mainContainer cellForItemAtIndexPath:targetIndexPath];
    [cell configureWithModel:[ALCHomeChannelManager shared].allCategory[targetIndexPath.section].channels[targetIndexPath.row] editEnabled:self.isEditEnabled];
}

/// 移动manager数据并且计算分类视图偏移量
/// @param indexPath 源
/// @param toIndexPath 目标
- (void)moveChannelAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [[ALCHomeChannelManager shared] moveChannelAtIndexPath:indexPath toIndexpath:toIndexPath];
    
    //计算偏移量
    NSInteger myChannelCount = [ALCHomeChannelManager shared].myChannels.count;
    NSInteger myChannelRow = myChannelCount / 4 + (myChannelCount % 4 == 0 ? 0 : 1);
    self.categoryViewOriginY = kALCTitleVeiwHeight + myChannelRow * self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing * myChannelRow;
    
    if (indexPath.section == [ALCHomeChannelManager shared].allCategory.count - 1 || toIndexPath.section == [ALCHomeChannelManager shared].allCategory.count - 1) {
        [self calculateContentSize];
    }
}

/// categoryView悬浮布局
/// @param y collectionView纵向偏移
- (void)layoutCategoryViewWithContentOffsetY:(CGFloat)y {
    if (y >= self.categoryViewOriginY && self.categoryView.superview != self.view) {
        [self.categoryView removeFromSuperview];
        [self.view addSubview:self.categoryView];
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kALCTitleVeiwHeight);
            make.height.mas_equalTo(kALCTitleVeiwHeight);
            make.left.equalTo(self.view).offset(9.5);
            make.right.equalTo(self.view).offset(-9.5);
        }];
    }
    else if (self.categoryHeader && y < self.categoryViewOriginY && self.categoryView.superview != self.categoryHeader){
        [self.categoryView removeFromSuperview];
        [self.categoryHeader addSubview:self.categoryView];
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.categoryHeader);
            make.bottom.equalTo(self.categoryHeader).offset(-10);
            make.height.mas_equalTo(kALCTitleVeiwHeight);
        }];
    }
}

- (void)selectCategoryViewWithContentOffsetY:(CGFloat)y {
    NSArray <NSIndexPath *> * visibleHeaderIndexPath = [self.mainContainer indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
    CGFloat anchorY = y + kALCTitleVeiwHeight;
    __block NSIndexPath * indexPath = nil;
    [visibleHeaderIndexPath enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes * attr = [self.mainContainer layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:obj];
        if (CGRectContainsPoint(attr.frame, CGPointMake(1, anchorY))) {
            indexPath = obj;
            *stop = YES;
        }
    }];
    if (indexPath && self.categoryView.selectedIndex != indexPath.section - 1) {
        [self.categoryView selectItemAtIndex:indexPath.section - 1];
    }
}

- (void)calculateContentSize {
    NSInteger lastChannelCount = [ALCHomeChannelManager shared].allCategory.lastObject.channels.count;
    NSInteger row = lastChannelCount / 4 + (lastChannelCount % 4 ? 1 : 0);
    CGFloat lastChannelHeight = row * self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing * (row - 1) + kALCTitleVeiwHeight * 2;
    if (row == 0) {
        lastChannelHeight += kALCTitleVeiwHeight;
    }
    CGFloat bottomEdge = self.mainContainer.bounds.size.height - lastChannelHeight;
    if (bottomEdge > 0) {
        self.mainContainer.contentInset = UIEdgeInsetsMake(10, 10,  bottomEdge, 10);
    }
}

#pragma mark - Actions


- (void)editGestureRecognizerAction:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.mainContainer indexPathForItemAtPoint:[sender locationInView:self.mainContainer]];
            if(indexPath == nil){//如果没有选中cell返回
                return;
            }
            if ([ALCHomeChannelManager shared].allCategory[indexPath.section].channels[indexPath.row].canMove) {
                self.editGestureActive = YES;
                self.movingIndexPath = indexPath;
                self.editingCell = (ALCHomeChannelCell *)[self.mainContainer cellForItemAtIndexPath:indexPath];
                self.editingCell.transform = CGAffineTransformMakeScale(1.1, 1.1);
                [self.mainContainer beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            if (!self.editChannel) {
                [self beginOrEndEditChannel];
            }
        }
            break;
        case UIGestureRecognizerStateChanged://更新cell位置
            if (self.editGestureActive) {
                [self.mainContainer updateInteractiveMovementTargetPosition:[sender locationInView:self.mainContainer]];
            }
            break;
        case UIGestureRecognizerStateEnded://完成移动cell
            if (self.editGestureActive) {
                self.editGestureActive = NO;
                self.editingCell.transform = CGAffineTransformIdentity;
                self.editingCell = nil;
                CGPoint location = [sender locationInView:self.mainContainer];
                [self.mainContainer updateInteractiveMovementTargetPosition:CGPointMake(location.x, location.y + 1)];
                [self.mainContainer endInteractiveMovement];
            }
            break;
        default://如果手势被中断则取消移动操作
            if (self.editGestureActive) {
                self.editGestureActive = NO;
                self.editingCell.transform = CGAffineTransformIdentity;
                self.editingCell = nil;
                self.movingIndexPath = nil;
                [self.mainContainer cancelInteractiveMovement];
            }
            break;
    }
}

#pragma mark - Delegate & DataSource
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [ALCHomeChannelManager shared].allCategory.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ALCHomeChannelManager shared].allCategory[section].channels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        ALCHomeChannelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
        
        [cell configureWithModel:[ALCHomeChannelManager shared].allCategory[indexPath.section].channels[indexPath.row] editEnabled:self.isEditEnabled];
        
        cell.layer.zPosition = 1.0;
        
        return cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    [self layoutCategoryViewWithContentOffsetY:y];
    if (scrollView.dragging) {
        [self selectCategoryViewWithContentOffsetY:y];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.categoryView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.categoryView.userInteractionEnabled = YES;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([ALCHomeChannelManager shared].allCategory[indexPath.section].category == ALCHomeChannelCategoryMy) {
        if (self.editChannel) {
            [self moveChannelAtIndexPath:indexPath];
        }
        else {
            //TODO: 切换到首页选中相关页面
        }
    }
    else {
        [self moveChannelAtIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ALCHomeCateogryEmptyCollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
    ALCHomeCategoryModel * model = [ALCHomeChannelManager shared].allCategory[indexPath.section];
    if (model.category == ALCHomeChannelCategoryHot) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"categoryHeader" forIndexPath:indexPath];
        self.categoryHeader = header;
        [self layoutCategoryViewWithContentOffsetY:self.mainContainer.contentOffset.y];
        return self.categoryHeader;
    }
    else if (model.category == ALCHomeChannelCategoryMy) {
        if (self.myChannelHeader == nil) {
            ALCHomeMyChannelCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"myChannelHeader" forIndexPath:indexPath];
            [header configureWithModel:model editing:self.editChannel];
            @weakify(self)
            [[header.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *  _Nullable x) {
                @strongify(self)
                [self beginOrEndEditChannel];
            }];
            self.myChannelHeader = header;
        }
        return self.myChannelHeader;
    }
    else {
        ALCHomeCategoryCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        [header configureWithModel:model];
        return header;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL flag = [ALCHomeChannelManager shared].allCategory[indexPath.section].channels[indexPath.row].canMove;
    return flag;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveChannelAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    self.movingIndexPath = nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    
    NSIndexPath * targetIndexPath = nil;
    if (proposedIndexPath.section == 0) {
        if (proposedIndexPath.row >= kALCMyStaticChannelIndex) {
            targetIndexPath = proposedIndexPath;
        }
        else {
            targetIndexPath = self.movingIndexPath;
        }
    }
    else {
        if (self.editGestureActive) {
            targetIndexPath = self.movingIndexPath;
        }
        else {
            targetIndexPath = [NSIndexPath indexPathForItem:0 inSection:[ALCHomeChannelManager shared].allCategory[self.movingIndexPath.section].channels[self.movingIndexPath.row].category];
        }
    }
    return targetIndexPath;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, kALCTitleVeiwHeight + 10);
    }
    else {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, kALCTitleVeiwHeight);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([ALCHomeChannelManager shared].allCategory[section].channels.count) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0);
    }
    else {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, kALCTitleVeiwHeight);
    }
}

#pragma mark JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.mainContainer.dragging) {
        return;
    }
    UICollectionViewLayoutAttributes * attr = [self.mainContainer layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:index + 1]];
    [self.mainContainer setContentOffset:CGPointMake(-10, attr.frame.origin.y - (index == 0 ? 0 : kALCTitleVeiwHeight)) animated:YES];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}



#pragma mark - Getters & Setters
- (UICollectionView *)mainContainer {
    if (_mainContainer == nil) {
        _mainContainer = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _mainContainer.backgroundColor = [UIColor clearColor];
        [_mainContainer registerClass:[ALCHomeChannelCell class] forCellWithReuseIdentifier:@"channelCell"];
        [_mainContainer registerClass:[ALCHomeCategoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_mainContainer registerClass:[ALCHomeMyChannelCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myChannelHeader"];
        [_mainContainer registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"categoryHeader"];
        [_mainContainer registerClass:[ALCHomeCateogryEmptyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _mainContainer.delegate = self;
        _mainContainer.dataSource = self;
        _mainContainer.showsVerticalScrollIndicator = NO;
        _mainContainer.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _mainContainer;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        UIButton * closeButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        closeButton.backgroundColor = [UIColor clearColor];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _closeButton = closeButton;
    }
    return _closeButton;
}

- (UIButton *)searchButton {
    if (_searchButton == nil) {
        UIButton * searchButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchButton.backgroundColor = [UIColor clearColor];
        searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _searchButton = searchButton;
    }
    return _searchButton;
}

- (__kindof UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50) / 4, ([UIScreen mainScreen].bounds.size.width - 50) / 8);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
    }
    return _flowLayout;
}

- (UILongPressGestureRecognizer *)editGestureRecognizer {
    if (_editGestureRecognizer == nil) {
        _editGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editGestureRecognizerAction:)];
    }
    return _editGestureRecognizer;
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelStrokeWidthEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.28;
        _categoryView.titleFont = [UIFont systemFontOfSize:14];
        _categoryView.delegate = self;
        _categoryView.titleColor = [UIColor lightGrayColor];
        _categoryView.titleSelectedColor = [UIColor blackColor];
        _categoryView.backgroundColor = UIColor.whiteColor;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
        lineView.indicatorColor = [UIColor redColor];
        _categoryView.indicators = @[lineView];
        NSMutableArray * titles = [NSMutableArray array];
        [[ALCHomeChannelManager shared].allCategory enumerateObjectsUsingBlock:^(ALCHomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx) {
                [titles addObject:obj.title];
            }
        }];
        _categoryView.titles = titles.copy;
    }
    return _categoryView;
}

- (CGFloat)categoryViewOriginY {
    if (_categoryViewOriginY == 0) {
        NSInteger myChannelCount = [ALCHomeChannelManager shared].myChannels.count;
        NSInteger myChannelRow = myChannelCount / 4 + (myChannelCount % 4 == 0 ? 0 : 1);
        _categoryViewOriginY = kALCTitleVeiwHeight + myChannelRow * self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing * myChannelRow;
    }
    return _categoryViewOriginY;
}

@end
