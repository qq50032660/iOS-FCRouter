//
//  OneDetailViewController.m
//  FCRouter
//
//  Created by fc_curry on 2020/10/26.
//  Copyright © 2020 fc_curry. All rights reserved.
//

#import "OneDetailViewController.h"

@interface OneDetailViewController ()

@end

@implementation OneDetailViewController
//路由跳转的参数
- (BOOL)handleWillOpenUrlWithParams:(NSDictionary*)params
{
    NSData *data = [params[@"json"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    return YES;
}
+ (BOOL)shouldPresent
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
