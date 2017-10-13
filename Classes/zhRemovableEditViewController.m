//
//  zhRemovableEditViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditViewController.h"
#import "zhRemovableEditLayout.h"

@implementation zhRemovableEditViewLayout

+ (instancetype)defaultLayout {
    zhRemovableEditViewLayout *layout = [[zhRemovableEditViewLayout alloc] init];
    layout.displayCount = 4;
    layout.sectionInset = UIEdgeInsetsMake(0, zh_sizeFitW(15), 0, zh_sizeFitW(15));
    layout.sectionHeight = zh_sizeFitH(50);
    layout.horizontalSpacing = zh_sizeFitW(15);
    layout.verticalSpacing = zh_sizeFitH(20);
    layout.sizeScale = 1.2;
    return layout;
}

- (CGFloat)horizontalAllPadding {
    return ceil((self.displayCount - 1) * self.horizontalSpacing) + self.sectionInset.left + self.sectionInset.right;
}

@end

@interface zhRemovableEditViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, zhRemovableEditLayoutDelegate, zhRemovableEditLayoutDataSource, zhRemovableEditCollectionViewCellDelegate>

@property (nonatomic, assign, readonly) BOOL zhIsMaxing;
@property (nonatomic, assign, readonly) BOOL zhIsHudShowing;
@property (nonatomic, strong, readonly) UIButton *zhAlertHud;

@end

static NSString *const zhRemovableEditCellIdentify = @"zh_removableEditCell";
static NSString *const zhRemovableEditReusableHeaderIdentify = @"zh_removableEditReusableHeader";

@implementation zhRemovableEditViewController

- (instancetype)init {
    if (self = [super init]) {
        [self zh_commonConfiguration];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self commonInitialization];
    [self zh_loadData];
}

- (void)zh_reloadData {
    [self zh_commonConfiguration];
    [self.collectionView reloadData];
}

- (void)zh_loadData {
    self.dataArray = @[].mutableCopy;
    [self zh_reloadData];
}

- (void)zh_commonConfiguration {
    self.reLayout = [zhRemovableEditViewLayout defaultLayout];
    self.reImages = [zhRemovableEditSetImages defaultImages];
    self.showReservezone = NO;
    self.useSpringAnimation = NO;
    self.fixedCount = 0;
    self.maxCount = 0;
}

- (void)commonInitialization {
    zhRemovableEditLayout *layout = [[zhRemovableEditLayout alloc] init];
    layout.delegate = self;
    layout.dataSource = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[zhRemovableEditCollectionViewCell class] forCellWithReuseIdentifier:zhRemovableEditCellIdentify];
    [_collectionView registerClass:[zhRemovableEditCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:zhRemovableEditReusableHeaderIdentify];
}

#pragma mark - Getter / Setter

- (zhRemovableEditItemModel *)reserveModel {
    zhRemovableEditItemModel *reservezoneModel = [zhRemovableEditItemModel modelWithUniqueId:-2017];
    [reservezoneModel setValue:@(YES) forKey:@"zh_usingReservezone"];
    return reservezoneModel;
}

- (void)setShowReservezone:(BOOL)showReservezone {
    if (!showReservezone) return;
    _showReservezone = showReservezone;
    NSMutableArray<zhRemovableEditItemModel *> *firstDataArray = self.dataArray.firstObject.groupItems;
    [firstDataArray addObject:[self reserveModel]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.reLayout.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.reLayout.horizontalSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.reLayout.verticalSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (collectionView.bounds.size.width - self.reLayout.horizontalAllPadding) / self.reLayout.displayCount;
    return CGSizeMake(floor(itemWidth), floor(itemWidth) / self.reLayout.sizeScale);
}

// 组头的size须配合viewForSupplementaryElementOfKind一起设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, self.reLayout.sectionHeight);
}

#pragma mark - UICollectionViewDataSource

// 多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

// 每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].groupItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    zhRemovableEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zhRemovableEditCellIdentify forIndexPath:indexPath];
    cell.delegate = self;
    cell.images = self.reImages;
    cell.model = self.dataArray[indexPath.section].groupItems[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        zhRemovableEditCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:zhRemovableEditReusableHeaderIdentify forIndexPath:indexPath];
        reusableView.sectionModel = self.dataArray[indexPath.section];
        return reusableView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:246 / 255. green:246 / 255. blue:246 / 255. alpha:1];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self zh_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)zh_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - zhRemovableEditLayoutDelegate

