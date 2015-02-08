//
//  UIImage+RGBpixel.h
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct RGBAPixel {
    Byte red;
    Byte green;
    Byte blue;
    Byte alpha;
} RGBAPixel;

@interface UIImage (RGBpixel)
-(RGBAPixel*) bitmap ;
@end
