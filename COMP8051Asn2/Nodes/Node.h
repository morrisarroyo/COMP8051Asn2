//
//  Model.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-12.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import <GLKit/GLKit.h>

@class BaseEffect;

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

@property (nonatomic, strong) NSMutableArray *children;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount textureName:(NSString *)textureName specularColor:(GLKVector4)specularColor diffuseColor:(GLKVector4)diffuseColor shininess:(float)shininess;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix withDayNightFactor:(float)dayNightFactor;
- (void)updateWithDelta:(GLfloat)dt;
- (void)loadTexture:(NSString *)fileName;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (CGRect) boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;

@end

