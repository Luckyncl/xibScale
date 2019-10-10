//
//  UIView+CLXibScale.m
//  XibScale
//
//  Created by luckyncl on 2018/3/27.
//  Copyright © 2018年 luckyncl. All rights reserved.
//

#import "UIView+CLXibScale.h"
#import <objc/runtime.h>


static char ByScaleKey;
static char XibScaleTypeKey ;
//static char ConstraintByScaleKey ;  // 是否已经发生约束改变   (废弃了)
static char ForceNoScaleKeyForView;
static char ForceNoScaleKeyForCons;   // 是否强制保持约束不改变



@implementation NSLayoutConstraint (CLXibScale)
-(void)setForceNoScale:(BOOL)forceNoScale
{
    objc_setAssociatedObject(self, &ForceNoScaleKeyForCons, @(forceNoScale), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)forceNoScale{
    return [objc_getAssociatedObject(self, &ForceNoScaleKeyForCons) boolValue];
}
@end


@implementation UIView (CLXibScale)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(CLAwakeFromNib);
        Method originalMethod = class_getInstanceMethod(UIView.class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        if (class_addMethod(UIView.class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            // 添加 并替换
            class_replaceMethod(UIView.class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            
            // 交换方法
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (void)CLAwakeFromNib{
    
    if (self.superview && self.superview.byScale) {
        self.byScale = self.superview.byScale;
        
        if (self.forceNoScale) {
            // 强制不跟新
        }else{
            [self updateConstraintsByScale];
        }
    }
    [self CLAwakeFromNib];
}






- (void)updateConstraintsByScale{
    float scale =  [UIScreen mainScreen].bounds.size.width /375.;
    switch ([self xibScaleType]) {
        case XibScale2x:
            scale =  [UIScreen mainScreen].bounds.size.width / 375.;
            break;
        case XibScale3x:
            scale =  [UIScreen mainScreen].bounds.size.width / 414.;
            break;
            
        default:
            break;
    }
    
    for (NSLayoutConstraint *indexConstraint in self.constraints) {
        [self constraintByScale:indexConstraint scale:scale];
    }
    
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *tempLabel =  (UILabel *)self;
        CGFloat tempFontSize = ((UILabel *)tempLabel).font.pointSize *scale;
        
        [tempLabel setFont:[UIFont fontWithName:tempLabel.font.fontName size:tempFontSize]];
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *tempBtn = (UIButton *)self;
        UILabel *tempLabel =  tempBtn.titleLabel;
        CGFloat tempFontSize = tempLabel.font.pointSize *scale;
        [tempLabel setFont:[UIFont fontWithName:tempLabel.font.fontName size:tempFontSize]];
    }
    if ([self isKindOfClass:[UITextView class]]) {
        UITextView *tempTextView = (UITextView *)self;
        CGFloat tempFontSize = tempTextView.font.pointSize *scale;
        [tempTextView setFont:[UIFont fontWithName:tempTextView.font.fontName size:tempFontSize]];
    }
}


- (void)constraintByScale:(NSLayoutConstraint *) indexConstraint scale:(float)scale{
    if ([objc_getAssociatedObject(indexConstraint, &ForceNoScaleKeyForCons) boolValue]) {
       return;
    }
    objc_setAssociatedObject(indexConstraint, &ForceNoScaleKeyForCons, @1, OBJC_ASSOCIATION_ASSIGN);

    indexConstraint.constant = indexConstraint.constant * scale;
}

- (void)setXibScaleType:(NSInteger)xibScaleType{
    objc_setAssociatedObject(self, &XibScaleTypeKey, @(xibScaleType), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)xibScaleType{
    return [objc_getAssociatedObject(self, &XibScaleTypeKey) integerValue];
}

- (void)setByScale:(BOOL)byScale
{
    objc_setAssociatedObject(self, &ByScaleKey, @(byScale), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)byScale{
    return [objc_getAssociatedObject(self, &ByScaleKey) boolValue];
}

-(void)setForceNoScale:(BOOL)forceNoScale
{
    objc_setAssociatedObject(self, &ForceNoScaleKeyForView, @(forceNoScale), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)forceNoScale{
    return [objc_getAssociatedObject(self, &ForceNoScaleKeyForView) boolValue];
}


@end