//  某个 IndexPath 的cell 能否移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 != indexPath.section) return NO;
    
    if (indexPath.row < self.fixedCount) return NO;
    
    if (_showReservezone && !_zhIsMaxing) {
        if (indexPath.item == self.dataArray[indexPath.section].groupItems.count - 1) {
            return NO;
        }
    }
    return YES;
}

// 某个 IndexPath 能否移动过去
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return (0 == toIndexPath.section); // 只允许section0中可以拖动
}

// 将要开始拖动
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
}

// 拖动完成（需要调整数据源）
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    zhRemovableEditGroupModel *sectionModel = self.dataArray[fromIndexPath.section];
    zhRemovableEditItemModel *itemModel = sectionModel.groupItems[fromIndexPath.item];
    [sectionModel.groupItems removeObjectAtIndex:fromIndexPath.item];
    [sectionModel.groupItems insertObject:[itemModel copy] atIndex:toIndexPath.item];
}

#pragma mark - zhRemovableEditCollectionViewCellDelegate

- (void)zh_removableEditCollectionViewCellDidClickBadge:(zhRemovableEditCollectionViewCell *)cell {
    if (0 == [self.collectionView indexPathForCell:cell].section) {
        [self zh_deleteItemWithRemovableEditCollectionViewCell:cell];
    } else {
        [self zh_addItemWithRemovableEditCollectionViewCell:cell];
    }
}

- (void)zh_deleteItemWithRemovableEditCollectionViewCell:(zhRemovableEditCollectionViewCell *)cell {
    zhRemovableEditItemModel *currentModel = cell.model;
    NSMutableArray<zhRemovableEditItemModel *> *firstDataArray = self.dataArray.firstObject.groupItems;
    
    void (^cellUpdates)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            if (_showReservezone && _zhIsMaxing) {
                [firstDataArray addObject:[self reserveModel]];
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForItem:firstDataArray.count - 1 inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[insertIndexPath]];
                _zhIsMaxing = NO;
            }
        } completion:^(BOOL finished) {
            // TODO: 相同id会调用相应的的次数
            [self zh_removableEditCollectionViewCellWorkCompleted:cell];
        }];
    };
    
    void (^finishedTransform)(void) = ^() {
        [UIView animateWithDuration:0.25 animations:^{
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *currentIndexPath = [self.collectionView indexPathForCell:cell];
                [firstDataArray removeObjectAtIndex:currentIndexPath.row];
                [self.collectionView deleteItemsAtIndexPaths:@[currentIndexPath]];
            } completion:^(BOOL finished) {
                NSInteger numberOfSections = [self.collectionView numberOfSections];
                for (NSInteger section = 1; section < numberOfSections; section++) {
                    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
                    for (NSInteger index = 0; index < numberOfItems; index++) {
                        zhRemovableEditItemModel *originalModel = self.dataArray[section].groupItems[index];
                        if (originalModel.uniqueId == currentModel.uniqueId) {
                            originalModel.badgeState = zhRemovableEditBadgeStateAddible;
                            NSIndexPath *originalIndexPath = [NSIndexPath indexPathForItem:index inSection:section];
                            cellUpdates(originalIndexPath);
                        }
                    }
                }
            }];
        }];
    };
    
    if (self.useSpringAnimation) {
        [UIView animateWithDuration:0.25 animations:^{
            cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                cell.transform = CGAffineTransformMakeScale(0.1, 0.1);
                cell.alpha = 0;
            } completion:^(BOOL finished) {
                finishedTransform();
            }];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            cell.transform = CGAffineTransformMakeScale(0.1, 0.1);
            cell.alpha = 0;
        } completion:^(BOOL finished) {
            finishedTransform();
        }];
    }
}

