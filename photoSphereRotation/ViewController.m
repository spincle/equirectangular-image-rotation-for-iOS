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
UIImage* inputImg;
- (void)viewDidLoad {
    [super viewDidLoad];
    imageUrl = [[NSBundle mainBundle] URLForResource:@"sphere" withExtension:@"jpg"];
    inputImg=[[UIImage alloc] initWithContentsOfFile:[imageUrl path]];
    inputImg=[self applyRectRotation:inputImg];

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
    
    UIButton* loadImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loadImageBtn setBackgroundImage:[UIImage imageNamed: @"loadImgBtn.png"]forState:UIControlStateNormal];
    loadImageBtn.frame=CGRectMake(5,5,70,50);
    [loadImageBtn addTarget:self
                    action:@selector(loadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadImageBtn];
    
    UIButton* saveImgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveImgBtn setBackgroundImage:[UIImage imageNamed: @"save.png"]forState:UIControlStateNormal];
    saveImgBtn.frame=CGRectMake(w-65,h-55,60,50);
    [saveImgBtn addTarget:self
                     action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveImgBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xSliderValueChange:(UISlider *) slider{
   // NSLog(@"value: %f",slider.value);
    roll=slider.value;
    UIImage* outputImg=[self applyRectRotation:inputImg];
    [imgView setImage:outputImg];
    
}

- (void)ySliderValueChange:(UISlider *) slider{
    yaw=slider.value;
    UIImage* outputImg=[self applyRectRotation:inputImg];
    [imgView setImage:outputImg];
}

- (void)zSliderValueChange:(UISlider *) slider{
    pitch=slider.value;
    UIImage* outputImg=[self applyRectRotation:inputImg];
    [imgView setImage:outputImg];
}

float roll;
float yaw;
float pitch;
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
        [filter setValue:@(roll) forKey:@"roll"];
        [filter setValue:@(yaw) forKey:@"yaw"];
        [filter setValue:@(pitch) forKey:@"pitch"];;
        ciImage = filter.outputImage;
        
        cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0,w, h)];
        image = [UIImage imageWithCGImage: cgImage];
        
        CGImageRelease(cgImage);
        
        return image;
    }
}

UIImagePickerController *imagePicker;
- (IBAction)loadImage:(id)sender {
       imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }

-(IBAction)saveImage:(id)sender {
    UIImage* outputImg=[self applyRectRotation:inputImg];
    [imgView setImage:outputImg];
    NSMutableDictionary* metadata=[[NSMutableDictionary alloc] init];
    [metadata setObject:@"RICOH" forKey:(NSString*)kCGImagePropertyExifLensMake];
    [metadata setObject:@"RICOH THETA S" forKey:(NSString*)kCGImagePropertyExifLensModel];

    NSData* imgData=[self addMetaData:outputImg];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filePath=[NSString stringWithFormat:@"%@/sample.jpg",paths[0]];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    [imgData writeToFile:filePath atomically:YES];
    NSURL* imgURL=[NSURL fileURLWithPath:filePath];
    [self saveToAlbum:imgURL toAlbum:@"Photo360" withCompletionBlock:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    inputImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* outputImg=[self applyRectRotation:inputImg];
    [imgView setImage:outputImg];
    
}

-(NSData *)addMetaData:(UIImage *)image {
    ExifContainer *container = [[ExifContainer alloc] init];
    [container addMakeInfo:@"RICOH"];
    [container addModelInfo:@"RICOH THETA S"];
    NSData *imgData = [image addExif:container];
    return imgData;
}

- (void)saveToAlbum:(NSURL*)imageURL toAlbum:(NSString*)album withCompletionBlock:(void(^)(NSError *error))block
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder" message:@"Add photo accessing permission in setting" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSMutableArray* assets = [[NSMutableArray alloc]init];
            PHAssetChangeRequest* assetRequest;
            @autoreleasepool {
                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageURL];
                [assets addObject:assetRequest.placeholderForCreatedAsset];
            }
            __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
            PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PHAssetCollection* collection = (PHAssetCollection*)obj;
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                    if ([[collection localizedTitle] isEqualToString:album]) {
                        assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                        [assetCollectionRequest addAssets:assets];
                        *stop = YES;
                    }
                }
            }];
            if (assetCollectionRequest == nil) {
                assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album];
                [assetCollectionRequest addAssets:assets];
            }
        }
                                          completionHandler:^(BOOL success, NSError *error) {
                                              if (block) {
                                                  block(error);
                                              }
                                          }];
    }
}

@end
