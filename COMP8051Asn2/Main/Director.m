#import "Director.h"
#import "Node.h"

@implementation Director

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static Director * _sharedInstance;
    dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init]; });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    return self;
}
- (void)setScene:(Node *)scene {
    _scene = scene;
}

@end
