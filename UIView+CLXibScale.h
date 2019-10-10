//
//  UIView+CLXibScale.h
//  XibScale
//
//  Created by luckyncl on 2018/3/27.
//  Copyright © 2018年 luckyncl. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XibScaleType) {
    /* 375 * 667pt 750 *1334 px */
    XibScale2x,
    
    /* 414 *736pt 1242 * 2206 px */
    XibScale3x,
};





@interface NSLayoutConstraint (CLXibScale)


/**
    强制保持原来的比例 默认是no
 */
@property (nonatomic, assign)IBInspectable BOOL forceNoScale ;


@end





/**
    注意这里一般都是针对于 最底部的包含各种view的containView来讲的，
 */
@interface UIView (CLXibScale)

/**
    是按2x图类型布局的 默认是
 */
@property (nonatomic, assign)IBInspectable NSInteger xibScaleType;

/**
    默认是不使用比例布局 默认为NO
 */
@property (nonatomic, assign)IBInspectable BOOL byScale ;  // 是否按比例布局

/*
    是否强制保持一个view约束不按比例来变化 优先级高 （默认为NO）
 */
@property (nonatomic, assign)IBInspectable BOOL forceNoScale ;


/*
   按比例更新 约束
 */
- (void)updateConstraintsByScale;


@end
