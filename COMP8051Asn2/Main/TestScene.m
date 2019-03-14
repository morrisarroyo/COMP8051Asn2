//
//  TestScene.m
//  Asn2
//
//  Created by Renz on 3/11/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import "TestScene.h"
#import "Cube.h"
#import "MazeCaller.h"
#import "NorthFace.h"
#import "EastFace.h"
#import "SouthFace.h"
#import "WestFace.h"
#import "TopFace.h"
//#import "RWMushroom.h"
@implementation TestScene {
    //RWMushroom* _mushroom;
    CGSize _gameArea;
    float _sceneOffset;
    Cube *_cube;
    NorthFace *_north;
    EastFace *_east;
    SouthFace *_south;
    WestFace *_west;
    TopFace *_floor;
    MazeCaller *maze;
    Cell cell;
}
- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"TestScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create initial scene position
        _gameArea = CGSizeMake(40, 80);
        _sceneOffset = _gameArea.height/2 / tanf(GLKMathRadiansToDegrees(85.0/2));
        self.position = GLKVector3Make(-_gameArea.width / 2, -_gameArea.height/2, -_sceneOffset);
        //self.rotationX = GLKMathDegreesToRadians(15);
        
        _cube = [[Cube alloc] initWithShader:shader];
        _cube.position = GLKVector3Make(_gameArea.width / 2, _gameArea.height / 2, 0);
        [self.children addObject:_cube];
        
        _cube = [[Cube alloc] initWithShader:shader];
        _cube.position = GLKVector3Make(_gameArea.width / 2, _gameArea.height / 2, -3);
        _cube.scale = 5;
        [self.children addObject:_cube];
        
        /*
        _floor = [[TopFace alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(0, _gameArea.height / 2 - 4, 0);
        _floor = [[TopFace alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(5, _gameArea.height / 2 - 4, 5);
         */
        _floor = [[TopFace alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(((_gameArea.width / 2) + 0 * _floor.scale), _gameArea.height / 2 - 4, (0 * _floor.scale));
        [self.children addObject:_floor];
        /*
        maze = [[MazeCaller alloc] init];
        for (int i = 0; i < [maze getNumRows]; i++) {
            for (int j = 0; j < [maze getNumCols]; j++) {
                _floor = [[TopFace alloc] initWithShader:shader];
                _floor.position = GLKVector3Make(((_gameArea.width / 2) + i * _floor.scale), _gameArea.height / 2 - 4, (j * _floor.scale));
                [self.children addObject:_floor];
            }
        }
        */
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
