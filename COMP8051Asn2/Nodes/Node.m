#import "Node.h"
#import "BaseEffect.h"

@implementation Node {
    char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    BaseEffect *_shader;
    
}

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount tag:(unsigned int)tag {
    if ((self = [super init])) {
        _name  = name;
        _vertexCount = vertexCount;
        _shader = shader;
        _tag = tag;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.width = 1.0;
        self.height = 1.0;
        self.scale = 1.0;
        self.width = 1.0;
        self.height = 1.0;
        self.children = [NSMutableArray array];
        self.matColour = GLKVector4Make(1, 1, 1, 1);
        
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);
        
        //Generate vertex Buffer
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(Vertex), vertices, GL_STATIC_DRAW);
        
        //Enable vertex attributes
        glEnableVertexAttribArray(VertexAttribPosition);
        glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Position));
        
        glEnableVertexAttribArray(VertexAttribColour);
        glVertexAttribPointer(VertexAttribColour, 4, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Colour));
        
        glEnableVertexAttribArray(VertexAttribTexCoord);
        glVertexAttribPointer(VertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (const GLvoid *)offsetof(Vertex, TexCoord));
        
        glEnableVertexAttribArray(VertexAttribNormal);
        glVertexAttribPointer(VertexAttribNormal, 3, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (const GLvoid *)offsetof(Vertex, Normal));
        
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
    return self;
}

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount textureName:(NSString *)textureName specularColor:(GLKVector4)specularColor diffuseColor:(GLKVector4)diffuseColor shininess:(float)shininess tag:(int)tag {
    if ((self = [self initWithName:name shader:shader vertices:vertices vertexCount:vertexCount tag:tag])) {
        [self loadTexture:textureName];
        self.specularColor = specularColor;
        self.diffuseColor = diffuseColor;
        self.shininess = shininess;
    }
    return self;
}

- (GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1);
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.width, self.height, self.scale);
    return modelMatrix;
}

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix withDayNightFactor:(float)dayNightFactor withFlashlightActive:(bool)flashlightActive withFogActive:(bool)fogActive{
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    for (Node *child in self.children) {
        [child renderWithParentModelViewMatrix:modelViewMatrix withDayNightFactor:dayNightFactor withFlashlightActive:flashlightActive withFogActive:fogActive];
    }
    
    _shader.modelViewMatrix = modelViewMatrix;
    _shader.texture = self.texture;
    _shader.matColour = self.matColour;
    _shader.dayNightFactor = dayNightFactor;
    _shader.flashlightActive = flashlightActive;
    _shader.fogActive = fogActive;
    
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawArrays(GL_TRIANGLES, 0, _vertexCount);
    glBindVertexArrayOES(0);
    
}

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    for (Node *child in self.children) {
        [child renderWithParentModelViewMatrix:modelViewMatrix];
    }
    
    _shader.modelViewMatrix = modelViewMatrix;
    _shader.texture = self.texture;
    _shader.matColour = self.matColour;
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawArrays(GL_TRIANGLES, 0, _vertexCount);
    glBindVertexArrayOES(0);
    
}

- (void)loadTexture:(NSString *)fileName{
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    } else {
        self.texture = info;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)updateWithDelta:(GLfloat)dt {
    for (Node *child in self.children) {
        [child updateWithDelta:dt];
    }
}

- (CGRect) boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    GLKVector4 lowerLeft = GLKVector4Make(-self.width/2, -self.height/2, 0, 1);
    lowerLeft = GLKMatrix4MultiplyVector4(modelViewMatrix, lowerLeft);
    GLKVector4 upperRight = GLKVector4Make(self.width/2, self.height/2, 0, 1);
    upperRight = GLKMatrix4MultiplyVector4(modelViewMatrix, upperRight);
    CGRect boundingBox = CGRectMake(lowerLeft.x, lowerLeft.y, upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y);
    return boundingBox;
}

@end
