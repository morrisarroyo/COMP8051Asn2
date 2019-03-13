//
//  NorthWall.h
//  Asn2
//
//  Created by Renz on 3/11/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cube : Node

- (instancetype)initWithShader:
(BaseEffect *)shader;

@end

NS_ASSUME_NONNULL_END

