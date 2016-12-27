//
//  customFilter.m
//  photoSphereRotation
//
//  Created by Tom Tong on 25/12/2016.
//  Copyright © 2016 Tom Tong. All rights reserved.
//

#import "customFilter.h"

@implementation sample

@synthesize inputImage;

- (CIKernel *)sample
{
    static CIKernel *Kernel = nil;
    
    NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"sample")];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError     *error = nil;
    NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"sample" ofType:@"cikernel"] encoding:encoding error:&error];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       Kernel = [CIKernel kernelWithString:code];
    });
    
    return Kernel;
}

- (CIImage *)outputImage
{
    CIImage *result = self.inputImage;
    return [[self sample] applyWithExtent:CGRectMake(0, 0, result.extent.size.width, result.extent.size.height) roiCallback:^CGRect(int index, CGRect rect) {
        return CGRectMake(0, 0, CGRectGetWidth(result.extent), CGRectGetHeight(result.extent));
    } arguments:[NSArray arrayWithObjects:result,nil]];
//    return [[self distortionHole] applyWithExtent:CGRectMake(0, 0, result.extent.size.height, result.extent.size.height) arguments:[NSArray arrayWithObjects:result,nil]];
}

@end

@implementation fisheyeToRect

@synthesize inputImage;

- (CIKernel *)fisheyeToRect
{
    static CIKernel *Kernel = nil;
    
    NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"fisheyeToRect")];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError     *error = nil;
    NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"fisheyeToRect" ofType:@"cikernel"] encoding:encoding error:&error];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Kernel = [CIKernel kernelWithString:code];
    });
    
    return Kernel;
}

- (CIImage *)outputImage
{
    float w=self.inputImage.extent.size.width;
    float h=self.inputImage.extent.size.height;
    return [[self fisheyeToRect] applyWithExtent:CGRectMake(0, 0,400,400) roiCallback:^CGRect(int index, CGRect rect) {
        return CGRectMake(0, 0, w,h);
    } arguments:[NSArray arrayWithObjects:self.inputImage,nil]];
}

@end

@implementation rectRotation

@synthesize inputImage;
@synthesize isX;
@synthesize isY;
@synthesize isZ;
@synthesize angle;

- (CIKernel *)rectRotation
{
    static CIKernel *Kernel = nil;
    
    NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"rectRotation")];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError     *error = nil;
    NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"rectRotation" ofType:@"cikernel"] encoding:encoding error:&error];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Kernel = [CIKernel kernelWithString:code];
    });
    
    return Kernel;
}

- (CIImage *)outputImage
{
    float w=self.inputImage.extent.size.width;
    float h=self.inputImage.extent.size.height;
    return [[self rectRotation] applyWithExtent:CGRectMake(0, 0,w,h) roiCallback:^CGRect(int index, CGRect rect) {
        return CGRectMake(0, 0, w,h);
    } arguments:[NSArray arrayWithObjects:self.inputImage,isX,isY,isZ,angle,nil]];
}

@end

@implementation rectRotation2

@synthesize inputImage;
@synthesize isX;
@synthesize isY;
@synthesize isZ;
@synthesize angle;

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
    } inputImage:self.inputImage arguments:[NSArray arrayWithObjects:isX,isY,isZ,angle,@(w),@(h),nil]];
}

@end
