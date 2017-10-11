//
//  zhRemovableEditCollectionViewCell.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditCollectionViewCell.h"

@implementation zhRemovableEditSetImages

+ (instancetype)defaultImages {
    zhRemovableEditSetImages *images = [[zhRemovableEditSetImages alloc] init];
    images.reservezoneImage = [UIImage imageNamed:@"zh_REImaginarylineBox"];
    images.badgePlusImage = [UIImage imageNamed:@"zh_REBadgeAdd"];
    images.badgeMinusImage = [UIImage imageNamed:@"zh_REBadgeDelete"];
    images.badgeGrayImage = [UIImage imageNamed:@"zh_REBadgeDone"];
    return images;
}

@end

@implementation zhRemovableEditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(12.f)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = NO;
        [self.contentView addSubview:_imageView];
        
        _badgeImageView = [[UIImageView alloc] init];
        _badgeImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_badgeImageView];
        [_badgeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(badgeImageViewClicked)]];
        
        _reservezoneImageView = [[UIImageView alloc] init];
        _reservezoneImageView.backgroundColor = [UIColor whiteColor];
        _reservezoneImageView.userInteractionEnabled = NO;
        _reservezoneImageView.hidden = YES;
        [self.contentView addSubview:_reservezoneImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat centerX = self.contentView.bounds.size.width / 2;
    
    CGFloat imgTop = zh_sizeFitH(7);
    
    CGFloat imgSideLength = zh_sizeFitW(self.contentView.bounds.size.width / 2.5);
    _imageView.frame = CGRectMake(0, imgTop, imgSideLength, imgSideLength);
    _imageView.center = CGPointMake(centerX, _imageView.center.y);
    
    CGFloat titTop = CGRectGetMaxY(_imageView.frame) + zh_sizeFitH(5);
    CGFloat titBottomSpacing = zh_sizeFitH(5);
    CGFloat titWidth = self.contentView.bounds.size.width;
    CGFloat titHeight = self.contentView.bounds.size.height - titTop - titBottomSpacing;
    _titleLabel.frame = CGRectMake(0, titTop, titWidth, titHeight);
    _titleLabel.center = CGPointMake(centerX, _titleLabel.center.y);
    
    CGFloat sideLength = zh_sizeFitW(18);
    _badgeImageView.frame =  CGRectMake(0, 0, sideLength, sideLength);
    _badgeImageView.center = CGPointMake(self.contentView.bounds.size.width - sideLength / 2, sideLength / 2);
    
    _reservezoneImageView.frame = self.contentView.bounds;
}

- (void)badgeImageViewClicked {
    if (_model.badgeState == zhRemovableEditBadgeStateGray ||
        _model.badgeState == zhRemovableEditBadgeStateNone ||
        !_reservezoneImageView.hidden) return;
    if ([self.delegate respondsToSelector:@selector(zh_removableEditCollectionViewCellDidClickBadge:)]) {
        [self.delegate zh_removableEditCollectionViewCellDidClickBadge:self];
    }
}

- (void)setImages:(zhRemovableEditSetImages *)images {
    _images = images;
    _reservezoneImageView.image = images.reservezoneImage;
}

- (void)setModel:(zhRemovableEditItemModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    
    if (model.imageUrl) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]];
        _imageView.image = [UIImage imageWithData: imageData];
    } else {
        _imageView.image = model.image;
    }
    
    [self setBadgeImageByRemovableEditState:model.badgeState];
    
    [self setUsingReservezone:[[model valueForKey:@"zh_usingReservezone"] boolValue]];
    
    self.hidden = [[model valueForKey:@"zh_isInvisible"] boolValue];
}

- (void)setBadgeImageByRemovableEditState:(zhRemovableEditBadgeState)state {
    switch (state) {
        case zhRemovableEditBadgeStatePlus:
            _badgeImageView.image = _images.badgePlusImage;
            break;
        case zhRemovableEditBadgeStateMinus:
            _badgeImageView.image = _images.badgeMinusImage;
            break;
        case zhRemovableEditBadgeStateGray:
            _badgeImageView.image = _images.badgeGrayImage;
            break;
        case zhRemovableEditBadgeStateNone:
            _badgeImageView.image = nil;
            break;
        default: break;
    }
}

- (void)setUsingReservezone:(BOOL)usingReservezone {
    _titleLabel.hidden = usingReservezone;
    _imageView.hidden = usingReservezone;
    _badgeImageView.hidden = usingReservezone;
    _reservezoneImageView.hidden = !usingReservezone;
}

@end

@implementation zhRemovableEditCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(12.f)];
        _titleLabel.textColor = [UIColor blackColor];
        [_containerView addSubview:_titleLabel];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout {
    CGFloat paddingLeft = zh_sizeFitW(15);
    _containerView.frame = self.bounds;
    _titleLabel.frame = CGRectMake(paddingLeft, 0, _containerView.frame.size.width - paddingLeft, _containerView.frame.size.height);
}

- (void)setSectionModel:(zhRemovableEditSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    
    if (sectionModel.attributedTitle) {
        _titleLabel.attributedText = sectionModel.attributedTitle;
    } else {
        _titleLabel.text = sectionModel.title;
    }
}

@end
