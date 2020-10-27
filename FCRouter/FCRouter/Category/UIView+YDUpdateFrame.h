//
//  UIView+YDUpdateFrame.h
//  YunDaApp
//
//  Created by fc_curry on 2019/7/5.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define VIEW_BOTTEM(V)     V.getViewBottem
#define VIEW_LEFT(V)     V.getViewLeft
#define VIEW_RIGHT(V)    V.getViewRight
#define VIEW_TOP(V)     V.getViewTop


#define VIEW_WIDTH(V)  V.frame.size.width
#define VIEW_HEIGHT(V) V.frame.size.height

#define VB(V)     V.getViewBottem
#define VL(V)     V.getViewLeft
#define VR(V)    V.getViewRight
#define VT(V)     V.getViewTop
#define VW(V)  V.frame.size.width
#define VH(V) V.frame.size.height


typedef NS_ENUM(NSInteger, YDViewBoderEnum) {
    YDVIEWBORDER_LEFT=0x01,
    YDVIEWBORDER_RIGHT=0x02,
    YDVIEWBORDER_TOP=0x04,
    YDVIEWBORDER_BOTTEM=0x08,
    YDVIEWALL=0x0f,
    YDVIEWVERTICAL=0x01|0x02,
    YDVIEWHORIZONETAL=0x04|0x08,
} ;


@interface UIView (YDUpdateFrame)

-(CGFloat)getViewLeft;

-(CGFloat)getViewTop;

-(CGFloat)getViewRight;

-(CGFloat)getViewBottem;


-(void)fitToHorizontalCenterWithView:(UIView*)view;
-(void)fitToVerticalCenterWithView:(UIView*)view;
-(void)makeTopRightFrameWithPoint:(CGPoint)point width:(CGFloat)width height:(CGFloat)height;
-(void)modifyWidthToLeft:(CGFloat)width;
-(void)modifyWidthToRight:(CGFloat)width;
-(void)modifyWidth:(CGFloat)width;
-(void)modifyHeight:(CGFloat)height;
-(void)modifySize:(CGSize)size;
-(void)modifyOrigi:(CGPoint)point;
-(void)modifyX:(CGFloat)x;
-(void)modifyY:(CGFloat)y;
-(void)modifyRight:(CGFloat)right;
-(void)modifyBottem:(CGFloat)bottem;
-(void)modifyCenterX:(CGFloat)x;
-(void)modifyCenterY:(CGFloat)y;
-(void)setTheSameBottemWithView:(UIView*)view;

-(void)refreshBorderWithWidth:(CGFloat)width color:(UIColor*)color direction:(NSInteger)direction;

-(void)modifyCornerRadius:(CGFloat)cornerRadius;

-(void)modifyCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners;


-(void)removeAllSubView;
-(void)removeAllSubViewExcept:(NSArray*)exceptViews;

+ (UIView *)findKeyboard;

@end

NS_ASSUME_NONNULL_END
