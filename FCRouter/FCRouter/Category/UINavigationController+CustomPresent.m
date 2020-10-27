//
//  UINavigationController+CustomPresent.m
//  FCRouter
//
//  Created by fc_curry on 2020/10/26.
//  Copyright © 2020 fc_curry. All rights reserved.
//

#import "UINavigationController+CustomPresent.h"

@implementation UINavigationController (CustomPresent)

-(void)fcPresentViewController:(UIViewController *)viewControllerToPresent
{
    [self fcPresentViewController:viewControllerToPresent animated:YES];
}

-(void)fcPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated
{
    if (viewControllerToPresent == nil) {
        return;
    }
    if (animated) {
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.view.layer addAnimation:transition forKey:kCATransition];
    }
    
    [self pushViewController:viewControllerToPresent animated:NO];
}

-(void)fcDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (flag) {
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [self.view.layer addAnimation:transition forKey:kCATransition];
    }
    
    [self popViewControllerAnimated:NO];
}

-(void)fcDismissViewController
{
    [self fcDismissViewControllerAnimated:YES completion:nil];
}

-(void)fcDismissToRootViewController
{
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self popToRootViewControllerAnimated:NO];
}

-(void)fcDismissToViewController:(UIViewController*)vc
{
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self popToViewController:vc animated:NO];
}
@end
