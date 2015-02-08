//
//  ViewController.h
//
//  Created by Yoseph Radding on 1/16/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSource.h"
#import "ImageProcessor.hpp"

enum States{
    GLASS,
    PHONE,
    DEBUGGLASS,
    DEBUGPHONE,
    SELECTCOLOR,
    SELECTEDCOLOR
};

@interface ViewController : UIViewController <VideoSourceDelegate>
{
    double lowHD, lowSD, lowVD, highHD, highSD,highVD;
    double lowH, lowS, lowV, highH, highS,highV;
    VideoSource* videoSource;
    ImageProcessor *imgProcessor;
    enum States state;
    enum States prevState;
    CGPoint touchPoint;
    
}

@property VideoSource* videoSource;



- (IBAction) changeValue:(id) sender;
- (IBAction)actionStart:(id)sender;
- (IBAction)reset:(id)sender;

@end
