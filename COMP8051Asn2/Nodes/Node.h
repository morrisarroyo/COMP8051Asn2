//
//  Node.h
//  Asn2
//
//  Created by Renz on 3/11/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "BaseEffect.h"
#import "Vertex.h"

@interface Node : NSObject

@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) GLuint texture;
@property (nonatomic, assign) GLKVector4 specularColor;
@property (nonatomic, assign) GLKVector4 diffuseColor;
@property (nonatomic, assign) float shininess;

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

- (instancetype)initWithName:(const char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (instancetype)initWithName:(const char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount textureName:(NSString *)textureName specularColor:(GLKVector4)specularColor diffuseColor:(GLKVector4)diffuseColor shininess:(float)shininess;

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (GLKMatrix4)modelMatrix;
- (void)updateWithDelta:(GLfloat)aDelta;
- (void)loadTexture:(NSString *)filename;
- (CGRect)boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;

@end
