#import <Foundation/Foundation.h>
#import "Vertex.h"
#import <GLKit/GLKit.h>

@class BaseEffect;

#define kBoxTag 1
#define kTankTag 1

@interface Node : NSObject

@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) GLKTextureInfo* texture;
@property (assign) GLKVector4 matColour;
@property (nonatomic, assign) GLKVector4 specularColor;
@property (nonatomic, assign) GLKVector4 diffuseColor;
@property (nonatomic, assign) float shininess;
@property (assign) float width;
@property (assign) float height;
@property (assign) float dayNightFactor;
@property (assign) bool flashlightActive;
@property (assign) bool fogActive;

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, assign) NSInteger tag;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount tag:(unsigned int)tag;
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount textureName:(NSString *)textureName specularColor:(GLKVector4)specularColor diffuseColor:(GLKVector4)diffuseColor shininess:(float)shininess tag:(unsigned int)tag;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix withDayNightFactor:(float)dayNightFactor withFlashlightActive:(bool)flashlightActive withFogActive:(bool)fogActive;
- (void)updateWithDelta:(GLfloat)dt;
- (void)loadTexture:(NSString *)fileName;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (CGRect) boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;

@end

