# equirectangular-image-rotation
objective-c template for inserting spatial media metadata into video with iPhone app

#### Original image
![screenshot](./Screenshot/input.jpeg)

#### After pitch,ywa,roll rotation
![screenshot](./Screenshot/output.jpeg)

The method used
```  objc
-(NSURL *) insertMetadataWithMovie:(NSURL*)inputPath;
```

The callback method
```  objc
-(void)callbackAfterMetadataInserted:(NSNotification *)note
```  

### my contact email tomtomtongtong@gmail.com






