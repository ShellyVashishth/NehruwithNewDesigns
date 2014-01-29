//
//  CartViewController.m
//  NehruNewDesign
//
//  Created by Raj on 22/01/14.
//  Copyright (c) 2014 Raj. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController
@synthesize MScrollView,cartArray;

#pragma UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView;
    
    iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

    isTapped=NO;
//    txtviewdesc.textColor=[UIColor whiteColor];
//
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
//                                                          initWithTarget:self
//                                                          action:@selector(handleSingleTap:)];
//    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [MTapDialogView setHidden:NO];
}

#pragma UICollectionViewDelegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView :(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSLog(@"Cart aray count %@",self.cartArray);
    return [self.cartArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row==0) {
            identifier = @"Cell0";
        }
        self.dataproduct=[self.cartArray objectAtIndex:indexPath.row];
//        NSLog(@"data product name %@",self.dataproduct.ProductName);
        MainItemsCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    NSLog(@"Data product image %@",self.dataproduct.imgproduct);
    if(self.dataproduct.imgproduct)
    {
        cell.MImageItem.image = self.dataproduct.imgproduct;
    }
    else
    {
        cell.MImageItem.image=[UIImage imageNamed:@"imgnotavailable.jpg"];
    }
        return cell;
}

-(void)collectionView : (UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndexPath=indexPath;
    
    self.dataproduct=[self.cartArray objectAtIndex:selectedIndexPath.row];
    if (isTapped!=YES) {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
        
        MViewLower.frame =CGRectMake(0 , 1200,320 , 274);
        MViewUpper.frame = CGRectMake(0 ,-200 , 320, 85);
        [UIView commitAnimations];
        isTapped=YES;
        
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
        if (iOSDeviceScreenSize.height == 480)
        {
            MViewLower.frame =CGRectMake(0 ,170 ,320 , 274);
        }
        else if(iOSDeviceScreenSize.height==568)
        {
            MViewLower.frame =CGRectMake(0 ,254 ,320 , 274);
        }
        
        MViewUpper.frame = CGRectMake(0 ,0 , 320, 85);
        [UIView commitAnimations];
        isTapped=NO;
        [self LoadDataInViews];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
    
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 274);
        MViewUpper.frame = CGRectMake(0 ,-200 , 320, 85);
        [UIView commitAnimations];
        isTapped=NO;
}

-(void)LoadDataInViews
{
    self.dataproduct=[self.cartArray objectAtIndex:selectedIndexPath.row];
    lblcolor.text=[NSString stringWithFormat:@"%@",self.dataproduct.productColor];
    lblname.text=[NSString stringWithFormat:@"%@",self.dataproduct.ProductName];
    lblquantity.text=[NSString stringWithFormat:@"%d",self.dataproduct.productreqQuantity];
    lblsize.text=[NSString stringWithFormat:@"%@",self.dataproduct.productSize];
    txtviewdesc.text=[NSString stringWithFormat:@"%@",self.dataproduct.productDescription];
}

-(IBAction)ClickedBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [MTapDialogView setHidden:NO];
    if (!_MTimer) {
        
        _MTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(ShowTapDialogView) userInfo:Nil repeats:NO];
        _MTimer=Nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    
    if (isTapped!=YES) {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
        
        MViewLower.frame =CGRectMake(0 , 1200,320 , 274);
        MViewUpper.frame = CGRectMake(0 ,-200 , 320, 85);
        [UIView commitAnimations];
        isTapped=YES;
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
        if (iOSDeviceScreenSize.height == 480)
        {
             MViewLower.frame =CGRectMake(0 ,170 ,320 , 274);
        }
        else if(iOSDeviceScreenSize.height==568)
        {
             MViewLower.frame =CGRectMake(0 ,254 ,320 , 274);
        }
       
        MViewUpper.frame = CGRectMake(0 ,0 , 320, 85);
        [UIView commitAnimations];
        isTapped=NO;
    }
}

-(void)ShowTapDialogView {
    [MTapDialogView setHidden:YES];
}

@end