- (void)zh_addItemWithRemovableEditCollectionViewCell:(zhRemovableEditCollectionViewCell *)cell {
    
    if (_zhIsMaxing) {
        [self zh_removableEditCollectionViewCellMoreThanMaxCount:cell];
        return;
    }
    
    NSMutableArray<zhRemovableEditItemModel *> *firstDataArray = self.dataArray.firstObject.groupItems;
    
    zhRemovableEditItemModel *currentModel = cell.model;
    zhRemovableEditItemModel *newItemModel = [currentModel copy];
    newItemModel.badgeState = zhRemovableEditBadgeStateDeletable;
    [newItemModel setValue:@(YES) forKey:@"zh_isInvisible"];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 1; section < numberOfSections; section++) {
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger index = 0; index < numberOfItems; index++) {
            zhRemovableEditItemModel *originalModel = self.dataArray[section].groupItems[index];
            if (originalModel.uniqueId == currentModel.uniqueId) {
                originalModel.badgeState = zhRemovableEditBadgeStateSelected;
                NSIndexPath *originalIndexPath = [NSIndexPath indexPathForItem:index inSection:section];
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[originalIndexPath]];
                } completion:NULL];
            }
        }
    }
    
    void (^cellAnimations)(NSIndexPath *, NSTimeInterval) = ^(NSIndexPath *indexPath, NSTimeInterval delay) {
        UICollectionViewCell *newCell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (newCell) {
            newCell.transform = CGAffineTransformMakeScale(0.f, 0.f);
            newCell.alpha = 0;
            newCell.hidden = NO;
            if (self.useSpringAnimation) {
                [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.55 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    newCell.transform = CGAffineTransformIdentity;
                    newCell.alpha = 1;
                } completion:^(BOOL finished) {
                    [newItemModel setValue:@(NO) forKey:@"zh_isInvisible"];
                    [self zh_removableEditCollectionViewCellWorkCompleted:cell];
                }];
            } else {
                [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                    newCell.transform = CGAffineTransformIdentity;
                    newCell.alpha = 1;
                } completion:^(BOOL finished) {
                    [newItemModel setValue:@(NO) forKey:@"zh_isInvisible"];
                    [self zh_removableEditCollectionViewCellWorkCompleted:cell];
                }];
            }
        }
    };
    
    if (_showReservezone) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:firstDataArray.count - 1 inSection:0];
        [firstDataArray insertObject:newItemModel atIndex:firstDataArray.count - 1];
        if (firstDataArray.count == self.maxCount + 1) {
            _zhIsMaxing = YES;
            [firstDataArray removeLastObject];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
            } completion:^(BOOL finished) {
                cellAnimations(newIndexPath, 0.05f);
            }];
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            } completion:^(BOOL finished) {
                cellAnimations(newIndexPath, 0.05f);
            }];
        }];
        
    } else {
        [firstDataArray addObject:newItemModel];
        if (firstDataArray.count == self.maxCount) {
            _zhIsMaxing = YES;
        }
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForItem:firstDataArray.count - 1 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[insertIndexPath]];
        cellAnimations(insertIndexPath ,0.0f);
    }
}

- (void)zh_removableEditCollectionViewCellMoreThanMaxCount:(zhRemovableEditCollectionViewCell *)cell {
    NSString *hudText = [NSString stringWithFormat:@"最多只能添加%lu个应用", (long)self.maxCount];
    [self showAlertHUDWithText:hudText];
}

- (void)zh_removableEditCollectionViewCellWorkCompleted:(zhRemovableEditCollectionViewCell *)cell {
}

#pragma mark - Alert HUD

- (void)showAlertHUDWithText:(NSString *)message {
    if (_zhIsHudShowing) return;
    _zhIsHudShowing = YES;
    if (!_zhAlertHud) {
        _zhAlertHud = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhAlertHud setBackgroundColor:[UIColor clearColor]];
        UIView *hudContainer = [UIView new];
        hudContainer.layer.cornerRadius = 5;
        hudContainer.clipsToBounds = YES;
        hudContainer.backgroundColor = [UIColor colorWithRed:62 / 255. green:62 / 255. blue:62 / 255. alpha:1];
        UILabel *hudLabel = [UILabel new];
        hudLabel.textAlignment = NSTextAlignmentCenter;
        hudLabel.text = message;
        hudLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(15)];
        hudLabel.textColor = [UIColor whiteColor];
        [hudContainer addSubview:hudLabel];
        [_zhAlertHud addSubview:hudContainer];
        CGSize maxSize = CGSizeMake(self.view.bounds.size.width, zh_sizeFitH(45));
        CGSize fitSize = [hudLabel sizeThatFits:maxSize];
        hudContainer.frame = CGRectMake(0, 0, fitSize.width + zh_sizeFitW(35), maxSize.height);
        hudContainer.center = CGPointMake(self.view.bounds.size.width / 2,
                                          self.view.bounds.size.height / 2);
        hudLabel.frame = hudContainer.bounds;
    }
    [self.view addSubview:_zhAlertHud];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAlertHUD];
    });
}

- (void)hideAlertHUD {
    if (_zhAlertHud) {
        [UIView animateWithDuration:0.25 animations:^{
            _zhAlertHud.alpha = 0;
        } completion:^(BOOL finished) {
            _zhAlertHud.alpha = 1;
            [_zhAlertHud removeFromSuperview];
            _zhIsHudShowing = NO;
        }];
    }
}

@end
