//
//  ViewController.h
//  photoSphereRotation
//
//  Created by Tom Tong on 25/12/2016.
//  Copyright © 2016 Tom Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customFilter.h"

@import Photos;
@import AssetsLibrary;

@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UISlider *xSlider,*ySlider,*zSlider;
}

@end

