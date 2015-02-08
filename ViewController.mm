//
//  ViewController.m
//
//  Created by Yoseph Radding on 1/16/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import "ViewController.hpp"
#import "ColorRecognizer.hpp"
#import "UIImage+RGBpixel.h"

@interface ViewController ()

@property (weak, nonatomic)  IBOutlet UIImageView* imageView;
@property (weak, nonatomic)  IBOutlet UIImageView* imageViewRight;
@property (weak, nonatomic)  IBOutlet UIImageView* imageViewFullScreen;
@property (weak, nonatomic)  IBOutlet UIButton* color;
@property (weak, nonatomic)  IBOutlet UILabel* selectr;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.selectr setHidden:YES];
    self->state = PHONE;
    [self.imageViewRight setHidden:YES];
    [self.imageView setHidden:YES];
    self.videoSource = [[VideoSource alloc] init];
    self.videoSource.delegate = self;
    [self.videoSource startWithDevicePosition:AVCaptureDevicePositionBack];
    imgProcessor = [[ImageProcessor alloc] init];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    lowHD = 40, lowH = 40;
    lowSD = 100, lowS = 100;
    lowVD = 100, lowV = 100;
    highHD = 80, highH = 80;
    highSD = 255, highS = 255;
    highVD = 255, highV = 255;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)frameReady:(VideoFrame)frame{
   
    dispatch_sync( dispatch_get_main_queue(), ^{
        // Construct CGContextRef from VideoFrame
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(frame.data,
                                                        frame.width,
                                                        frame.height,
                                                        8,
                                                        frame.stride,
                                                        colorSpace,
                                                        kCGBitmapByteOrder32Little |
                                                        kCGImageAlphaPremultipliedFirst);
        
        // Construct CGImageRef from CGContextRef
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);

        // Construct UIImage from CGImageRef
        UIImage * image = [UIImage imageWithCGImage:newImage];
        
        switch (self->state) {
            case GLASS:{
                image = [ColorRecognizer processImage:image debug:NO values:@[[NSNumber numberWithDouble:lowH],[NSNumber numberWithDouble:lowS],[NSNumber numberWithDouble:lowV],[NSNumber numberWithDouble:highH], [NSNumber numberWithDouble:highS], [NSNumber numberWithDouble:highV]]] ;
                [self.imageView setImage:image];
                [self.imageViewRight setImage:image];
                break;
            }
            case PHONE:{
                image = [ColorRecognizer processImage:image debug:NO values:@[[NSNumber numberWithDouble:lowH],[NSNumber numberWithDouble:lowS],[NSNumber numberWithDouble:lowV],[NSNumber numberWithDouble:highH], [NSNumber numberWithDouble:highS], [NSNumber numberWithDouble:highV]]] ;
                [self.imageViewFullScreen setImage:image];
                break;
            }
            case DEBUGGLASS:{
                image = [ColorRecognizer processImage:image debug:YES values:@[[NSNumber numberWithDouble:lowH],[NSNumber numberWithDouble:lowS],[NSNumber numberWithDouble:lowV],[NSNumber numberWithDouble:highH], [NSNumber numberWithDouble:highS], [NSNumber numberWithDouble:highV]]];
                [self.imageView setImage:image];
                [self.imageViewRight setImage:image];
                
                break;
            }
            case DEBUGPHONE:{
                image = [ColorRecognizer processImage:image debug:YES values:@[[NSNumber numberWithDouble:lowH],[NSNumber numberWithDouble:lowS],[NSNumber numberWithDouble:lowV],[NSNumber numberWithDouble:highH], [NSNumber numberWithDouble:highS], [NSNumber numberWithDouble:highV]]];
                [self.imageViewFullScreen setImage:image];
                break;
            }
            case SELECTEDCOLOR:{
                image = [ColorRecognizer processImage:image debug:NO values:@[[NSNumber numberWithDouble:lowH],[NSNumber numberWithDouble:lowS],[NSNumber numberWithDouble:lowV],[NSNumber numberWithDouble:highH], [NSNumber numberWithDouble:highS], [NSNumber numberWithDouble:highV]]] ;
                [self.imageView setImage:image];
                [self.imageViewRight setImage:image];
                [self.imageViewFullScreen setImage:image];
                
                //transform Color
                NSArray* colorVect = [ColorRecognizer getColorAtPoint:touchPoint fromImage:image];
                highH = (.30 * [colorVect[0] floatValue] + [colorVect[0] floatValue]);
                lowH = ([colorVect[0] floatValue] - .30 * [colorVect[0] floatValue]);
                highS = (.30 * [colorVect[1] floatValue] + [colorVect[1] floatValue]);
                lowS = ([colorVect[1] floatValue] - .30 * [colorVect[1] floatValue]);
                highV = (.15 * [colorVect[2] floatValue] + [colorVect[2] floatValue]);
                lowV = ([colorVect[2] floatValue] - .30 * [colorVect[2] floatValue]);
                RGBAPixel thing = [image bitmap][(int)(touchPoint.x * touchPoint.y)];
                _color.backgroundColor = [UIColor colorWithRed: thing.red/255.0 green:thing.green/255.0  blue: thing.blue/255.0 alpha:1.0];
                state = prevState;
                [self.selectr setHidden:YES];
                break;
            }
            case SELECTCOLOR:{
                [self.imageView setImage:image];
                [self.imageViewRight setImage:image];
                [self.imageViewFullScreen setImage:image];
                break;
            }
        }
        CGImageRelease(newImage);
        CGContextRelease(newContext);
//        CGColorSpaceRelease(colorSpace);
    });
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
        switch (self->state) {
            case GLASS:
                self->state = PHONE;
                
                [self.imageView setHidden:YES];
                [self.imageViewRight setHidden:YES];
                [self.imageViewFullScreen setHidden:NO];
                
                break;
            case PHONE:
                self->state = DEBUGGLASS;
                
                [self.imageView setHidden:NO];
                [self.imageViewRight setHidden:NO];
                [self.imageViewFullScreen setHidden:YES];
                break;
            case DEBUGGLASS:
                self->state = DEBUGPHONE;
                
                [self.imageView setHidden:YES];
                [self.imageViewRight setHidden:YES];
                [self.imageViewFullScreen setHidden:NO];
                
                break;
            case DEBUGPHONE:
                self->state = GLASS;
                
                [self.imageView setHidden:NO];
                [self.imageViewRight setHidden:NO];
                [self.imageViewFullScreen setHidden:YES];
                break;
            case SELECTCOLOR:
                touchPoint = [recognizer locationInView: recognizer.view];
                state = SELECTEDCOLOR;
//                [self.videoSource toggleFlashLight];
                break;
            case SELECTEDCOLOR:
                break;
        }
}

- (IBAction)actionStart:(id)sender{
//    [self.group setHidden:NO];
    if(state == SELECTCOLOR) return;
    prevState = state;
    state = SELECTCOLOR;
    [self.selectr setHidden:NO];
//    [self.videoSource toggleFlashLight];
}

- (IBAction)reset:(id)sender{
    lowH = lowHD;
    lowS = lowSD;
    lowV = lowVD;
    highH = highHD;
    highS = highSD;
    highV = highVD;
}



@end
