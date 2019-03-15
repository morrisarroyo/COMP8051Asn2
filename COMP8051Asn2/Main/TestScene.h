#import "Node.h"


@interface TestScene : Node

- (instancetype)initWithShader:(BaseEffect *)shader;
-(GLKVector3) getMazeEntrancePosition;
@end
