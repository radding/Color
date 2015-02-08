//
//  VideoSource.h
//
//  Created by Yoseph Radding on 1/16/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "VideoFrame.hpp"

#pragma mark -
#pragma mark VideoSource Delegate
@protocol VideoSourceDelegate <NSObject>

@required
- (void)frameReady:(VideoFrame)frame;

@end

#pragma mark -
#pragma mark VideoSource Interface
@interface VideoSource : NSObject

@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic, weak) id<VideoSourceDelegate> delegate;

- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition;
- (void) toggleFlashLight;

@end
