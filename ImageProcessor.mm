//
//  ImageProcessor.m
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import "ImageProcessor.hpp"

@implementation ImageProcessor

-(id) init{
    if(self = [super init]){
        recognizer = [[ColorRecognizer alloc] init];
    }
    return self;
}
-(UIImage*) process: (UIImage*) toProcess{
//    UIImage* tempImage = [recognizer processImage:toProcess];
//    return tempImage;
    return nil;
}
@end
