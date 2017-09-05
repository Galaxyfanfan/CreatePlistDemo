//
//  NSString+String.m
//  EasyGo
//
//  Created by Jammy on 16/4/19.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "NSString+String.h"
#import <CommonCrypto/CommonCrypto.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8 

@implementation NSString (String)

+ (NSString *)stringPinYinWithString:(NSString *)string{
    NSMutableString *pinyinText = [NSMutableString stringWithString:string];
    // 先转换为带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyinText, 0, kCFStringTransformMandarinLatin, NO);
    // 再转换为不带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyinText, 0, kCFStringTransformStripDiacritics, NO);
    // 转换为首字母大写拼音
    NSString *capitalPinyin = [pinyinText capitalizedString];
    NSString *newstr = [capitalPinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newstr;
}

@end
