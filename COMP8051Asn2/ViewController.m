//
//  ViewController.m
//  Asn2
//
//  Created by Renz on 3/11/19.
//  Copyright © 2019 Renz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Cube.h"
#import "TestScene.h"
#import "Director.h"
#import "BaseEffect.h"

@interface ViewController () {
    BaseEffect* _shader;
    GLKMatrix4 cameraViewMatrix;
    float xtrans;
    float ztrans;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    xtrans = 0;
    ztrans = 0;
    [EAGLContext setCurrentContext:view.context];
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIPanGestureRecognizer *singlePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingePanGesture:)];
    singlePanGesture.maximumNumberOfTouches = 1;
    singlePanGesture.minimumNumberOfTouches = 1;
    //singlePanGesture.m
    
    UIPinchGestureRecognizer *zoomInGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector(handleZoomInPinchGesture:)];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDownGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:singlePanGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:swipeDownGesture];
    [self setupScene];
}

-(void)handleSingePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        NSLog(@"%@ %@", @"> 1.0", @"Pan");
        CGPoint translatedPoint = CGPointZero;
        CGPoint initialCenter = CGPointZero;
        if(sender.state == UIGestureRecognizerStateBegan) {
            initialCenter = [sender translationInView:sender.view.superview];
            
        }
        if(sender.state == UIGestureRecognizerStateChanged) {
            translatedPoint = [sender translationInView:sender.view.superview];
            if (fabs(translatedPoint.y  - initialCenter.y) > 3)
                ztrans = -(translatedPoint.y  - initialCenter.y) / 200;
            else
                ztrans = 0.0f;
            if (fabs(translatedPoint.x  - initialCenter.x) > 3)
                xtrans = -(translatedPoint.x  - initialCenter.x) / 200;
            else
                xtrans = 0.0f;
        }
        if(sender.state == UIGestureRecognizerStateEnded) {
            xtrans = 0.0f;
            ztrans = 0.0f;
        }
    } else {
        
        xtrans = 0.0f;
        ztrans = 0.0f;
    }
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer *) sender {
    NSLog(@"%@", @"Reset Position");
    cameraViewMatrix = GLKMatrix4Identity;
    //_shader
}

-(void)handleSwipeDownGesture:(UISwipeGestureRecognizer *) sender {    if(_shader.dayNightFactor == 1.0) {
        [Director sharedInstance].scene.dayNightFactor = .25f;
    } else {
        
        [Director sharedInstance].scene.dayNightFactor = 1.0f;

    }    
    NSLog(@"%@ %f", @"Toggle Day and Night", [Director sharedInstance].scene.dayNightFactor);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);    /*
     float amount = 0.25 * sin(CACurrentMediaTime()) + 0.75;
     float amount2 = 0.25 * sin(CACurrentMediaTime()+M_PI_4) + 0.75;
     float amount3 = 0.25 * sin(CACurrentMediaTime()+M_PI_2) + 0.75;
     
     glClearColor(amount, amount2, amount3, 1.0);
     glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
     glEnable(GL_DEPTH_TEST);
     glEnable(GL_CULL_FACE);
     */
    cameraViewMatrix = GLKMatrix4Translate(cameraViewMatrix, xtrans, 0, ztrans);
    [[Director sharedInstance].scene renderWithParentModelViewMatrix:cameraViewMatrix withDayNightFactor:[Director sharedInstance].scene.dayNightFactor];
}

- (void) setupScene{
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(85.0), self.view.frame.size.width/self.view.frame.size.height, 1, 150);
    cameraViewMatrix = GLKMatrix4Identity;
    
    
    [Director sharedInstance].scene = [[TestScene alloc] initWithShader:_shader];
    [Director sharedInstance].view = self.view;
}

- (void)update {
    [[Director sharedInstance].scene updateWithDelta:self.timeSinceLastUpdate];
}

@end
