//
//  customFilter.m
//  photoSphereRotation
//
//  Created by Tom Tong on 25/12/2016.
//  Copyright © 2016 Tom Tong. All rights reserved.
//

#import "customFilter.h"

@implementation rectRotation2

@synthesize inputImage;
@synthesize roll;
@synthesize yaw;
@synthesize pitch;

- (CIWarpKernel *)rectRotation2
{
    static CIWarpKernel *Kernel = nil;
    
    NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"rectRotation")];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError     *error = nil;
    NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"rectRotation" ofType:@"ciwarpkernel"] encoding:encoding error:&error];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Kernel = [CIWarpKernel kernelWithString:code];
    });
    
    return Kernel;
}

- (CIImage *)outputImage
{
    float w=self.inputImage.extent.size.width;
    float h=self.inputImage.extent.size.height;
    return [[self rectRotation2] applyWithExtent:CGRectMake(0, 0,w,h) roiCallback:^CGRect(int index, CGRect rect) {
        return CGRectMake(0, 0, w,h);
    } inputImage:self.inputImage arguments:[NSArray arrayWithObjects:roll,yaw,pitch,@(w),@(h),nil]];
}

@end
