//
//  VideoFrame.h
//
//  Created by Yoseph Radding on 1/16/15.
//  Copyright (c) 2015 Yoseph Radding. All rights reserved.
//

#include <cstddef>

struct VideoFrame
{
    size_t width;
    size_t height;
    size_t stride;
    
    unsigned char * data;
};
