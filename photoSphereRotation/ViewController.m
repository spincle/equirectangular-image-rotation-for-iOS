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

float pi=3.141592654;
NSURL* imageUrl;
UIImageView* imgView;
- (void)viewDidLoad {
    [super viewDidLoad];
    imageUrl = [[NSBundle mainBundle] URLForResource:@"sphere" withExtension:@"jpg"];
    UIImage* inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];
//    UIImageWriteToSavedPhotosAlbum(inputImg,
//                                 nil,nil,nil);
    imgView=[[UIImageView alloc] init];
    float w=self.view.frame.size.width;
    float h=self.view.frame.size.height;
    imgView.frame=CGRectMake(0,0,w,h*0.5);
    [imgView setImage:inputImg];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgView];
    
    UISlider* xSlider = [[UISlider alloc]initWithFrame:CGRectMake(w*0.05, h*0.6, w*0.9, 30)];
    xSlider.maximumValue = 2*pi;
    xSlider.minimumValue = 0;
    xSlider.value=0;
    [xSlider addTarget:self action:@selector(xSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: xSlider];
    
    UISlider* ySlider = [[UISlider alloc]initWithFrame:CGRectMake(w*0.05, h*0.7, w*0.9, 30)];
    ySlider.maximumValue = 2*pi;
    ySlider.minimumValue = 0;
    ySlider.value=0;
    [ySlider addTarget:self action:@selector(ySliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: ySlider];
    
    UISlider* zSlider = [[UISlider alloc]initWithFrame:CGRectMake(w*0.05, h*0.8, w*0.9, 30)];
    zSlider.maximumValue = 2*pi;
    zSlider.minimumValue = 0;
    zSlider.value=0;
    [zSlider addTarget:self action:@selector(zSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: zSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xSliderValueChange:(UISlider *) slider{
   // NSLog(@"value: %f",slider.value);
    isX=1;isY=0;isZ=0;
    angle=slider.value;
    UIImage* inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];
    [imgView setImage:inputImg];
}

- (void)ySliderValueChange:(UISlider *) slider{
    isX=0;isY=1;isZ=0;
    angle=slider.value;
    UIImage* inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];
    [imgView setImage:inputImg];
}

- (void)zSliderValueChange:(UISlider *) slider{
    isX=0;isY=0;isZ=1;
    angle=slider.value;
    UIImage* inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];
    [imgView setImage:inputImg];
}

float isX=1;
float isY=0;
float isZ=0;
float angle=0;

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
