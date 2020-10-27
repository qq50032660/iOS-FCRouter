//
//  NSString+extension.h
//  FCRouter
//
//  Created by fc_curry on 2019/8/5.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (extension)

#define SAFE_STRING(S) [NSString safeString:S]
+(NSString*)safeString:(NSString*)string;

@end


