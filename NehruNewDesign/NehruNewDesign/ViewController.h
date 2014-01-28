//
//  ViewController.h
//  NehruNewDesign
//
//  Created by Raj on 20/01/14.
//  Copyright (c) 2014 Raj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProduct.h"
#import "CartViewController.h"

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    CGSize iOSDeviceScreenSize;
    NSMutableArray *MArrMainItems;
    IBOutlet UIImageView *MImgMoreImages;
    IBOutlet UIView *MViewUpper;
    IBOutlet UIView *MViewLower;
    IBOutlet UIView *MViewHolder;
    BOOL isClicked;
    BOOL isFirstViewController;
    IBOutlet UIView *MViewTextDialog;
    IBOutlet UILabel *MLblTextDialog;
    NSTimer *_MTimer;
    IBOutlet UIImageView *MImgButtonBackground;
    IBOutlet UIButton *MBtnCasual;
    IBOutlet UIButton *MBtnFormal;
    IBOutlet UIButton *MBtnCancelImgView;
    IBOutlet UIView *MViewMoreImages;
    int swiped;
    
    //Related to product details
    IBOutlet UILabel *lblpriceOfProduct;
    IBOutlet UILabel *lblproductName;
    IBOutlet UILabel *lblProductQuantity;
//    IBOutlet UIButton *
    IBOutlet UILabel *lblcategory;
    IBOutlet UILabel *lblqty;
    BOOL isSize;
    BOOL isColour;
    IBOutlet UIButton *btnSize;
    IBOutlet UIButton *btnColor;
    
    IBOutlet UILabel *lblColor;
    IBOutlet UILabel *lblSize;
    
    IBOutlet UITextView *txtViewdescription;
    
    NSMutableArray *mArrColors;
    NSMutableArray *mArrSizes;
    
    NSMutableArray *ArrProductSizeIds;
    NSMutableArray *ArrProductColorIds;

    IBOutlet UITableView *mTblColors;
    IBOutlet UITableView *mTblSizes;
    
    IBOutlet UIView *mViewColor;
    IBOutlet UIView *mViewSize;
    IBOutlet UIActivityIndicatorView *activityViewCart;
    IBOutlet UIButton *mBtnInCart;
    IBOutlet UIActivityIndicatorView *activity1;
    BOOL loadCasual;
//
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic,strong) NSMutableArray *cartArray;
@property(nonatomic,strong) NSMutableArray *productArrayInCart;
@property(nonatomic,strong)NSMutableArray *arrayOfAllproducts;
@property(nonatomic,strong)NSMutableArray *arrformalproducts;
@property(nonatomic,strong)NSMutableArray *pageImages;
@property(nonatomic,strong)NSMutableArray *arrImages;
@property(nonatomic,strong)DataProduct *dataproduct;
@property(nonatomic,strong) IBOutlet UICollectionView *MMainCollectionView;
@property(nonatomic,strong) IBOutlet UICollectionView *MFormalCollectionView;
-(IBAction)ClickedFormal:(id)sender;
-(IBAction)ClickedCasual:(id)sender;
-(IBAction)ClickedShowMoreImages:(id)sender;
-(IBAction)ClickedCancelMoreImages:(id)sender;
-(IBAction)clickedShowCart:(id)sender;
-(IBAction)ClickedSelectSize:(id)sender;
-(IBAction)ClickedSelectColor:(id)sender;
-(IBAction)ClickedIncreaseQty:(id)sender;
-(IBAction)ClickedDecreaseQty:(id)sender;
-(IBAction)CartProducts:(id)sender;
-(void)GetProducts;
@end
