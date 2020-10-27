//
//  AppDelegate+Route.m
//  FCRouter
//
//  Created by fc_curry on 2020/10/26.
//  Copyright © 2020 fc_curry. All rights reserved.
//

#import "AppDelegate+Route.h"
#import "FCRouterManager.h"
@implementation AppDelegate (Route)

- (void)configureRoute{
//    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"Route" ofType:@"plist"];
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSLog(@" == %@",dictionary);
//    NSDictionary *route = dictionary[@"Route"];
//    NSLog(@"===%@",route[@"Private"]);
    
    NSDictionary* privatMap = @{@"one":@"OneViewController",
                                @"two":@"TwoViewController",
                                @"three":@"ThreeViewController",
                                @"onedetail":@"OneDetailViewController",
                                @"twodetail":@"TwoDetailViewController",
                                };
    
    
    [FCRouterManager loadWithRootNavigationController:ROOT_NAVIGATION_CONTROLLER schemeArray:@[@"fc"] privateUrlMappingDictionary:privatMap publicUrlMappingDictionary:nil];
}

@end
