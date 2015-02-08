//
//  UIImage+RGBpixel.m
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#define RGBA        4
#define RGBA_8_BIT  8
#import "UIImage+RGBpixel.h"

@implementation UIImage (RGBpixel)
-(RGBAPixel*) bitmap {
    
    size_t bytesPerRow;
    size_t byteCount;
    size_t pixelCount;
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    UInt8 *pixelByteData;
    // A pointer to an array of RGBA bytes in memory
    RGBAPixel *pixelData;
    NSLog( @"Returning bitmap representation of UIImage." );
    // 8 bits each of red, green, blue, and alpha.
    bytesPerRow = self.size.width * RGBA;
    
    byteCount= bytesPerRow * self.size.height;
    pixelCount = self.size.width * self.size.height;
    
    // Create RGB color space
//    [self setColorSpace:CGColorSpaceCreateDeviceRGB()];
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (!colorSpace)
    {
        NSLog(@"Error allocating color space.");
        return nil;
    }
    
    pixelData = malloc(byteCount);
    
    if (!pixelData)
    {
        NSLog(@"Error allocating bitmap memory. Releasing color space.");
        CGColorSpaceRelease(colorSpace);
        
        return nil;
    }
    
    // Create the bitmap context.
    // Pre-multiplied RGBA, 8-bits per component.
    // The source image format will be converted to the format specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate(
                                           (void*)pixelData,
                                           self.size.width,
                                           self.size.height,
                                           RGBA_8_BIT,
                                           bytesPerRow,
                                           colorSpace,
                                           kCGImageAlphaPremultipliedLast
                                           );
    
    // Make sure we have our context
    if (!context)   {
        free(pixelData);
        NSLog(@"Context not created!");
    }
    
    // Draw the image to the bitmap context.
    // The memory allocated for the context for rendering will then contain the raw image pixelData in the specified color space.
    CGRect rect = { { 0 , 0 }, { self.size.width, self.size.height } };
    
    CGContextDrawImage( context, rect, self.CGImage );
    
    // Now we can get a pointer to the image pixelData associated with the bitmap context.
    pixelData = (RGBAPixel*) CGBitmapContextGetData(context);
    
    return pixelData;
}
@end
