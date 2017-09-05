//
//  ViewController.m
//  CreatePlistDemo
//
//  Created by galaxy on 2017/8/29.
//  Copyright © 2017年 galaxy. All rights reserved.
//

#import "ViewController.h"
#import "NSString+String.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *proArr = [dic allKeys];
    NSMutableArray *bigCityMuArr = [[NSMutableArray alloc]init];
    NSMutableArray *allCityMuArr = [[NSMutableArray alloc]init];


    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathstr = [paths objectAtIndex:0];
    NSString *plistPath = [pathstr stringByAppendingPathComponent:@"addressCity.plist"];   //获取路径

    for (int i = 0; i < proArr.count; i++) {
        NSArray *cityArr = [dic objectForKey:[proArr objectAtIndex:i]];

        for (int j = 0; j < cityArr.count; j++) {
            NSDictionary *cityDic = cityArr[j];
//            DLog(@"cityDic:%@",cityDic);
            NSArray *citysKey = [cityDic allKeys];
            [bigCityMuArr addObjectsFromArray:citysKey];

//            DLog(@"citysKey:%@",citysKey);
            for (NSString *cityKey in citysKey) {
                NSMutableDictionary *bigcityDic = [[NSMutableDictionary alloc]init];
                bigcityDic[@"city"] = cityKey;
                bigcityDic[@"area"] = cityKey;
                NSString *pinyinbig = [NSString stringPinYinWithString:cityKey];
                bigcityDic[@"pinyin"]= pinyinbig;
                bigcityDic[@"initials"] = [pinyinbig substringToIndex:1];
                //添加到数组中
                [allCityMuArr addObject:bigcityDic];

                NSArray *townArray = [cityDic objectForKey:cityKey];
//                DLog(@"townArray:%@",townArray);
                for (NSString *town in townArray) {
                    if (![town containsString:@"区"]) {
                        if (town.length > 0) {
                            NSMutableDictionary *townDic = [[NSMutableDictionary alloc]init];
                            townDic[@"city"] = cityKey;
                            townDic[@"area"] = town;
                            NSString *pinyin = [NSString stringPinYinWithString:town];
                            townDic[@"pinyin"]= pinyin;
                            townDic[@"initials"] = [pinyin substringToIndex:1];
                            //添加到数组中
                            [allCityMuArr addObject:townDic];
                        }
                    }
                }
            }
        }
    }
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    BOOL isadd = NO;
    for (NSDictionary *dic in allCityMuArr) {
        NSString *initials = [dic objectForKey:@"initials"];

        for (int i = 0; i < muArr.count ; i++){
            NSDictionary *subDic = muArr[i];
            NSString *pinyin = [subDic objectForKey:@"initials"];
            if ([pinyin isEqualToString:initials]) {
                //包含 添加
                NSMutableArray *arr = [subDic objectForKey:@"citys"];
                [arr addObject:dic];
                [subDic setValue:arr forKey:@"citys"];
                [muArr replaceObjectAtIndex:i withObject:subDic];
                isadd = YES;
                break;
            }
        }

        if (isadd) {
            isadd = NO;

        }else{
            //不包含 创建
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            dic1[@"initials"] = initials;
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            [arr addObject:dic];
            dic1[@"citys"] = arr;
            [muArr addObject:dic1];
        }
        
    }

    
    //写入文件
    [muArr writeToFile:plistPath atomically:YES];
    
    NSLog(@"%@",plistPath);
    //找到生成的plist文件
    //复制打印出来的plistPath，点击finder->前往文件夹->将里面的plist文件复制出来就可以啦

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
