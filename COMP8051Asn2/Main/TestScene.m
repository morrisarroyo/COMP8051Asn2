//
//  TestScene.m
//  Asn2
//
//  Created by Renz on 3/11/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import "TestScene.h"
#import "Cube.h"
#import "BaseEffect.h"

//#import "RWMushroom.h"
@implementation TestScene {
    //RWMushroom* _mushroom;
    CGSize _gameArea;
    float _sceneOffset;
    Cube *_cube;
}
- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"TestScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create initial scene position
        _gameArea = CGSizeMake(40, 80);
        _sceneOffset = _gameArea.height/2 / tanf(GLKMathRadiansToDegrees(85.0/2));
        
        self.position = GLKVector3Make(-_gameArea.width / 2, -_gameArea.height/2, -_sceneOffset);
        self.rotationX = GLKMathDegreesToRadians(15);
        
        _cube = [[Cube alloc] initWithShader:shader];
        _cube.position = GLKVector3Make(_gameArea.width / 2, _gameArea.height / 2, 0);
        //_cube.position = GLKVector3Make(0, 0, -100);
        [self.children addObject:_cube];
        
        //self.position = GLKVector3Make(0, -1, -10);
        
    }
    return self;
}
/*
- (instancetype)initWithShader:(GLKBaseEffect *)shader {
    if ((self = [super initWithName:"TestScene" shader:shader vertices:nil vertexCount:0])) {
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset - 10);
        
        //Create floor and add to scene
        _northWall = [[NorthWall alloc] initWithShader:shader];
        [self.children addObject:_northWall];
        
        //_mushroom = [[RWMushroom alloc] initWithShader:shader];
        //[self.children addObject:_mushroom];
        
        self.position = GLKVector3Make(0, -1, -10);
        
    }
    return self;
}*/

- (void)updateWithDelta:(GLfloat)aDelta {
    [super updateWithDelta:aDelta];
    //self.rotationY += GLKMathDegreesToRadians(15) * aDelta;
}

@end
