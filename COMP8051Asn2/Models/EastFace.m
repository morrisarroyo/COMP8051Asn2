//
//  EastFace.m
//  Asn2
//
//  Created by Renz on 3/12/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import "EastFace.h"

@implementation EastFace

const Vertex Vertices1[] = {
    {{-1, -1, 1}, {1, 0}, {-1, 0, 0}}, // 0
    {{-1, 1, 1}, {1, 1}, {-1, 0, 0}}, // 1
    {{-1, 1, -1}, {0, 1}, {-1, 0, 0}}, // 2
    
    {{-1, 1, -1}, {0, 1}, {-1, 0, 0}}, // 2
    {{-1, -1, -1}, {0, 0}, {-1, 0, 0}}, // 3
    {{-1, -1, 1}, {1, 0}, {-1, 0, 0}}, // 0
};

const GLubyte Indices1[] = {
    0, 1, 2,
    2, 3, 0
};

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"EastWall" shader:shader
                           vertices:(Vertex *)Vertices1
                        vertexCount:sizeof(Vertices1) / sizeof(Vertices1[0])])) {
        
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
        self.scale = 5;
        
        [self loadTexture:@"dungeon_01.png"];
    }
    return self;
}

@end
