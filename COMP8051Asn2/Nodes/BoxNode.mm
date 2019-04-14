//
//  BoxNode.m
//  Tanks Go
//
//  Created by Renz on 3/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "BoxNode.h"
#import "Box.h"

@implementation BoxNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Box"
                               mass:1.0f
                             convex:YES
                                tag:kBoxTag
                             shader:shader
                           vertices:(Vertex *)Box_Cube_Box_Vertices
                        vertexCount:sizeof(Box_Cube_Box_Vertices)/sizeof(Box_Cube_Box_Vertices[0])
                        textureName:@"dungeon_01.png"
                     specularColour:Box_Cube_Box_specular
                      diffuseColour:Box_Cube_Box_diffuse
                          shininess:Box_Cube_Box_shininess])) {
        
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
    
    // If there is no delta value then don't bother updating
    if (aDelta == 0) return;
    
    // Increase the amount of rotation
    self.rotationY += M_PI_4 * aDelta;
    self.rotationZ+= M_PI_4 * aDelta;
    
    [super updateWithDelta:aDelta];
    
}

@end
