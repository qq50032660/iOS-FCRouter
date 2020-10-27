//
//  UIView+YDUpdateFrame.m
//  YunDaApp
//
//  Created by fc_curry on 2019/7/5.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "UIView+YDUpdateFrame.h"

@implementation UIView (YDUpdateFrame)

+(void)modifyViewWidth:(CGFloat)width view:(UIView*)view
{
    if (view == nil) {
        return;
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        if (label.textAlignment == NSTextAlignmentRight) {
            view.frame = CGRectMake(CGRectGetMaxX(view.frame)-width, view.frame.origin.y, width, view.frame.size.height);
            return;
        } else if (label.textAlignment == NSTextAlignmentCenter) {
            CGFloat oriWidth = view.frame.size.width;
            CGPoint oriCenter = view.center;
            view.frame = CGRectMake(CGRectGetMidX(view.frame)-((width - oriWidth)/2.0f), view.frame.origin.y, width, view.frame.size.height);
            view.center = oriCenter;
            return;
        }
    }
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height);
}


+(void)modifyViewHeigth:(CGFloat)height view:(UIView*)view
{
    if (view == nil) {
        return;
    }
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

+(void)modifyViewOrigin:(CGPoint)point view:(UIView*)view
{
    if (view == nil) {
        return;
    }
    
    view.frame = CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height);
}

-(CGFloat)getViewLeft
{
    return self.frame.origin.x;
}

-(CGFloat)getViewTop
{
    return self.frame.origin.y;
}

-(CGFloat)getViewRight
{
    return (self.frame.origin.x + self.frame.size.width);
}

-(CGFloat)getViewBottem
{
    return (self.frame.origin.y + self.frame.size.height);
}


-(void)setTheSameBottemWithView:(UIView*)view
{
    self.frame = CGRectMake(self.frame.origin.x, VIEW_BOTTEM(view) - VIEW_HEIGHT(self), VIEW_WIDTH(self), VIEW_HEIGHT(self));
}

-(void)fitToVerticalCenterWithView:(UIView*)view
{
    self.frame = CGRectMake(self.frame.origin.x, (view.frame.size.height - self.frame.size.height)/2, self.frame.size.width, self.frame.size.height);
}

-(void)fitToHorizontalCenterWithView:(UIView*)view
{
    self.frame = CGRectMake((view.frame.size.width - self.frame.size.width)/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)makeTopRightFrameWithPoint:(CGPoint)point width:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(point.x - width, point.y, width, height);
}

-(void)modifyWidthToLeft:(CGFloat)width
{
    if (width <= 0) {
        width = 0;
    }
    
    CGFloat gap = self.frame.size.width - width;
    [self modifyWidth:width];
    [self modifyOrigi:CGPointMake(self.frame.origin.x - gap, self.frame.origin.y)];
}
-(void)modifyBottem:(CGFloat)bottem
{
    [self modifyY:bottem - self.frame.size.height];
}

-(void)modifyRight:(CGFloat)right
{
    [self modifyX:right - self.frame.size.width];
}

-(void)modifyWidth:(CGFloat)width
{
    if (width <= 0) {
        width = 0;
    }
    [UIView modifyViewWidth:width view:self];
}

-(void)modifySize:(CGSize)size
{
    [self modifyWidth:size.width];
    [self modifyHeight:size.height];
}

-(void)modifyWidthToRight:(CGFloat)width
{
    if (width <= 0) {
        width = 0;
    }
    [self modifyWidth:width];
}

-(void)modifyHeight:(CGFloat)height
{
    if (height <= 0) {
        height = 0;
    }
    [UIView modifyViewHeigth:height view:self];
}

-(void)modifyOrigi:(CGPoint)point
{
    [UIView modifyViewOrigin:point view:self];
}

-(void)modifyX:(CGFloat)x
{
    CGPoint point = self.frame.origin;
    point.x = x;
    [UIView modifyViewOrigin:point view:self];
}

-(void)modifyY:(CGFloat)y
{
    CGPoint point = self.frame.origin;
    point.y = y;
    [UIView modifyViewOrigin:point view:self];
}

-(void)modifyCenterX:(CGFloat)x
{
    self.frame = CGRectMake(x - (self.frame.size.width/2.0f), self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
}

-(void)modifyCenterY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y - (self.frame.size.height/2.0f), self.frame.size.width, self.frame.size.height);
}

-(void)refreshBorderWithWidth:(CGFloat)width color:(UIColor *)color direction:(NSInteger)direction
{
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, VIEW_WIDTH(self), width);
    TopBorder.backgroundColor = color.CGColor;
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, width, VIEW_HEIGHT(self));
    leftBorder.backgroundColor = color.CGColor;
    
    CALayer * rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(VIEW_WIDTH(self)-width, 0.0f, width, VIEW_HEIGHT(self));
    rightBorder.backgroundColor = color.CGColor;
    
    CALayer *bottemBorder = [CALayer layer];
    bottemBorder.frame = CGRectMake(0.0f, VIEW_HEIGHT(self)-width, VIEW_WIDTH(self), width);
    bottemBorder.backgroundColor = color.CGColor;
    
    if (direction & YDVIEWBORDER_TOP) {
        [self.layer addSublayer:TopBorder];
    }
    
    if (direction & YDVIEWBORDER_LEFT) {
        [self.layer addSublayer:leftBorder];
    }
    
    if (direction & YDVIEWBORDER_RIGHT) {
        [self.layer addSublayer:rightBorder];
    }
    
    if (direction & YDVIEWBORDER_BOTTEM) {
        [self.layer addSublayer:bottemBorder];
    }
    
}

-(void)modifyCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

-(void)modifyCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = bezier.CGPath;
    self.layer.mask = shape;
}


-(void)removeAllSubView
{
    NSArray *arraySubView = [NSArray arrayWithArray:self.subviews];
    for(UIView *subView in arraySubView)
    {
        [subView removeFromSuperview];
    }
}

-(void)removeAllSubViewExcept:(NSArray*)exceptViews
{
    NSArray *arraySubView = [NSArray arrayWithArray:self.subviews];
    for(UIView *subView in arraySubView)
    {
        if ([exceptViews containsObject:subView] == YES) {
            continue;
        }
        [subView removeFromSuperview];
    }
}

+ (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *Windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [Windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [UIView findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

@end
