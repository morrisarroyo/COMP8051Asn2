#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Vertex.h"

@import GLKit;

@interface BaseEffect : NSObject

@property (nonatomic, assign) GLuint programHandle;
@property (nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
@property (assign) GLKTextureInfo* texture;
@property (assign) GLKVector4 matColour;
@property (assign) float dayNightFactor;
@property (assign) GLuint dayNightFactorUniform;
@property (assign) GLKVector2 viewportUniform;
@property (assign) bool flashlightActive;
@property (assign) GLKVector4 fogColour;
@property (assign) float fogStart;
@property (assign) float fogEnd;
@property (assign) bool fogActive;

- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;
- (void)prepareToDraw;

@end
