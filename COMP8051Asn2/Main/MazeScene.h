#import "Node.h"


@interface MazeScene : Node

- (instancetype)initWithShader:(BaseEffect *)shader;
-(GLKVector3) getMazeEntrancePosition;
-(NSString *) getMapAscii;
- (void)moveTank;
- (int)getBoulderZPos;
- (int)getBoulderXPos;
@end
