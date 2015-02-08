//
//  ColorRecognizer.h
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@class UIImage;

@interface ColorRecognizer : NSObject{
    
}

@property cv::Mat image;
@property cv::Mat image_copy;

+ (UIImage*)processImage:(UIImage*)image debug:(BOOL) deb values:(NSArray*) vals;
+ (NSArray*) getColorAtPoint: (CGPoint)point fromImage:(UIImage*)img;
@end
