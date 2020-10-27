//
//  FCRouterManager.m
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "FCRouterManager.h"
#import "FCRouterAction.h"
#import "FCRouterQueue.h"

@implementation FCRouterManager

+(void)openURLString:(id)urlString fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block
{
    [[FCRouterQueue defaultManager] addASchemeWithUrl:urlString fromViewController:controller initAfterAlloc:block];
}

+(void)openURLString:(id)urlString fromViewController:(UIViewController *)controller
{
    [[FCRouterQueue defaultManager] addASchemeWithUrl:urlString fromViewController:controller];
}
+ (void)openURLString:(id)urlString fromViewController:(UIViewController *)controller params:(id)params{
    [[FCRouterQueue defaultManager] addASchemeWithUrl:urlString fromViewController:controller];

}
+(void)loadWithRootNavigationController:(UINavigationController *)navigationController schemeArray:(NSArray *)schemeArray privateUrlMappingDictionary:(NSDictionary *)privateUrlMappingDictionary publicUrlMappingDictionary:(NSDictionary *)publicUrlMappingDictionary
{
    [FCRouterAction loadWithRootNavigationController:navigationController schemeArray:schemeArray urlMappingDictionary:privateUrlMappingDictionary outsideUrlMappingDictionary:publicUrlMappingDictionary];
}

+(void)setTopLevelViewControllers:(NSArray *)topLevelVCs
{
    [FCRouterAction setTopLevelViewControllers:topLevelVCs];
}

+(void)setTopLevelViewControllers:(NSArray *)topLevelVCs exceptionViewControllers:(NSArray *)exceptionVCs
{
    [FCRouterAction setTopLevelViewControllers:topLevelVCs exceptionViewControllers:exceptionVCs];
}

+(void)notifyToUrlSchemeQueue
{
    [[FCRouterQueue defaultManager]notifyQueue];
}

+(void)addScheme:(NSString *)scheme
{
    [FCRouterAction addScheme:scheme];
}

+(void)addUrlMap:(NSDictionary *)urlMappingDictionary
{
    [FCRouterAction addUrlMap:urlMappingDictionary];
}

+(void)queuePopAllUrlscheme
{
    [[FCRouterQueue defaultManager]queuePopAllUrlscheme];
}

+(BOOL)canOpenOutSideWithUrlScheme:(NSString *)url
{
    return [FCRouterAction canOpenOutSideWithUrlScheme:url];
}

+(BOOL)canOpenUrlScheme:(NSString *)url
{
    return [FCRouterAction canOpenUrlScheme:url];
}

@end
