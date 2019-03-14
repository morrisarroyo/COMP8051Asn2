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
    //float xrot;
    float yrot;
    float totalyrot;
    //float zrot;
    GLKMatrix4 translationMatrix;
    GLKMatrix4 rotationMatrix;
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
    totalyrot =0;
    [EAGLContext setCurrentContext:view.context];
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIPanGestureRecognizer *singlePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingePanGesture:)];
    singlePanGesture.maximumNumberOfTouches = 1;
    singlePanGesture.minimumNumberOfTouches = 1;
    UIPanGestureRecognizer *doublePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoublePanGesture:)];
    doublePanGesture.maximumNumberOfTouches = 2;
    doublePanGesture.minimumNumberOfTouches = 2;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDownGesture.numberOfTouchesRequired = 2;
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUpGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:singlePanGesture];
    [self.view addGestureRecognizer:doublePanGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:swipeDownGesture];
    [self.view addGestureRecognizer:swipeUpGesture];
    [self setupScene];
}

-(void)handleSingePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        NSLog(@"%@ %@", @"> 1.0", @"Single Pan");
        CGPoint translatedPoint = CGPointZero;
        CGPoint initialCenter = CGPointZero;
        /*
        GLKMatrix4 nTranslationMatrix = translationMatrix;
        //cameraViewMatrix = GLKMatrix4Multiply(rotationMatrix, GLKMatrix4Multiply(cameraViewMatrix, nTranslationMatrix));
        nTranslationMatrix.m30 = -nTranslationMatrix.m30;
        nTranslationMatrix.m32 = -nTranslationMatrix.m32;
         
        GLKMatrix4 tempMatrix = cameraViewMatrix;
        GLKMatrix4 nMatrix = GLKMatrix4Invert(cameraViewMatrix, NULL);
        GLKMatrix4 vm = GLKMatrix4Multiply(nMatrix,cameraViewMatrix);
        //rotationMatrix = GLKMatrix4Rotate(rotationMatrix, yrot, 0, 1, 0);
        GLKMatrix4 vm = GLKMatrix4Multiply(translationMatrix, GLKMatrix4Multiply(rotationMatrix, cameraViewMatrix));
*/
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
        //vm = GLKMatrix4Translate(translationMatrix, xtrans, 0, ztrans);
    } else {
        
        xtrans = 0.0f;
        ztrans = 0.0f;
    }
}

-(void)handleDoublePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 2) {
        NSLog(@"%@ %@", @"> 1.0", @"Double Pan");
        CGPoint translatedPoint = CGPointZero;
        CGPoint initialCenter = CGPointZero;
        if(sender.state == UIGestureRecognizerStateBegan) {
            initialCenter = [sender translationInView:sender.view.superview];
            
        }
        if(sender.state == UIGestureRecognizerStateChanged) {
            translatedPoint = [sender translationInView:sender.view.superview];
            if (fabs(translatedPoint.x  - initialCenter.x) > 3)
                yrot = (translatedPoint.x  - initialCenter.x) / 2000;
            else
                yrot = 0.0f;
        }
        if(sender.state == UIGestureRecognizerStateEnded) {
            yrot = 0.0f;
        }
    } else {
        yrot = 0.0f;
    }
}


-(void)handleDoubleTapGesture:(UITapGestureRecognizer *) sender {
    NSLog(@"%@", @"Reset Position");
    translationMatrix = GLKMatrix4Identity;
    rotationMatrix = GLKMatrix4Identity;
    //_shader
}

-(void)handleSwipeDownGesture:(UISwipeGestureRecognizer *) sender {
    if(_shader.dayNightFactor == 1.0) {
        [Director sharedInstance].scene.dayNightFactor = .15f;
    } else {
        
        [Director sharedInstance].scene.dayNightFactor = 1.0f;

    }    
    NSLog(@"%@ %f", @"Toggle Day and Night", [Director sharedInstance].scene.dayNightFactor);
}

-(void)handleSwipeUpGesture:(UISwipeGestureRecognizer *) sender {
    if(_shader.flashlightActive == true) {
        [Director sharedInstance].scene.flashlightActive = false;
    } else {
        [Director sharedInstance].scene.flashlightActive = true;
    }
    NSLog(@"%@", @"Toggle Flashlight");
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
    
    GLKMatrix4 nTranslationMatrix = translationMatrix;
    //cameraViewMatrix = GLKMatrix4Multiply(rotationMatrix, GLKMatrix4Multiply(cameraViewMatrix, nTranslationMatrix));
    nTranslationMatrix.m30 = -nTranslationMatrix.m30;
    nTranslationMatrix.m32 = -nTranslationMatrix.m32;
    //translationMatrix = GLKMatrix4Translate(translationMatrix,cosf(totalyrot) *  ztrans + sinf(totalyrot) * xtrans, 0, sinf(totalyrot) * ztrans + cosf(totalyrot) * xtrans);
    translationMatrix = GLKMatrix4Translate(translationMatrix, xtrans, 0, ztrans);
    //rotationMatrix = GLKMatrix4Rotate(rotationMatrix, yrot, 0, 1, 0);
    GLKMatrix4 vm = GLKMatrix4Multiply(translationMatrix, cameraViewMatrix);
    totalyrot += yrot;
    int tc = totalyrot / (M_PI * 2);
    totalyrot = totalyrot - (tc * M_PI * 2);
    [Director sharedInstance].scene.rotationY = totalyrot;
    [[Director sharedInstance].scene renderWithParentModelViewMatrix:vm withDayNightFactor:[Director sharedInstance].scene.dayNightFactor withFlashlightActive:[Director sharedInstance].scene.flashlightActive];
    //cameraViewMatrix = vm;
}

- (void) setupScene{
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(85.0), self.view.frame.size.width/self.view.frame.size.height, 1, 1000);
    _shader.viewportUniform = GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height);
    cameraViewMatrix = GLKMatrix4Identity;
    translationMatrix = GLKMatrix4Identity;
    rotationMatrix = GLKMatrix4Identity;
    [Director sharedInstance].scene = [[TestScene alloc] initWithShader:_shader];
    
    totalyrot = [Director sharedInstance].scene.rotationY;
    translationMatrix = GLKMatrix4Translate(translationMatrix, [Director sharedInstance].scene.position.x, [Director sharedInstance].scene.position.y, [Director sharedInstance].scene.position.z);
    [Director sharedInstance].scene.position = GLKVector3Make(0,0,0);
    [Director sharedInstance].view = self.view;
}

- (void)update {
    [[Director sharedInstance].scene updateWithDelta:self.timeSinceLastUpdate];
}

@end
