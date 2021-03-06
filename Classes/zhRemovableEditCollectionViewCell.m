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
    images.reservezoneImage = nil;
    images.badgeAddImage = nil;
    images.badgeDeleteImage = nil;
    images.badgeSelectedImage = nil;
    return images;
}

@end

@implementation zhRemovableEditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(12.f)];
        _titleLabel.textColor = [UIColor blackColor];
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
    if (_model.badgeState == zhRemovableEditBadgeStateSelected ||
        _model.badgeState == zhRemovableEditBadgeStateNormal ||
        !_reservezoneImageView.hidden) return;
    if ([self.delegate respondsToSelector:@selector(zh_removableEditCollectionViewCellDidClickBadge:)]) {
        [self.delegate zh_removableEditCollectionViewCellDidClickBadge:self];
    }
}

- (void)setImages:(zhRemovableEditSetImages *)images {
    _images = images;
    _reservezoneImageView.image = images.reservezoneImage;
}

- (void)setModel:(zhRemovableEditItemModel *)model withEditable:(BOOL)isEditable {
    _model = model;
    
    _titleLabel.text = model.title;
    
    model.iconUrl = [model.iconUrl stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    if (model.iconUrl.length) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.iconUrl]];
        _imageView.image = [UIImage imageWithData: imageData];
    } else if (model.iconName) {
        _imageView.image = [UIImage imageNamed:model.iconName];
    }
    
    [self setBadgeImageByRemovableEditState:model.badgeState];
    
    BOOL usingReservezone = [[model valueForKey:@"zh_makeReservezone"] boolValue];
    [self hideSubviewByUsingReservezone:usingReservezone andEditable:isEditable];

    self.hidden = [[model valueForKey:@"zh_beInvisible"] boolValue];
}

- (void)setBadgeImageByRemovableEditState:(zhRemovableEditBadgeState)state {
    switch (state) {
        case zhRemovableEditBadgeStateAddible:
            _badgeImageView.image = _images.badgeAddImage;
            break;
        case zhRemovableEditBadgeStateDeletable:
            _badgeImageView.image = _images.badgeDeleteImage;
            break;
        case zhRemovableEditBadgeStateSelected:
            _badgeImageView.image = _images.badgeSelectedImage;
            break;
        case zhRemovableEditBadgeStateNormal:
            _badgeImageView.image = nil;
            break;
        default: break;
    }
}

- (void)hideSubviewByUsingReservezone:(BOOL)usingReservezone andEditable:(BOOL)isEditable {
    _titleLabel.hidden = usingReservezone;
    _imageView.hidden = usingReservezone;
    if (isEditable) {
        _badgeImageView.hidden = usingReservezone;
        _reservezoneImageView.hidden = !usingReservezone;
    } else {
        _badgeImageView.hidden = YES;
        _reservezoneImageView.hidden = YES;
    }
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
        
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [UIColor colorWithRed:220 / 255. green:220 / 255. blue:220 / 255. alpha:1].CGColor;
        [_containerView.layer addSublayer:_lineLayer];
        
        _boxLayer = [CALayer layer];
        _boxLayer.backgroundColor = [UIColor colorWithRed:18 / 255. green:150 / 255. blue:219 / 255. alpha:1].CGColor;
        [_containerView.layer addSublayer:_boxLayer];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout {
    CGFloat paddingLeft = zh_sizeFitW(15);
    _containerView.frame = self.bounds;
    _lineLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 1 / [UIScreen mainScreen].scale);
    CGFloat boxH = zh_sizeFitH(12), boxY = (self.bounds.size.height - boxH) / 2;
    _boxLayer.frame = CGRectMake(paddingLeft, boxY, zh_sizeFitW(4), boxH);
    CGFloat titX = CGRectGetMaxX(_boxLayer.frame) + zh_sizeFitW(7);
    _titleLabel.frame = CGRectMake(titX, 0, _containerView.frame.size.width - paddingLeft, _containerView.frame.size.height);
}

- (void)setSectionModel:(zhRemovableEditGroupModel *)sectionModel {
    _sectionModel = sectionModel;
    if (sectionModel.attributedTitle) {
        _titleLabel.attributedText = sectionModel.attributedTitle;
    } else {
        _titleLabel.text = sectionModel.groupTitle;
    }
}

@end
