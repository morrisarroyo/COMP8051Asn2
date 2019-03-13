//
//  BaseEffect.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 9/3/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "BaseEffect.h"

@implementation BaseEffect {
    GLuint _programHandle;
    GLuint _modelViewMatrixUniform;
    GLuint _projectionMatrixUniform;
    GLuint _texUniform;
    GLuint _lightColourUniform;
    GLuint _lightAmbientIntensityUniform;
    GLuint _lightDiffuseIntensityUniform;
    GLuint _lightDirectionUniform;
    GLuint _matSpecularIntensityUniform;
    GLuint _shininessUniform;
    GLuint _matColourUniform;
    GLuint _flashlightPositionUniform;
    GLuint _flashlightDirectionUniform;
    GLuint _flashlightCutoffUniform;
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
  NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:nil];
  NSError* error;
  NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
  if (!shaderString) {
    NSLog(@"Error loading shader: %@", error.localizedDescription);
    exit(1);
  }
  
  GLuint shaderHandle = glCreateShader(shaderType);
  
  const char * shaderStringUTF8 = [shaderString UTF8String];
  int shaderStringLength = [shaderString length];
  glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
  
  glCompileShader(shaderHandle);
  
  GLint compileSuccess;
  glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
  
  return shaderHandle;
}

- (void)compileVertexShader:(NSString *)vertexShader
             fragmentShader:(NSString *)fragmentShader {
  GLuint vertexShaderName = [self compileShader:vertexShader
                                       withType:GL_VERTEX_SHADER];
  GLuint fragmentShaderName = [self compileShader:fragmentShader
                                         withType:GL_FRAGMENT_SHADER];
  
  _programHandle = glCreateProgram();
  glAttachShader(_programHandle, vertexShaderName);
  glAttachShader(_programHandle, fragmentShaderName);
  
  glBindAttribLocation(_programHandle, VertexAttribPosition, "a_Position");
  glBindAttribLocation(_programHandle, VertexAttribColour, "a_Colour");
  glBindAttribLocation(_programHandle, VertexAttribTexCoord, "a_TexCoord");
    glBindAttribLocation(_programHandle, VertexAttribNormal, "a_Normal");
  
  glLinkProgram(_programHandle);
    
  self.modelViewMatrix = GLKMatrix4Identity;
  _modelViewMatrixUniform = glGetUniformLocation(_programHandle, "u_ModelViewMatrix");
  _projectionMatrixUniform = glGetUniformLocation(_programHandle, "u_ProjectionMatrix");
  _texUniform = glGetUniformLocation(_programHandle, "u_Texture");
  _lightColourUniform = glGetUniformLocation(_programHandle, "u_Light.Colour");
  _lightAmbientIntensityUniform = glGetUniformLocation(_programHandle, "u_Light.AmbientIntensity");
  _lightDiffuseIntensityUniform = glGetUniformLocation(_programHandle, "u_Light.DiffuseIntensity");
  _lightDirectionUniform = glGetUniformLocation(_programHandle, "u_Light.Direction");
  _matSpecularIntensityUniform = glGetUniformLocation(_programHandle, "u_MatSpecularIntensity");
  _shininessUniform = glGetUniformLocation(_programHandle, "u_Shininess");
  _matColourUniform = glGetUniformLocation(_programHandle, "u_MatColour");
    _dayNightFactorUniform = glGetUniformLocation(_programHandle, "u_DayNightFactor");
    _flashlightPositionUniform = glGetUniformLocation(_programHandle, "u_Flashlight.Position");
    _flashlightDirectionUniform = glGetUniformLocation(_programHandle, "u_Flashlight.Direction");
    _flashlightCutoffUniform = glGetUniformLocation(_programHandle, "u_Flashlight.Cutoff");
  GLint linkSuccess;
  glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
}

- (void)prepareToDraw {
  glUseProgram(_programHandle);
  glUniformMatrix4fv(_modelViewMatrixUniform, 1, 0, self.modelViewMatrix.m);
  glUniformMatrix4fv(_projectionMatrixUniform, 1, 0, self.projectionMatrix.m);

  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, self.texture.name);
  glUniform1i(_texUniform, 1);
  
  glUniform3f(_lightColourUniform, 1, 1, 1);
  glUniform1f(_lightAmbientIntensityUniform, .25);
  GLKVector3 lightDirection = GLKVector3Normalize(GLKVector3Make(0, 1, -1));
  glUniform3f(_lightDirectionUniform, lightDirection.x, lightDirection.y, lightDirection.z);
  glUniform1f(_lightDiffuseIntensityUniform, 1.0);
  glUniform1f(_matSpecularIntensityUniform, .7);
  glUniform1f(_shininessUniform, 64.0);
    glUniform4f(_matColourUniform, self.matColour.r, self.matColour.g, self.matColour.b, self.matColour.a);
    glUniform1f(_dayNightFactorUniform, _dayNightFactor);
    glUniform3f(_flashlightPositionUniform, _flashlightPosition.x, _flashlightPosition.y, _flashlightPosition.z);
    glUniform3f(_flashlightDirectionUniform, _flashlightDirection.x, _flashlightDirection.y, _flashlightDirection.z);

    //glUniform3f(_flashlightPositionUniform, self.modelViewMatrix.m30, self.modelViewMatrix.m31, self.modelViewMatrix.m32);
    //glUniform3f(_flashlightDirectionUniform, self.modelViewMatrix.m20, self.modelViewMatrix.m21, self.modelViewMatrix.m22);
    glUniform1f(_flashlightCutoffUniform, cosf(GLKMathDegreesToRadians(5.0f)) * 12);
    
    NSLog(@"%f %f %f %f  %f %f %f", cosf(GLKMathDegreesToRadians(15.0f)), _flashlightPosition.x, _flashlightPosition.y, _flashlightPosition.z, _flashlightDirection.x, _flashlightDirection.y, _flashlightDirection.z);
}

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:
(NSString *)fragmentShader {
  if ((self = [super init])) {
    [self compileVertexShader:vertexShader fragmentShader:fragmentShader];
  }
  return self;
}

@end
