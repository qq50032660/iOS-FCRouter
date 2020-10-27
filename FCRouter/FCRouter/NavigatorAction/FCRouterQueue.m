//
//  FCRouterQueue.m
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "FCRouterQueue.h"
#import "FCRouterAction.h"

@interface FCRouterQueue()
{
    NSMutableArray* _urlStringArray;
}
@end

static FCRouterQueue* _fcQueueSharedInstance = nil;

@implementation FCRouterQueue

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fcQueueSharedInstance = [[FCRouterQueue alloc] init];
    });
    
    return _fcQueueSharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _urlStringArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block
{
    NSString* relyingUrl = [FCRouterAction checkRelyingOnViewControllerWithUrl:url];
    if ((relyingUrl).length <= 0) {
        [FCRouterAction openURLString:url fromViewController:controller initAfterAlloc:block];
        return;
    }
    NSString *newUrl = url;
    if (newUrl.length > 6) {
        [_urlStringArray addObject:[url copy]];
        [self addASchemeWithUrl:relyingUrl fromViewController:nil];
    }
}

-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller
{
    if ([FCRouterAction isCurrentVcTopLevelWithFromViewController:controller url:url] == YES) {
        NSString *newUrl = url;
        if (newUrl.length > 6) {
            [_urlStringArray addObject:[url copy]];
        }
        return;
    }
    
    NSString* relyingUrl = [FCRouterAction checkRelyingOnViewControllerWithUrl:url];
    if (SAFE_STRING(relyingUrl).length <= 0) {
        [FCRouterAction openURLString:url fromViewController:controller];
        return;
    }
    
    if (SAFE_STRING(url).length > 6) {
        [_urlStringArray addObject:[url copy]];
        [self addASchemeWithUrl:relyingUrl fromViewController:nil];
    }
}
-(void)addASchemeWithUrl:(id)url fromViewController:(UIViewController *)controller params:(id)params{
    if ([FCRouterAction isCurrentVcTopLevelWithFromViewController:controller url:url] == YES) {
        NSString *newUrl = url;
        if (newUrl.length > 6) {
            [_urlStringArray addObject:[url copy]];
        }
        return;
    }
    
    NSString* relyingUrl = [FCRouterAction checkRelyingOnViewControllerWithUrl:url];
    if (SAFE_STRING(relyingUrl).length <= 0) {
        [FCRouterAction openURLString:url fromViewController:controller];
        return;
    }
    
    if (SAFE_STRING(url).length > 6) {
        [_urlStringArray addObject:[url copy]];
        [self addASchemeWithUrl:relyingUrl fromViewController:nil];
    }
}
-(void)notifyQueue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @synchronized(self){
            if (self->_urlStringArray.count > 0) {
                NSString* lastUrl = [self->_urlStringArray lastObject];
                [self->_urlStringArray removeLastObject];
                [FCRouterAction openURLString:lastUrl fromViewController:nil];
            }
        }
    });
}

-(void)queuePopAllUrlscheme
{
    if (_urlStringArray.count > 0) {
        [_urlStringArray removeAllObjects];
    }
}

-(NSArray*)checkRelyingViewContllerQueueWithUrl:(NSString*)url
{
    
    return nil;
}

@end
