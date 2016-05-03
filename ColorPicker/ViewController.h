//
//  ViewController.h
//  ColorPicker
//
//  Created by Atsuya Sato on 2014/08/24.
//  Copyright (c) 2014年 Atsuya Sato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImageView* imageView;
    UIProgressView* progressView;
    UISlider* Rslider;
    UISlider* Gslider;
    UISlider* Bslider;
    UIImage* MainImage;
  }

@end
