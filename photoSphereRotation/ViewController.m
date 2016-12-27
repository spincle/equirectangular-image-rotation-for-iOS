//
//  ViewController.m
//  photoSphereRotation
//
//  Created by Tom Tong on 25/12/2016.
//  Copyright © 2016 Tom Tong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* imageUrl = [[NSBundle mainBundle] URLForResource:@"sphere" withExtension:@"jpg"];
    UIImage* inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];
    UIImageWriteToSavedPhotosAlbum(inputImg,
                                 nil,nil,nil);
    UIImageView* imgView=[[UIImageView alloc] init];
    float w=self.view.frame.size.width;
    float h=self.view.frame.size.height;
    imgView.frame=CGRectMake(0,0,w,h);
    [imgView setImage:inputImg];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

float isX=1;
float isY=0;
float isZ=0;
float angle=3.14/2.0;

-(UIImage*) applyRectRotation:(UIImage*) image{
    @autoreleasepool {
        
        CGImageRef cgImage = image.CGImage;
        CIImage *ciImage = [CIImage imageWithCGImage:cgImage];
        
        int w = ciImage.extent.size.width;
        int h = ciImage.extent.size.height;
        
        CIFilter *filter;
        CIContext *context = [CIContext contextWithOptions:nil];

        filter = [CIFilter filterWithName:@"rectRotation2"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:@(isX) forKey:@"isX"];
        [filter setValue:@(isY) forKey:@"isY"];
        [filter setValue:@(isZ) forKey:@"isZ"];
        [filter setValue:@(angle) forKey:@"angle"];
        ciImage = filter.outputImage;
        
        cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0,w, h)];
        image = [UIImage imageWithCGImage: cgImage];
        
        CGImageRelease(cgImage);
        
        return image;
    }
}

@end
