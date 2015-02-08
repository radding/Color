//
//  ImageProcessor.h
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorRecognizer.hpp"

@interface ImageProcessor : NSObject{
    ColorRecognizer *recognizer;
}

-(UIImage*) process: (UIImage*) toProcess;
@end
