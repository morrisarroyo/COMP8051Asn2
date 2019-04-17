#import <Foundation/Foundation.h>
#import "ViewController.h"
//#import "Cube.h"
#import "MazeScene.h"
#import "Director.h"
#import "BaseEffect.h"
#import "MazeCaller.h"

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
    GLKMatrix4 minimapMatrix;
    NSString *mazeString;
}
@property (weak, nonatomic) IBOutlet UISlider *fogStartSlider;
@property (weak, nonatomic) IBOutlet UISlider *fogEndSlider;
@property (weak, nonatomic) IBOutlet UISlider *fogRedSlider;
@property (weak, nonatomic) IBOutlet UISlider *fogGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *fogBlueSlider;
@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;





@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.contentScaleFactor = 1.0f;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    xtrans = 0;
    ztrans = 0;
    totalyrot =0;
    [EAGLContext setCurrentContext:view.context];
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self setupGestures];
    [self setupScene];
}

-(void) setupGestures {
    UIPanGestureRecognizer *singlePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingePanGesture:)];
    singlePanGesture.maximumNumberOfTouches = 1;
    singlePanGesture.minimumNumberOfTouches = 1;
    UIPanGestureRecognizer *doublePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoublePanGesture:)];
    doublePanGesture.maximumNumberOfTouches = 2;
    doublePanGesture.minimumNumberOfTouches = 2;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    UITapGestureRecognizer *doubleDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleDoubleTapGesture:)];
    doubleDoubleTapGesture.numberOfTapsRequired = 2;
    doubleDoubleTapGesture.numberOfTouchesRequired = 2;
    _consoleTextView.hidden = true;
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDownGesture.numberOfTouchesRequired = 2;
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUpGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:singlePanGesture];
    [self.view addGestureRecognizer:doublePanGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:doubleDoubleTapGesture];
    [self.view addGestureRecognizer:swipeDownGesture];
    [self.view addGestureRecognizer:swipeUpGesture];
}

- (IBAction)toggleDayNight:(id)sender {
    if(_shader.dayNightFactor == 1.0) {
        [Director sharedInstance].scene.dayNightFactor = .15f;
    } else {
        
        [Director sharedInstance].scene.dayNightFactor = 1.0f;
        
    }
    NSLog(@"%@ %f", @"Toggle Day and Night", [Director sharedInstance].scene.dayNightFactor);
}
- (IBAction)toggleFlashlight:(id)sender {
    if(_shader.flashlightActive == true) {
        [Director sharedInstance].scene.flashlightActive = false;
    } else {
        [Director sharedInstance].scene.flashlightActive = true;
    }
    NSLog(@"%@", @"Toggle Flashlight");
}
- (IBAction)toggleFog:(id)sender {
    if([Director sharedInstance].scene.fogActive) {
        [Director sharedInstance].scene.fogActive = false;
    } else {
        [Director sharedInstance].scene.fogActive = true;
    }
    NSLog(@"%@", @"Toggle Fog");
}
- (IBAction)setFog:(id)sender {
    [Director sharedInstance].scene.shader.fogColour = GLKVector4Make(_fogRedSlider.value, _fogGreenSlider.value, _fogBlueSlider.value, 1.0);
    [Director sharedInstance].scene.shader.fogStart = _fogStartSlider.value;
    [Director sharedInstance].scene.shader.fogEnd =_fogStartSlider.value + _fogEndSlider.value;
    NSLog(@"%@", @"Set Fog");
}

-(void)handleSingePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        //NSLog(@"%@ %@", @"> 1.0", @"Single Pan");
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

-(void)handleDoublePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 2) {
        //NSLog(@"%@ %@", @"> 1.0", @"Double Pan");
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
    totalyrot = 0;
    xtrans = 0;
    ztrans = 0;
    yrot = 0;
    GLKVector3 enterPos = [(MazeScene *)([Director sharedInstance].scene) getMazeEntrancePosition];
    translationMatrix.m30 = enterPos.x;
    translationMatrix.m32 = enterPos.z;
    [self updateConsoleText];
}

