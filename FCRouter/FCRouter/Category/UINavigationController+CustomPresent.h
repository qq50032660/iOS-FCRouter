//
//  UINavigationController+CustomPresent.h
//  FCRouter
//
//  Created by fc_curry on 2020/10/26.
//  Copyright © 2020 fc_curry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (CustomPresent)

/**
 *  用push的形式模拟present
 *
 *  @param viewControllerToPresent <#viewControllerToPresent description#>
 */
-(void)fcPresentViewController:(UIViewController *)viewControllerToPresent;

/**
 *  用push的形式模拟present, 为了方便写代码，添加了animated， 该参数无任何效果
 *
 *  @param viewControllerToPresent <#viewControllerToPresent description#>
 *  @param animated                <#animated description#>
 */
-(void)fcPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated;


-(void)fcDismissViewController;


-(void)fcDismissToRootViewController;

-(void)fcDismissToViewController:(UIViewController*)vc;


@end

NS_ASSUME_NONNULL_END
