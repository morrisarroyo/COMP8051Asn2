//
//  TankNode.m
//  COMP8051Asn2
//
//  Created by Renz on 4/17/19.
//  Copyright © 2019 BCIT. All rights reserved.
//

#import "TankNode.h"

@implementation TankNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Box"
                               mass:1.0f
                             convex:YES
                                tag:kTankTag
                             shader:shader
                           vertices:(Vertex *)Tank_Cube_Tank_Vertices
                        vertexCount:sizeof(Tank_Cube_Tank_Vertices)/sizeof(Tank_Cube_Tank_Vertices[0])
                        textureName:@"Tank1.png"
                     specularColour:Tank_Cube_Tank_specular
                      diffuseColour:Tank_Cube_Tank_diffuse
                          shininess:Tank_Cube_Tank_shininess])) {
        
    }
    return self;
}

@end
