//
//  UIView+Tap.h
//  YunDaApp
//
//  Created by fc_curry on 2019/7/8.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YDWhenTappedBlock)(void);

@interface UIView (Tap)<UIGestureRecognizerDelegate>

//单击
- (void)whenTapped:(YDWhenTappedBlock)block;

//双击
- (void)whenDoubleTapped:(YDWhenTappedBlock)block;

//双指
- (void)whenTwoFingerTapped:(YDWhenTappedBlock)block;

//按下
- (void)whenTouchedDown:(YDWhenTappedBlock)block;

//弹起
- (void)whenTouchedUp:(YDWhenTappedBlock)block;

@end

NS_ASSUME_NONNULL_END
