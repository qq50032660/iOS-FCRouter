//
//  FCRouterQueue.h
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FCRouterManager.h"

@interface FCRouterQueue : NSObject

+(instancetype)defaultManager;

//InitAfterViewControllerAlloc
-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller;

//只处理Arrary 和 Dictionary的情况
-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller params:(id)params;

-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block;

-(void)notifyQueue;

-(void)queuePopAllUrlscheme;

@end


