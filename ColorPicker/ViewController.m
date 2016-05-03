//
//  ViewController.m
//  ColorPicker
//
//  Created by Atsuya Sato on 2014/08/24.
//  Copyright (c) 2014年 Atsuya Sato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MainImage = [UIImage imageNamed:@"5801566.jpg"];
    Rslider = [[UISlider alloc]initWithFrame:CGRectMake(10, 470, 300, 10)];
    Gslider = [[UISlider alloc]initWithFrame:CGRectMake(10, 500, 300, 10)];
    Bslider = [[UISlider alloc]initWithFrame:CGRectMake(10, 530, 300, 10)];
    Rslider.tintColor = [UIColor redColor];
    Gslider.tintColor = [UIColor greenColor];
    Bslider.tintColor = [UIColor blueColor];
    Rslider.maximumValue = 255;
    Gslider.maximumValue = 255;
    Bslider.maximumValue = 255;
    Rslider.minimumValue = 0;
    Gslider.minimumValue = 0;
    Bslider.minimumValue = 0;
    
    Rslider.value = 126;
    Gslider.value = 126;
    Bslider.value = 126;
    
    [self.view addSubview:Rslider];
    [self.view addSubview:Gslider];
    [self.view addSubview:Bslider];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.width)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"5801566.jpg"];
    [[imageView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[imageView layer] setBorderWidth:3.0];
    [self.view addSubview:imageView];
    imageView.tag = 1;
    imageView.userInteractionEnabled = YES;
    
    UIButton* button = [[
                         UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 150);
    [[button layer] setCornerRadius:10.0];
    [button setClipsToBounds:YES];
    
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"extract" forState:UIControlStateNormal];
    [button  addTarget:self
                   action:@selector(convent:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1:
            // タグが1のビュー
            [self takephoto];
            break;
            
              default:
            break;
    }
}


-(void)takephoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image editingInfo :(NSDictionary *)editingInfo {
    NSLog(@"selected");
    imageView.image = image;
    MainImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)convent:(id)sender{
    UIImage* image = MainImage;
         // CGImageを取得する
     CGImageRef  imageRef = image.CGImage;
     // ビットマップデータを取得する
     CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    
    UInt8* buffer = (UInt8*)CFDataGetBytePtr(dataRef);
     
     size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
     
     size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
     UInt8* pixel = (UInt8*)CFDataGetBytePtr(dataRef);
    
    
    int PixelData[(int)image.size.width][(int)image.size.height];
    
    int EdgeData[(int)image.size.width][(int)image.size.height];
  
    
    for (int x=0; x < (int)image.size.width; x++) {
         for (int y=0; y<(int)image.size.height; y++) {
             //   progressView.progress = (float)(x / image.size.width);
         
             UInt8*  pixelPtr = buffer + (int)(y) * bytesPerRow + (int)(x) * 4;
         
            UInt8 r = *(pixelPtr + 2);  // 赤
             UInt8 g = *(pixelPtr + 1);  // 緑
             UInt8 b = *(pixelPtr + 0);  // 青
             
             EdgeData[x][y] = 0;
             if(r > Rslider.value && g > Gslider.value && b > Bslider.value){
                PixelData[x][y] = 0;
                     *(pixelPtr + 2) = 0;
                     *(pixelPtr + 1) = 0;
                     *(pixelPtr + 0) = 0;
             }else{
                PixelData[x][y] = 1;
                 *(pixelPtr + 2) = 255;
                 *(pixelPtr + 1) = 255;
                 *(pixelPtr + 0) = 255;
             }
         }
     }
    
    int num = 1;
    Boolean flg2 = false;
    for (int y=0; y<image.size.height; y++) {
        for (int x=0; x<image.size.width; x++) {
            //ピクセル　白なら
            if(PixelData[x][y] == 1){
                //走査順準備
                //  int find[8][2] = {{-1,1},{0,1},{1,1},{1,0},{1,-1},{0,-1},{-1,-1},{-1,0}};
                int find[8][2] ={{ 1, 0 }, { 1, -1 }, { 0, -1 }, { -1, -1 },
                    { -1, 0 }, {-1, 1 }, { 0, 1 }, { 1, 1 }};
                
                //次の探索開始findの配列開始位置準備
                //   int next_code[8] = {0,0,0,2,2,4,4,6};
                int next_code[8] = { 7, 7, 1, 1, 3, 3, 5, 5 };
               
                int x3 = x;
                int y3 = y;
                int count = 0;
                for(int s = 0;s < 8; s++){
                    if(PixelData[x3 + find[s][0]][y3 + find[s][1]] == 1){
                        count++;
                    }
                }
                if(count == 8){
                    continue;
                }
                //走査開始位置
                int number = 0;
                int i = number;
                
                int x2 = x;
                int y2 = y;
                Boolean flg = true;
                
                int cnt2 = 0;
                //メインループ
                
                //エッジデータ[x][y]に振り番
                EdgeData[x][y] = num;
                
                //振り番号++
                num++;
                            while(flg){
                    if(PixelData[x2 + find[i][0]][y2 + find[i][1]] == 1 &&  EdgeData[x2 + find[i][0]][y2+ find[i][1]] == 0){
                        int x3 = x2 + find[i][0];
                        int y3 = y2 + find[i][1];
                        int count = 0;
                        for(int s = 0;s < 8; s++){
                            if(PixelData[x3 + find[s][0]][y3 + find[s][1]] == 1){
                                count++;
                            }
                        }
                        if(count != 8){
                       //エッジデータ[x + find[i][0]][y+ find[i][1]]に振り番
                       EdgeData[x2 + find[i][0]][y2+ find[i][1]] = num;
                        //次の走査開始番号
                        number = next_code[i];
                        //振り番++;
                        num++;
                        //次の基準位置
                        x2 = x2 + find[i][0];
                        y2 = y2 + find[i][1];
                        
                        i = number;
                        i--;
                        }
                        
                    }
                    i++;
                    if(i > 7){
                        i = 0;
                        cnt2++;
                    }
                    //見つけた
                    if(cnt2 > 100 && EdgeData[x2 + find[i][0]][y2+ find[i][1]] == 1){
                        flg2 = true;
                        flg = false;
                        break;
                    }
                    if(cnt2 > 100){
                        break;
                    }
                }
                
            }
            if(flg2){
                break;
            }
        }
        if(flg2){
            break;
        }
    }
    
    for (int x=0; x<image.size.width; x++) {
        for (int y=0; y<image.size.height; y++) {
            //   progressView.progress = (float)(x / image.size.width);
            
            UInt8*  pixelPtr = buffer + (int)(y) * bytesPerRow + (int)(x) * 4;
            
            if(EdgeData[x][y] == 0){
                *(pixelPtr + 2) = 255;
                *(pixelPtr + 1) = 255;
                *(pixelPtr + 0) = 255;
            }else{
                *(pixelPtr + 2) = 255;
                *(pixelPtr + 1) = 0;
                *(pixelPtr + 0) = 0;
            }
            /*
            if(EdgeData[x][y] != 0){
                *(pixelPtr + 2) = 255;
                *(pixelPtr + 1) = 0;
                *(pixelPtr + 0) = 0;
            }
             */
        }
    }
    
     CFDataRef dst = CFDataCreate(NULL, pixel, CFDataGetLength(dataRef));
     CGDataProviderRef dstDataProvider = CGDataProviderCreateWithCFData(dst);
     CGImageRef dstCGImage = CGImageCreate(image.size.width, image.size.height, CGImageGetBitsPerComponent(imageRef),
     bitsPerPixel, bytesPerRow,CGImageGetColorSpace(imageRef),
     CGImageGetBitmapInfo(imageRef),dstDataProvider, NULL,
     CGImageGetShouldInterpolate(imageRef),CGImageGetRenderingIntent(imageRef));
     UIImage *dstUIImage = [UIImage imageWithCGImage:dstCGImage];
     
     CGImageRelease(dstCGImage);
     CFRelease(dst);
     CFRelease(dataRef);
     CFRelease(dstDataProvider);
    NSLog(@"end");
    imageView.image = dstUIImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
