//
//  CartViewController.h
//  NehruNewDesign
//
//  Created by Raj on 22/01/14.
//  Copyright (c) 2014 Raj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainItemsCell.h"
#import "DataProduct.h"

@interface CartViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
   IBOutlet UIScrollView *MScrollView;
    IBOutlet UIView *MViewUpper;
    IBOutlet UIView *MViewLower;
    BOOL isTapped;
    NSTimer *_MTimer;
    IBOutlet UIView *MTapDialogView;
    IBOutlet UIView *MainView;
    CGSize iOSDeviceScreenSize;
//  BOOL isClicked;
    IBOutlet UICollectionView *collectionView;
    NSIndexPath *selectedIndexPath;

    IBOutlet UIButton *btnstripe;
    IBOutlet UIButton *btnpayment;
    IBOutlet UILabel *lblname;
    IBOutlet UILabel *lblcolor;
    IBOutlet UILabel *lblsize;
    IBOutlet UILabel *lblquantity;
    IBOutlet UITextView *txtviewdesc;
    
}
@property (nonatomic,strong) IBOutlet UIScrollView *MScrollView;
@property(nonatomic,strong)NSMutableArray *cartArray;
@property(nonatomic,strong)DataProduct *dataproduct;
@end
