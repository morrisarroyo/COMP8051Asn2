#import "EastFace.h"

@implementation EastFace

const Vertex Vertices1[] = {
    {{-1, -1, -1},  {1,1,1,1}, {1, 0}, {0, 0, -1}},
    {{-1, 1, -1},  {1,1,1,1}, {1, 1}, {0, 0, -1}},
    {{1, 1, -1},  {1,1,1,1}, {0, 1}, {0, 0, -1}},
    
    {{1, 1, -1},  {1,1,1,1}, {0, 1}, {0, 0, -1}},
    {{1, -1, -1},  {1,1,1,1}, {0, 0}, {0, 0, -1}},
    {{-1, -1, -1},  {1,1,1,1}, {1, 0}, {0, 0, -1}},
};

const GLubyte Indices1[] = {
    0, 1, 2,
    2, 3, 0
};

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"EastWall"
                               mass:1.0f
                             convex:YES
                                tag: 0
                             shader:shader
                           vertices:(Vertex *)Vertices1
                        vertexCount:sizeof(Vertices1) / sizeof(Vertices1[0])
                        textureName:@"eastwall.jpg"
                     specularColour:GLKVector4Make(1, 1, 1, 1)
                      diffuseColour:GLKVector4Make(1, 1, 1, 1)
                          shininess:10
                                ])) {
        /*
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.shininess = 10;
         */
        self.scale = 5;
        self.width = 5;
        self.height = 5;
        //[self loadTexture:@"eastwall.jpg"];
    }
    return self;
}

@end