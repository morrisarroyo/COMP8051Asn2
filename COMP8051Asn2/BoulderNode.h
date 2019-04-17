//
//  BoulderNode.h
//  COMP8051Asn2
//
//  Created by Renz on 4/17/19.
//  Copyright © 2019 BCIT. All rights reserved.
//

#import "PNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoulderNode : PNode

- (instancetype)initWithShader:(BaseEffect *)shader;

@end

NS_ASSUME_NONNULL_END
