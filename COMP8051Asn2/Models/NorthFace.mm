#import "NorthFace.h"

@implementation NorthFace

const Vertex Vertices2[] = {
    {{-1, -1, 1},  {1,1,1,1}, {1, 0}, {-1, 0, 0}},
    {{-1, 1, 1},  {1,1,1,1}, {1, 1}, {-1, 0, 0}},
    {{-1, 1, -1},  {1,1,1,1}, {0, 1}, {-1, 0, 0}},
    
    {{-1, 1, -1},  {1,1,1,1}, {0, 1}, {-1, 0, 0}},
    {{-1, -1, -1},  {1,1,1,1}, {0, 0}, {-1, 0, 0}},
    {{-1, -1, 1},  {1,1,1,1}, {1, 0}, {-1, 0, 0}},
};

const GLubyte Indices2[] = {
    0, 1, 2,
    2, 3, 0
};

/*
- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"NorthFace" shader:shader
                           vertices:(Vertex *)Vertices2
                        vertexCount:sizeof(Vertices2) / sizeof(Vertices2[0])
                                tag: 0])) {
        
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
        self.scale = 5;
        self.width = 5;
        self.height = 5;
        
        [self loadTexture:@"northwall.jpg"];
    }
    return self;
}
*/

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"NorthFace"
                               mass:0.0f
                             convex:YES
                                tag: 0
                             shader:shader
                           vertices:(Vertex *)Vertices2
                        vertexCount:sizeof(Vertices2) / sizeof(Vertices2[0])
                        textureName:@"northwall.jpg"
                     specularColour:GLKVector4Make(1, 1, 1, 1)
                      diffuseColour:GLKVector4Make(1, 1, 1, 1)
                          shininess:10
                 ])) {
        /*
         self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
         self.specularColor = GLKVector4Make(1, 1, 1, 1);
         self.shininess = 10;
         */
        //self.scale = 5;
        //self.width = 5;
        //self.height = 5;
        //[self loadTexture:@"eastwall.jpg"];
    }
    return self;
}

@end
