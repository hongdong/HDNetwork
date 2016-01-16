//
//  HDResponse.h
//  MGJRequestManagerDemo
//
//  Created by Abner on 16/1/14.
//  Copyright © 2016年 juangua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDResponse : NSObject
@property (nonatomic ,strong) NSError *error;
@property (nonatomic ,strong) id result;
@end
