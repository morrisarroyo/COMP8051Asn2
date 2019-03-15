#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Node;

@interface Director : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) Node *scene;

@end
