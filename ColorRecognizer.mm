//
//  ColorRecognizer.m
//
//  Created by Yoseph Radding on 1/17/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#import "ColorRecognizer.hpp"
#import <opencv2/highgui/ios.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <vector>

using std::vector;
using namespace cv;

@implementation ColorRecognizer
-(id) init{
    if(self = [super init]){
    }
    return self;
}

static UIImage* cvMatToUIImage(const cv::Mat& m) {
    CV_Assert(m.depth() == CV_8U);
    NSData *data = [NSData dataWithBytes:m.data length:m.elemSize()*m.total()];
    CGColorSpaceRef colorSpace = m.channels() == 1 ?
    CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(m.cols, m.cols, m.elemSize1()*8, m.elemSize()*8,
                                        m.step[0], colorSpace, kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef); CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace); return finalImage;
}


static void cvUIImageToMat(const UIImage* image, cv::Mat& m) {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width, rows = image.size.height;
    m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGContextRef contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8, m.step[0], colorSpace, kCGImageAlphaNoneSkipLast |kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
//    CGColorSpaceRelease(colorSpace);
}


+(UIImage*)processImage:(UIImage*)img debug:(BOOL) deb values:(NSArray*) val{
    
    RNG rng(12345);
    cv::Mat image;
    cv::Mat image2;

    cvUIImageToMat(img, image);
    cvUIImageToMat(img, image2);
    Scalar lowValues = Scalar([val[0] doubleValue] ,[val[1] doubleValue], [val[2] doubleValue]);
    Scalar highValues = Scalar([val[3] doubleValue],[val[4] doubleValue],[val[5] doubleValue]);
    
//    cv::Mat image;
    cvtColor(image, image, cv::COLOR_BGR2HSV);
    
    inRange(image, lowValues, highValues, image);
    erode(image, image, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    dilate( image, image, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    
    //morphological closing (fill small holes in the foreground)
    dilate( image, image, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    erode(image, image, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
//    //Old Code
    Mat threshold_output;
    vector<vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;
    
    /// Detect edges using Threshold
    threshold( image, threshold_output, 100, 255, THRESH_BINARY );
    /// Find contours
    findContours( threshold_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
    
    /// Approximate contours to polygons + get bounding rects and circles
    vector<vector<cv::Point> > contours_poly( contours.size() );
    vector<cv::Rect> boundRect( contours.size() );
    vector<cv::Point2f>center( contours.size() );
    vector<float>radius( contours.size() );
    
    for( int i = 0; i < contours.size(); i++ )
    { approxPolyDP( Mat(contours[i]), contours_poly[i], 3, true );
        boundRect[i] = boundingRect( Mat(contours_poly[i]) );
        minEnclosingCircle( (Mat)contours_poly[i], center[i], radius[i] );
    }
    
    
    for( int i = 0; i< contours.size(); i++ )
    {
        Scalar color = Scalar( 62, 255, 35 );
        rectangle( image2,  boundRect[i].tl(),  boundRect[i].br(), color, 2, 8, 0 );
    }


    UIImage * test = deb ? MatToUIImage(image) :  MatToUIImage(image2);
    image.release();
    
    return test;
}

+ (NSArray*) getColorAtPoint:(CGPoint) point fromImage:(UIImage*)img{
    double h,s,v;
    
    cv::Mat image;
    cvUIImageToMat(img, image);
    //Test code!! delete
    
//    InputArray
    
    Vec3b color = image.at<Vec3b>(cv::Point(point.x,point.y));
    float r = color.val[0];
    float g = color.val[1];
    float b = color.val[2];
    NSLog(@"r:%f, g:%f, b:%f",r,g,b);
    //end
    cvtColor(image, image, cv::COLOR_BGR2HSV);
    
    color = image.at<Vec3b>(cv::Point(point.x,point.y));
    h = color.val[0];
    s = color.val[1];
    v = color.val[2];
     NSLog(@"h:%f, s:%f, v:%f",h,s,v);
    
    return @[[NSNumber numberWithDouble:h],[NSNumber numberWithDouble:s],[NSNumber numberWithDouble:v], [NSNumber numberWithDouble:r],[NSNumber numberWithDouble:g],[NSNumber numberWithDouble:b]];
}

@end
