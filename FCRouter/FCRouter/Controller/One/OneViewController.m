//
//  OneViewController.m
//  FCRouter
//
//  Created by fc_curry on 2020/10/26.
//  Copyright © 2020 fc_curry. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)jumpToNextEvent:(id)sender {
    NSDictionary *personDic = @{
        @"name":@"fc_curry",
        @"age":@"27",
        @"gender":@"man",
        @"likes":@"cook",
        @"weight":@"160",
        @"uziinstro":@"简自豪，网络ID：Uzi，1997年4月5日出生于湖北省宜昌市，曾是游戏《英雄联盟》中国区的电竞职业选手，原SH皇族电子竞技俱乐部ADC选手，RNG战队ADC [1]。2013年Uzi第一次进入全球总决赛，在预选赛上使用暗夜猎手一战封神，却在决赛惜败SKT获得S3英雄联盟世界总决赛亚军 [2]  。2014年再次进入S系列比赛获得S4英雄联盟世界总决赛亚军 [3]  。2015年S5赛季初加入OMG [4]  无缘世界总决赛。春季赛结束后，在2016年夏季转会期时转会到RNG [5]  ，2017年全明星宣传片：Uzi为LPL代表人物 [6]  ，2018年获得MSI季中赛冠军。2018年6月，入选2018雅加达-巨港亚运会英雄联盟电子体育表演项目中国代表队。 [7-8]  2018年8月29日，雅加达亚运会电竞表演项目《英雄联盟》总决赛，由简自豪等人组成的中国团队3-1战胜劲敌韩国团队夺得金牌。 [9]2020年6月3日，简自豪宣布正式退役。 [10]  随后，英雄联盟官方发文回顾了简自豪的职业生涯。",
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:personDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
        
    if (!jsonData) {
            NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
            NSString *routeString = [NSString stringWithFormat:@"fc://oneDetail?json=%@",jsonString];
    [FCRouterManager openURLString:routeString fromViewController:nil];
//    FCOpenUrl(@"fc://oneDetail");
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
