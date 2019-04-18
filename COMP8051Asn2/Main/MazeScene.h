#import "Node.h"


@interface MazeScene : Node

@property GLKMatrix4 cam;

- (instancetype)initWithShader:(BaseEffect *)shader;
-(GLKVector3) getMazeEntrancePosition;
-(NSString *) getMapAscii;
- (void)moveTank;
- (int)getBoulderZPos;
- (int)getBoulderXPos;
@end
