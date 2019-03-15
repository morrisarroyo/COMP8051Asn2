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
    NSString *map;
    NSArray *mapArray;
    Cell cell;
    int mazeScale;
    
    
}



- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"TestScene" shader:shader vertices:nil vertexCount:0])) {
        // Create initial scene position
        _gameArea = CGSizeMake(40, 80);
        _sceneOffset = _gameArea.height/2 / tanf(GLKMathRadiansToDegrees(85.0/2));
        self.position = GLKVector3Make(-_gameArea.width / 2, -_gameArea.height/2, -_sceneOffset);
        //self.rotationX = GLKMathDegreesToRadians(15);
        self.rotationY = GLKMathDegreesToRadians(90);
        
        _cube = [[Cube alloc] initWithShader:shader];
        _cube.position = GLKVector3Make(_gameArea.width / 2, _gameArea.height / 2, 0);
        [self.children addObject:_cube];
        map = @"\n";
        mazeScale = 5;
        maze = [[MazeCaller alloc] init];
        for (int i = 0; i < [maze getNumRows]; i++) {
            for (int j = 0; j < [maze getNumCols]; j++) {
                _floor = [[TopFace alloc] initWithShader:shader];
                _floor.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2 - 6, (j * mazeScale * 2));
                [self.children addObject:_floor];
                
                cell = [maze getCelli:i j:j];
                if (cell.northWallPresent) {
                    _north = [[NorthFace alloc] initWithShader:shader];
                    _north.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_north];
                    _south = [[SouthFace alloc] initWithShader:shader];
                    _south.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2) - (mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_south];
                    map = [map stringByAppendingFormat:@"%@", @("n")];
                } else {
                    map = [map stringByAppendingFormat:@"%@", @("x")];
                }
                if (cell.southWallPresent) {
                    _south = [[SouthFace alloc] initWithShader:shader];
                    _south.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_south];
                    _north = [[NorthFace alloc] initWithShader:shader];
                    _north.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2) + (mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_north];
                    map = [map stringByAppendingFormat:@"%@", @("s")];
                } else {
                    map = [map stringByAppendingFormat:@"%@", @("x")];
                }
                if (cell.eastWallPresent) {
                    _west = [[WestFace alloc] initWithShader:shader];
                    _west.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_west];
                    _east = [[EastFace alloc] initWithShader:shader];
                    _east.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2) + (mazeScale * 2));
                    [self.children addObject:_east];
                    map = [map stringByAppendingFormat:@"%@", @("[e]]")];
                } else {
                    map = [map stringByAppendingFormat:@"%@", @("x")];
                }
                if (cell.westWallPresent) {
                    _east = [[EastFace alloc] initWithShader:shader];
                    _east.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2));
                    [self.children addObject:_east];
                    _west = [[WestFace alloc] initWithShader:shader];
                    _west.position = GLKVector3Make(_gameArea.width / 2 + (i * mazeScale * 2), _gameArea.height / 2, (j * mazeScale * 2) - (mazeScale * 2));
                    [self.children addObject:_west];
                    map = [map stringByAppendingFormat:@"%@", @("[w]")];
                } else {
                    map = [map stringByAppendingFormat:@"%@", @("x")];
                }
                map = [map stringByAppendingFormat:@"%@", @(" : ")];
            }
            map = [map stringByAppendingFormat:@"%@", @("\n")];
        }
        NSLog(@"%@", map);
         NSLog(@"%@", @"HELLO");
        
    }
    return self;
}

-(GLKVector3) getMazeEntrancePosition {    return GLKVector3Make(_cube.position.x, 0, _sceneOffset) ;
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
