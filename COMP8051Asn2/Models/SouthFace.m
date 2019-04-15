#import "SouthFace.h"

@implementation SouthFace

const Vertex Vertices3[] = {
    {{1, -1, -1},  {1,1,1,1}, {1, 0}, {1, 0, 0}},
    {{1, 1, -1},  {1,1,1,1}, {1, 1}, {1, 0, 0}},
    {{1, 1, 1},  {1,1,1,1}, {0, 1}, {1, 0, 0}},
    
    {{1, 1, 1},  {1,1,1,1}, {0, 1}, {1, 0, 0}},
    {{1, -1, 1},  {1,1,1,1}, {0, 0}, {1, 0, 0}},
    {{1, -1, -1},  {1,1,1,1}, {1, 0}, {1, 0, 0}}, 
};

const GLubyte Indices3[] = {
    0, 1, 2,
    2, 3, 0
};

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"SouthWall" shader:shader
                           vertices:(Vertex *)Vertices3
                        vertexCount:sizeof(Vertices3) / sizeof(Vertices3[0])
                                tag: 0])) {
        
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
        self.scale = 5;
        self.width = 5;
        self.height = 5;
        
        [self loadTexture:@"southwall.jpg"];
    }
    return self;
}

@end
