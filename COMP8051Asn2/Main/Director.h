//
//  Director.h
//  Asn2
//
//  Created by Renz on 3/12/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Node;

@interface Director : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) Node *scene;

@end
