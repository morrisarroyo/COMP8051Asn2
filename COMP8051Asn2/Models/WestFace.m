//
//  WestFace.m
//  Asn2
//
//  Created by Renz on 3/12/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import "WestFace.h"

@implementation WestFace

const Vertex Vertices0[] = {
    {{1, -1, -1},  {1,1,1,1}, {1, 0}, {1, 0, 0}}, // 0
    {{1, 1, -1},  {1,1,1,1}, {1, 1}, {1, 0, 0}}, // 1
    {{1, 1, 1},  {1,1,1,1}, {0, 1}, {1, 0, 0}}, // 2
    
    {{1, 1, 1},  {1,1,1,1}, {0, 1}, {1, 0, 0}}, // 2
    {{1, -1, 1},  {1,1,1,1}, {0, 0}, {1, 0, 0}}, // 3
    {{1, -1, -1},  {1,1,1,1}, {1, 0}, {1, 0, 0}}, // 0
};

const GLubyte Indices0[] = {
    0, 1, 2,
    2, 3, 0
};

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"WestFace" shader:shader
                           vertices:(Vertex *)Vertices0
                        vertexCount:sizeof(Vertices0) / sizeof(Vertices0[0])])) {
        
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
        self.scale = 5;
        self.width = 5;
        self.height = 5;
        [self loadTexture:@"westwall.jpg"];
    }
    return self;
}

@end
