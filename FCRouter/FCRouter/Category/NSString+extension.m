//
//  NSString+extension.m
//  FCRouter
//
//  Created by fc_curry on 2019/8/5.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

+(NSString*)safeString:(NSString*)string
{
    if (string == nil) {
        return @"";
    }
    if (![string isKindOfClass:[NSString class]]) {
        return  @"";
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"null"] || [string isEqualToString:@"<null>"] || [string isKindOfClass:[NSNull class]]) {
            return @"";
        }
    }
    return string;
    
}

@end