-(void)handleDoubleDoubleTapGesture:(UITapGestureRecognizer *) sender {
    NSLog(@"%@", @"Toggle Console");
    _consoleTextView.hidden = !_consoleTextView.hidden;
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

- (void)updateConsoleText {
    GLKVector3 enterPos = [(MazeScene *)([Director sharedInstance].scene) getMazeEntrancePosition];
    NSMutableString *consoleString = [[NSMutableString alloc] init];
    [consoleString appendFormat: @"Postion X: %f\nPostion Z: %f\n", enterPos.x  -translationMatrix.m30, translationMatrix.m32 - enterPos.z];
    [consoleString appendFormat: @"Rotation Y:%f", GLKMathRadiansToDegrees(totalyrot)];
    [consoleString appendFormat: @"%@", [(MazeScene *)([Director sharedInstance].scene) getMapAscii]];
    _consoleTextView.text = consoleString;
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
    GLKVector2 viewportSize =  GLKVector2Make(self.view.bounds.size.width , self.view.bounds.size.height);
    glViewport(0, 0, viewportSize.x, viewportSize.y );
    //glScissor(0, 0, viewportSize.x, viewportSize.y);
    
    totalyrot += yrot;
    int tc = totalyrot / (M_PI * 2);
    totalyrot = totalyrot - (tc * M_PI * 2);

    translationMatrix = GLKMatrix4Translate(translationMatrix, xtrans * cosf(totalyrot) - ztrans * sinf(totalyrot), 0, xtrans * sinf(totalyrot) + ztrans * cosf(totalyrot));
    rotationMatrix = GLKMatrix4Rotate(rotationMatrix, yrot, 0, 1, 0);
    GLKMatrix4 vm = GLKMatrix4Multiply(rotationMatrix,cameraViewMatrix);
    vm = GLKMatrix4Translate(vm, translationMatrix.m30, translationMatrix.m31, translationMatrix.m32);
    [[Director sharedInstance].scene renderWithParentModelViewMatrix:vm withDayNightFactor:[Director sharedInstance].scene.dayNightFactor withFlashlightActive:[Director sharedInstance].scene.flashlightActive withFogActive:[Director sharedInstance].scene.fogActive];
    [self updateConsoleText];
    // Minimap
    
    int minimapSideLength = viewportSize.x / 2;
    glViewport(0, 0, minimapSideLength, minimapSideLength );
    glScissor(0, 0, minimapSideLength, minimapSideLength);

    [[Director sharedInstance].scene renderWithParentModelViewMatrix:minimapMatrix withDayNightFactor:1.0 withFlashlightActive:false withFogActive:false];
    _shader.dayNightFactor = [Director sharedInstance].scene.dayNightFactor;
    _shader.fogActive = [Director sharedInstance].scene.fogActive;
    _shader.flashlightActive = [Director sharedInstance].scene.flashlightActive;
    
}

- (void) setupScene{
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
        fragmentShader:@"SimpleFragment.glsl"];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(85.0), self.view.frame.size.width/self.view.frame.size.height, 1, 1000);
    _shader.viewportUniform = GLKVector2Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    cameraViewMatrix = GLKMatrix4Identity;
    translationMatrix = GLKMatrix4Identity;
    rotationMatrix = GLKMatrix4Identity;
    minimapMatrix = GLKMatrix4Identity;
    [Director sharedInstance].scene = [[MazeScene alloc] initWithShader:_shader];
    GLKVector3 enterPos = [(MazeScene *)([Director sharedInstance].scene) getMazeEntrancePosition];
    translationMatrix.m30 = enterPos.x;
    translationMatrix.m32 = enterPos.z;
    minimapMatrix = GLKMatrix4Rotate(minimapMatrix, GLKMathDegreesToRadians(75), 1, 0, 0);
    minimapMatrix = GLKMatrix4Rotate(minimapMatrix, GLKMathDegreesToRadians(-20), 0, 0, 1);
    minimapMatrix.m30 = 16 ;
    minimapMatrix.m31 = -135 ;
    minimapMatrix.m32 = -7 ;
    [Director sharedInstance].view = self.view;
}

- (void)update {
    [[Director sharedInstance].scene updateWithDelta:self.timeSinceLastUpdate];
}

@end
