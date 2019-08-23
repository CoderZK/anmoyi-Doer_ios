//
//  define.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#ifndef define_h
#define define_h


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define BTN_COLOR [UIColor colorWithRed:219.0/255.0f green:201.0/255.0 blue:179.0/255.0 alpha:1.0f]

#define CELL_TEXT_COLOR [UIColor colorWithRed:207.0/255.0f green:164.0/255.0 blue:113.0/255.0 alpha:1.0f]

#define CELL_TEXT_COLOR [UIColor whiteColor]

//#define NamePoolArray @[@"cndoer-01",@"cndoer-02",@"cndoer-03"]
#define NamePoolArray @[@"BlueNRG1",@"doer-01",@"doer-02",@"doer-03", @"doer-04", @"doer-05", @"doer-06", @"doer-07"]

#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]

#define NORMAL_UNSELECT_BUTTON_BG [[UIImage imageNamed:@"UnSelecBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(23.5, (SCREEN_WIDTH - 40)/2, 23.5, (SCREEN_WIDTH - 40)/2)]
#define NORMAL_SELECT_BUTTON_BG [[UIImage imageNamed:@"SelecBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(23.5, (SCREEN_WIDTH - 40)/2, 23.5, (SCREEN_WIDTH - 40)/2)]

#endif /* define_h */
