#import "TopFace.h"

@implementation TopFace
const Vertex Vertices4[] = {
    // Top
    {{1, 1, 1},  {1,1,1,1}, {1, 0}, {0, 1, 0}}, 
    {{1, 1, -1},  {1,1,1,1}, {1, 1}, {0, 1, 0}},
    {{-1, 1, -1},  {1,1,1,1},  {0, 1}, {0, 1, 0}},
    
    {{-1, 1, -1},  {1,1,1,1},  {0, 1}, {0, 1, 0}}, 
    {{-1, 1, 1},  {1,1,1,1}, {0, 0}, {0, 1, 0}},
    {{1, 1, 1},  {1,1,1,1}, {1, 0}, {0, 1, 0}},
};

const GLubyte Indices4[] = {
    0, 1, 2,
    2, 3, 0
};
/*
- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"TopFace" shader:shader
                           vertices:(Vertex *)Vertices4
                        vertexCount:sizeof(Vertices4) / sizeof(Vertices4[0])
                                tag: 0])) {
        
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
        self.scale = 5;
        self.width = 5;
        //self.height = 5;
        
        [self loadTexture:@"floor.jpg"];
    }
    return self;
}
*/
- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"TopFace"
                               mass:0.0f
                             convex:YES
                                tag: 0
                             shader:shader
                           vertices:(Vertex *)Vertices4
                        vertexCount:sizeof(Vertices4) / sizeof(Vertices4[0])
                        textureName:@"floor.jpg"
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
