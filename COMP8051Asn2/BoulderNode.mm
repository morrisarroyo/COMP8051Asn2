//
//  BoulderNode.m
//  COMP8051Asn2
//
//  Created by Renz on 4/17/19.
//  Copyright © 2019 BCIT. All rights reserved.
//

#import "BoulderNode.h"
#import "Boulder.h"

@implementation BoulderNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Boulder"
                               mass:1.0f
                             convex:YES
                                tag:kBoulderTag
                             shader:shader
                           vertices:(Vertex *)Boulder_Icosphere_Boulder_Vertices
                        vertexCount:sizeof(Boulder_Icosphere_Boulder_Vertices)/sizeof(Boulder_Icosphere_Boulder_Vertices[0])
                        textureName:@"Boulder.jpg"
                     specularColour:Boulder_Icosphere_Boulder_specular
                      diffuseColour:Boulder_Icosphere_Boulder_diffuse
                          shininess:Boulder_Icosphere_Boulder_shininess])) {
        
    }
    return self;
}

@end
