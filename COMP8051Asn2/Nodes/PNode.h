//
//  PNode.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-22.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Node.h"
#include "btBulletDynamicsCommon.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNode : Node

- (instancetype)initWithName:(char *)name
                        mass:(float)mass
                      convex:(BOOL)convex
                         tag:(int)tag
                      shader:(BaseEffect *)shader
                    vertices:(Vertex *)vertices
                 vertexCount:(unsigned int)vertexCount
                 textureName:(NSString *)textureName
              specularColour:(GLKVector4)specularColour
               diffuseColour:(GLKVector4)diffuseColour
                   shininess:(float)shininess;

@property (nonatomic, readonly) btRigidBody* body;
@property (nonatomic, assign) int tag;

@end

NS_ASSUME_NONNULL_END
