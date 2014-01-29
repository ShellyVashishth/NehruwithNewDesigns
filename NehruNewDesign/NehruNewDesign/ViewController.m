//
//  ViewController.m
//  NehruNewDesign
//
//  Created by Raj on 20/01/14.
//  Copyright (c) 2014 Raj. All rights reserved.
//

#import "ViewController.h"
#import "MainItemsCell.h"


@interface ViewController ()
{
    MainItemsCell  *MainCell;
}
@end

@implementation ViewController
@synthesize MMainCollectionView,dataproduct,arrayOfAllproducts,arrformalproducts,productArrayInCart,MFormalCollectionView;

@synthesize scrollView;
@synthesize pageControl;
@synthesize pageImages;
@synthesize arrImages;
@synthesize cartArray;

#pragma UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    isClicked =NO;
    self.cartArray=[[NSMutableArray alloc]init];
    swiped=0;
    [MViewTextDialog setHidden:YES];
    isFirstViewController = YES;
    MBtnCasual.titleLabel.textColor = [UIColor blackColor];
    MBtnFormal.titleLabel.textColor=[UIColor whiteColor];

        UISwipeGestureRecognizer *UpSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
        UpSwipeGesture.numberOfTouchesRequired = 1;
        UpSwipeGesture.direction = (UISwipeGestureRecognizerDirectionUp);
        
        [MViewHolder addGestureRecognizer:UpSwipeGesture];

        UISwipeGestureRecognizer *DownSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
        DownSwipeGesture.numberOfTouchesRequired = 1;
        DownSwipeGesture.direction = (UISwipeGestureRecognizerDirectionDown);
        
        [MViewHolder addGestureRecognizer:DownSwipeGesture];
        

    MArrMainItems = [[NSMutableArray alloc]initWithObjects:@"b2.jpg",@"b3.jpg",@"b4.jpg",@"b5.jpg",@"b6.jpg",@"b9.png",@"b12.jpg",@"b13.jpg",@"b14.jpg",@"b15.jpg",@"b16.jpg",@"b17.jpg",@"b18.jpg", nil];
    self.navigationItem.title = @"Nehru Jackets";
    
    //setting the logo in middle.
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView1;
    
    self.dataproduct.productColor=@"";
    self.dataproduct.productSize=@"";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    isSize=NO;
    isColour=NO;
    [mTblColors setHidden:YES];
    [mTblSizes setHidden:YES];
    [mViewColor setHidden:YES];
    [mViewSize setHidden:YES];
//    [activityViewCart setHidden:YES];
    self.dataproduct.productreqQuantity=1;
  
    [self GetProducts];
    [self GetAllProductSizeAvailable];
}

-(void)LoadImages
{
    self.pageImages=[[NSMutableArray alloc]init];
    self.arrImages=[[NSMutableArray alloc]init];
    self.pageImages=self.dataproduct.productImages;
//    NSLog(@"Arr images %@",self.pageImages);
    for(int i=0;i<[self.pageImages count];i++)
    {
        PFFile *theImage =(PFFile*)[self.pageImages objectAtIndex:i];
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            [self.arrImages addObject:image];
            
            if(i==5)
            {
//                NSLog(@"Arr Images name %@",self.arrImages);
                [self loadINArray];
            }
        }];
    }
}

-(void)loadINArray
{
    //page controller for the more images
    for (int i = 0; i < [self.arrImages count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [self.arrImages objectAtIndex:i];
        [self.scrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.arrImages count], scrollView.frame.size.height);
}

-(void)GetAllProductSizeAvailable
{
//    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    mArrSizes=[[NSMutableArray alloc]init];
    ArrProductSizeIds =[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductSize"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects.
            for (PFObject *object in objects) {
                
                NSString *productSizeName=object[@"ProductSize"];
                NSString *productSizeId=object.objectId;
                
//                NSLog(@"ProductSize Name %@",productSizeName);
//                NSLog(@"Product Size id %@",productSizeId);
                //getting the category Name and Object Id's.
                [mArrSizes addObject:productSizeName];
                [ArrProductSizeIds addObject:productSizeId];
//                NSLog(@"Arr product Sizes %@",mArrSizes);
//                NSLog(@"Arr Product Size Ids %@",ArrProductSizeIds);
            }
            [self GetAllProductColorAvailable];
            [mTblSizes reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)GetAllProductColorAvailable
{
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    mArrColors=[[NSMutableArray alloc]init];
    ArrProductColorIds=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductColor"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                NSString *productColorName=object[@"ProductColor"];
                NSString *productColorId=object.objectId;
                
                [mArrColors addObject:productColorName];
                [ArrProductColorIds addObject:productColorId];
//                NSLog(@"Arr product colors %@",mArrColors);
//                NSLog(@"Arr product Color Ids %@",ArrProductColorIds);
            }
            [mTblColors reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    MBtnCasual.titleLabel.textColor = [UIColor blackColor];
    MBtnFormal.titleLabel.textColor=[UIColor whiteColor];
}

//getting all the products from the parse Database.
-(void)GetProducts
{
    [activity1 setHidden:NO];
    [activity1 startAnimating];
//    self.view.userInteractionEnabled=NO;
    self.arrayOfAllproducts=[[NSMutableArray alloc]init];
    self.arrformalproducts=[[NSMutableArray alloc]init];
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct1=[[DataProduct alloc]init];
                dataproduct1.ProductId=object.objectId;
                dataproduct1.ProductImage=object[@"productImage"];
                
                PFFile *theImage =(PFFile*)dataproduct1.ProductImage;
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    UIImage *image = [UIImage imageWithData:data];
                    dataproduct1.imgproduct=image;
                }];
                dataproduct1.ProductName=object[@"productName"];
                dataproduct1.ProductModel=object[@"productModel"];
                NSString *strproductQty=object[@"productQty"];
                NSString *strProductPrice=object[@"productPrice"];
                dataproduct1.productImages=object[@"ProductImages"];
                dataproduct1.isfavorite=object[@"isfavorite"];
                dataproduct1.productDescription=object[@"ProductDescription"];
                NSLog(@"Data product favorite %@",dataproduct1.isfavorite);
                dataproduct1.productquantity=[strproductQty integerValue];
                dataproduct1.productUnitprice=[strProductPrice floatValue];
                dataproduct1.CategoryId=object[@"categoryid"];
                dataproduct1.productreqQuantity=1;
                if([dataproduct1.CategoryId isEqualToString:@"AEE5blnumJ"])
                {
                    [self.arrayOfAllproducts addObject:dataproduct1];
                }
                else
                {
                    [self.arrformalproducts addObject:dataproduct1];
                }
            }
            loadCasual=YES;
            [MMainCollectionView reloadData];
//            [MFormalCollectionView reloadData];
//            [activity1 stopAnimating];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self CartProducts];
}

#pragma Action for selecting Colors and Sizes
-(IBAction)ClickedSelectSize:(id)sender
{
    if(isSize)
    {
        isSize=NO;
        [mViewSize setHidden:YES];
        [mTblSizes setHidden:YES];
        
        if(isColour)
        {
            isColour=NO;
            [mViewColor setHidden:YES];
            [mTblColors setHidden:YES];
            
        }
    }
    else if(!isSize)
    {
        isSize=YES;
        [mTblSizes setHidden:NO];
        [mViewSize setHidden:NO];
        if(isColour)
        {
            isColour=NO;
            [mViewColor setHidden:YES];
            [mTblColors setHidden:YES];
    
        }
    }
    [mTblSizes reloadData];
}

-(IBAction)ClickedSelectColor:(id)sender
{
    if(isColour)
    {
        isColour=NO;
        [mViewColor setHidden:YES];
        [mTblColors setHidden:YES];
        if(isSize)
        {
            isSize=NO;
            [mViewSize setHidden:YES];
            [mTblSizes setHidden:YES];
        }
    }
    else if(!isColour)
    {
        isColour=YES;
        [mViewColor setHidden:NO];
        [mTblColors setHidden:NO];
        if(isSize)
        {
            isSize=NO;
            [mViewSize setHidden:YES];
            [mTblSizes setHidden:YES];
        }
    }
    [mTblColors reloadData];
}

-(IBAction)ClickedIncreaseQty:(id)sender
{
    NSInteger prodQty=self.dataproduct.productquantity;
    NSString *availableQty=[NSString stringWithFormat:@"%@",lblqty.text];
    
    NSInteger qtyupdated=[availableQty integerValue];
    qtyupdated= qtyupdated+1;
    
    if(qtyupdated>prodQty)
    {
        qtyupdated=qtyupdated-1;
    }
    lblqty.text=[NSString stringWithFormat:@"%d",qtyupdated];
    self.dataproduct.productreqQuantity=qtyupdated;
}

-(IBAction)ClickedDecreaseQty:(id)sender
{
    NSString *availableQty=[NSString stringWithFormat:@"%@",lblqty.text];
    
    NSInteger qtyupdated=[availableQty integerValue];
    qtyupdated=qtyupdated-1;
    
    if(qtyupdated<1)
    {
        qtyupdated=qtyupdated+1;
    }
    lblqty.text=[NSString stringWithFormat:@"%d",qtyupdated];
    self.dataproduct.productreqQuantity=qtyupdated;
}



# pragma TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isColour )
    {
        return [mArrColors count];
    }
    else if(isSize)
    {
        return [mArrSizes count];
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    NSString *Identifier=@"Identifier";
    cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    //dataproduct=[self.arrayOfAllproducts objectAtIndex:indexPath.row];
    if(isColour)
    {
        cell.textLabel.text=[mArrColors objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"Calibri" size:12.0f];
//        cell.textLabel.textColor = [UIColor colorWithRed:211.0f/256.0f green:45.0f/256.0f blue:0.0f/256.0f alpha:1.0];
        cell.textLabel.textColor=[UIColor lightGrayColor];
        //            [cell addSubview:Tlblcolor];
    }
    
    else if(isSize)
    {
        cell.textLabel.text=[mArrSizes objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"Calibri" size:12.0f];
//        cell.textLabel.textColor = [UIColor colorWithRed:211.0f/256.0f green:45.0f/256.0f blue:0.0f/256.0f alpha:1.0];
        cell.textLabel.textColor=[UIColor lightGrayColor];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mViewColor setHidden:YES];
    [mViewSize setHidden:YES];
    
    if(isColour)
    {
        lblColor.text=[mArrColors objectAtIndex:indexPath.row];
        self.dataproduct.productColor=lblColor.text;
        self.dataproduct.productColorId=[ArrProductColorIds objectAtIndex:indexPath.row];
        NSLog(@"Data product color id %@",self.dataproduct.productColorId);
    }
    else
    {
        lblSize.text=[mArrSizes objectAtIndex:indexPath.row];
        self.dataproduct.productSize= lblSize.text;
        self.dataproduct.productSizeId=[ArrProductSizeIds objectAtIndex:indexPath.row];
        NSLog(@"Data product Size Id %@",self.dataproduct.productSizeId);
    }
}


#pragma UICollectionViewDelegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
    
}



-(NSInteger)collectionView :(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(loadCasual)
        
    {
        
        return [self.arrayOfAllproducts count];
        
    }
    
    else if(!loadCasual)
        
    {
        
        return [self.arrformalproducts count];
        
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    MainItemsCell *cell;
    if(loadCasual)
    {
        if (indexPath.row==0) {
            identifier = @"Cell0";
        }
       self.dataproduct=[self.arrayOfAllproducts objectAtIndex:indexPath.row];
        NSLog(@"data product name %@",self.dataproduct.ProductName);
        MainItemsCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSLog(@"Data product image %@",self.dataproduct.imgproduct);
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
    else if(!loadCasual)
    {
        if (indexPath.row==0) {
            identifier = @"Cell0";
        }
        self.dataproduct=[self.arrformalproducts objectAtIndex:indexPath.row];
         NSLog(@"data product name %@",dataproduct.ProductName);
         NSLog(@"Data product image %@",dataproduct.imgproduct);
        MainItemsCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
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
    return cell;
}

-(void)collectionView : (UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    [MArrMainItems objectAtIndex:indexPath.row];
    
    NSIndexPath *selectedIndexPath=indexPath;
   
    
    if (isClicked) {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
                    [UIView setAnimationRepeatCount:1];   // 1 time
        //[UIView setAnimationRepeatAutoreverses:YES];
        
        if (iOSDeviceScreenSize.height == 480)
        {
            MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
        }
        else if(iOSDeviceScreenSize.height==568)
        {
            MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
        }

        
        if(loadCasual)
        {
            self.dataproduct=[self.arrayOfAllproducts objectAtIndex:selectedIndexPath.row];
            NSLog(@"Data product name %@",self.dataproduct.ProductName);
            
        }
        else if(!loadCasual)
        {
            self.dataproduct=[self.arrformalproducts objectAtIndex:selectedIndexPath.row];
            NSLog(@"Data product name %@",self.dataproduct.ProductName);
        }
        
//        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 215);
        MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
        [UIView commitAnimations];
        isClicked=NO;
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationRepeatCount:1e100f];  //coutless
        [UIView setAnimationRepeatCount:1];   // 1 time
        
//      CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            MViewLower.frame =CGRectMake(0, 222, 320 ,196);
        }
        else if(iOSDeviceScreenSize.height==568)
        {
            MViewLower.frame =CGRectMake(0, 244, 320 ,263);
        }
        MViewUpper.frame = CGRectMake(0 ,49 , 320 , 91);
        [UIView commitAnimations];
        
        if(loadCasual)
        {
            self.dataproduct=[self.arrayOfAllproducts objectAtIndex:selectedIndexPath.row];
            NSLog(@"Data product name %@",self.dataproduct.ProductName);
            
        }
        else if(!loadCasual)
        {
            self.dataproduct=[self.arrformalproducts objectAtIndex:selectedIndexPath.row];
            NSLog(@"Data product name %@",self.dataproduct.ProductName);
        }
        
        isClicked=YES;
    }

        [self LoadDataInViews];
}

-(void)LoadDataInViews
{
    lblproductName.text=self.dataproduct.ProductName;
    lblpriceOfProduct.text=[NSString stringWithFormat:@"$%0.2f",self.dataproduct.productUnitprice];
    lblProductQuantity.text=[NSString stringWithFormat:@"%d",self.dataproduct.productreqQuantity];
    lblColor.text=@"Select Color";
    lblSize.text=@"Select size";
    txtViewdescription.text=self.dataproduct.productDescription;
    if([self.dataproduct.CategoryId isEqualToString:@"ZCrNY9aF9g"])
    {
        lblcategory.text=@"Formal";
    }
    else
    {
        lblcategory.text=@"Casual";
    }
    [self LoadImages];
    [self GetAllProductsFromCart:self.dataproduct.ProductId];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationDelegate:self];
//    //[UIView setAnimationRepeatCount:1e100f];  //coutless
//    [UIView setAnimationRepeatCount:1];   // 1 time
//    //[UIView setAnimationRepeatAutoreverses:YES];
//    
//    MViewLower.frame =CGRectMake(0 ,1200 ,320 , 158);
//    MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
//    [UIView commitAnimations];
//    isClicked=NO;
}

- (void)ShowCasualView {
    
    //Remove More Images View
    
    [self CancelMoreImagesView];
    
    //Remove Detail Dialog Views
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
//    MViewLower.frame =CGRectMake(0 ,1200 ,320 , 215);
    if (iOSDeviceScreenSize.height == 480)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
    }

    MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
    [UIView commitAnimations];
    isClicked=NO;
    
    //call Casual View
    if (swiped==0) {
        swiped++;
    [MViewTextDialog setHidden:NO];
    if (!_MTimer) {
    _MTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showFormalTextView) userInfo:Nil repeats:NO];
        _MTimer=Nil;
    }
        
    }
    
    [self MoveButtonBackgroundCasuals];
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    MViewHolder.frame = CGRectMake(0, 49, 320, 1200);

    [UIView commitAnimations];

    MBtnCasual.titleLabel.textColor = [UIColor blackColor];
    MBtnFormal.titleLabel.textColor=[UIColor whiteColor];
}

- (void)ShowFormalView {
    //Remove More Images View
    [self CancelMoreImagesView];
    
    //Remove Detail Dialog Views
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    if (iOSDeviceScreenSize.height == 480)
    {
      MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
    }
    else if(iOSDeviceScreenSize.height==568)
    {
      MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
    }
     MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
    [UIView commitAnimations];
    isClicked=NO;
    
    //call FormalView
    
    if (swiped>=1) {
    [MViewTextDialog setHidden:NO];
    if (!_MTimer) {
    
    _MTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showCasualTextView) userInfo:Nil repeats:NO];
        _MTimer=Nil;
    }
        swiped--;
    }
    [self MoveButtonBackgroundFormals];
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];

    
    
    if (iOSDeviceScreenSize.height == 480)
    {
        MViewHolder.frame = CGRectMake(0, -365, 320, 1200);
        
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        MViewHolder.frame = CGRectMake(0, -430, 320, 1200);
        
    }
    [UIView commitAnimations];
    MBtnCasual.titleLabel.textColor = [UIColor whiteColor];
    MBtnFormal.titleLabel.textColor=[UIColor blackColor];
    
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer {
    loadCasual=NO;
    [MFormalCollectionView reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
 
    [self ShowFormalView];
    if (iOSDeviceScreenSize.height == 480)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
    }
    MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
    [UIView commitAnimations];
    isClicked=NO;
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer {
    loadCasual=YES;
    [MMainCollectionView reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    [self ShowCasualView];
    if (iOSDeviceScreenSize.height == 480)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
    }
    MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);
    [UIView commitAnimations];
    isClicked=NO;
}


-(void)MoveButtonBackgroundFormals {
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    MImgButtonBackground.frame = CGRectMake(192, 6, 118, 40);
    
    [UIView commitAnimations];
    MBtnCasual.titleLabel.textColor = [UIColor whiteColor];
    MBtnFormal.titleLabel.textColor=[UIColor blackColor];
}

- (void)showCasualTextView {
    [MViewTextDialog setHidden:YES];
    [MLblTextDialog setText:@"Casuals"];
}

-(void)showFormalTextView {
    [MViewTextDialog setHidden:YES];
    [MLblTextDialog setText:@"Formals"];
    
}

-(void)MoveButtonBackgroundCasuals {
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    MImgButtonBackground.frame = CGRectMake(7, 6, 118, 40);
    
    [UIView commitAnimations];
    MBtnCasual.titleLabel.textColor = [UIColor blackColor];
    MBtnFormal.titleLabel.textColor=[UIColor whiteColor];
}

-(void)ShowMoreImages {
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    MViewMoreImages.frame =CGRectMake(12, 59, 295, 357);
    
    [UIView commitAnimations];
}

-(void)CancelMoreImagesView {
    //Cancel Lower and upper view if Appear
    
//    MViewLower.frame =CGRectMake(0 ,1200 ,320 , 158);
    if (iOSDeviceScreenSize.height == 480)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 196);
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        MViewLower.frame =CGRectMake(0 ,1200 ,320 , 263);
    }
    MViewUpper.frame = CGRectMake(0 ,-200 , 320, 91);

    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    MViewMoreImages.frame =CGRectMake(12, 1200, 295, 357);
    [UIView commitAnimations];
}

#pragma IBActions

-(IBAction)ClickedFormal:(id)sender {
    MBtnCasual.titleLabel.textColor = [UIColor whiteColor];
    MBtnFormal.titleLabel.textColor=[UIColor blackColor];
    loadCasual=NO;
    [MFormalCollectionView reloadData];
    
    [self ShowFormalView];
}

-(IBAction)ClickedCasual:(id)sender {
    
    loadCasual=YES;
    [MMainCollectionView reloadData];
    [self ShowCasualView];
}

-(IBAction)ClickedShowMoreImages:(id)sender {
    [self ShowMoreImages];
}

-(IBAction)ClickedCancelMoreImages:(id)sender {
    [self CancelMoreImagesView];
}

-(IBAction)ClickedBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  Adding products to the cart.

//Saving the products into the cart.
-(IBAction)AddingProductToCartOnParse:(id)sender
{
    NSString *randomproductId=[NSString stringWithFormat:@"%@%@%@",self.dataproduct.productSizeId,self.dataproduct.productColorId,self.dataproduct.ProductId];
    NSLog(@"New RandomProductId %@",randomproductId);
    self.dataproduct.RandomProductId=randomproductId;
    if([self CheckProductQuantity])
    {
        NSUserDefaults *userdefualts=[NSUserDefaults standardUserDefaults];
        NSString *struserId= [userdefualts objectForKey:@"UserId"];
        NSLog(@"User Id %@",struserId);
        if(struserId ==NULL)
        {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Login Required" message:@"First Login to add products into cart." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];
        }
        else
            if ([lblColor.text isEqualToString:@"Select Color"]||[lblSize.text isEqualToString:@"Select Size"]) {
                if ([lblColor.text isEqualToString:@"Select Color"]&&[lblSize.text isEqualToString:@"Select Size"]) {
                    UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color and Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertColor show];
                }
                else if ([lblColor.text isEqualToString:@"Select Color"]) {
                    UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertColor show];
                }
                else if ([lblSize.text isEqualToString:@"Select Size"]) {
                    UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertColor show];
                }
            }
            else {
                PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"Cart"];
                [validLoginQuery whereKey:@"RandomProductId" equalTo:randomproductId];
                [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        if(objects.count==1){
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Product Out of stock" message:@"Product not available at store." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                            [alertview show];
                        }
                        else{
                            PFObject *usrSignUp=[PFObject objectWithClassName:@"Cart"];
                            [usrSignUp setObject:struserId forKey:@"UserId"];
                            [usrSignUp setObject:self.dataproduct.ProductId forKey:@"ProductId"];
                            [usrSignUp setObject:randomproductId forKey:@"RandomProductId"];
                            [usrSignUp setObject:self.dataproduct.ProductName forKey:@"productName"];
                            [usrSignUp setObject:self.dataproduct.ProductModel forKey:@"productModel"];
                            [usrSignUp setObject:[NSString stringWithFormat:@"%f",self.dataproduct.productUnitprice] forKey:@"ProductPrice"];
                            [usrSignUp setObject:[NSNumber numberWithInt:self.dataproduct.productquantity]  forKey:@"ProductQty"];
                            [usrSignUp setObject:self.dataproduct.CategoryId forKey:@"categoryid"];
                            [usrSignUp setObject:self.dataproduct.productDescription forKey:@"ProductDescription"];
                            [usrSignUp setObject:self.dataproduct.productImages forKey:@"ProductImages"];
                            [usrSignUp setObject:self.dataproduct.ProductImage forKey:@"ProductImage"];
                            [usrSignUp setObject:self.dataproduct.productSize forKey:@"productSize"];
                            [usrSignUp setObject:self.dataproduct.productColor forKey:@"productColor"];
                            [usrSignUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    // The find succeeded.
                                    if(succeeded){
                                        self.dataproduct.RandomProductId=randomproductId;
                                    }
                                }
                                else {
                                    // Log details of the failure
                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                    
                                }
                            }];
                        }
                    }}];
            }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Not available" message:@"Product not available on store" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

-(BOOL)CheckProductQuantity
{
    NSInteger getTotalQty=0;
    NSLog(@"Array of cart products %@",self.productArrayInCart);
    for (DataProduct* product in self.productArrayInCart) {
        NSLog(@"Data product Id %@",self.dataproduct.ProductId);
        NSLog(@"Data product Id %@",product.ProductId);
        NSLog(@"Random Product id %@",self.dataproduct.RandomProductId);
        NSLog(@"Random Product Id %@",product.RandomProductId);
        if([self.dataproduct.ProductId isEqualToString:product.ProductId])
        {
            getTotalQty=getTotalQty+product.productreqQuantity;
        }
    }
    if(getTotalQty >= self.dataproduct.productquantity)
    {
        return NO;
    }
    else {
        return YES;
    }
}

//Check the parse database to see if the productQuantity is available or not for this product.
-(void)GetAllProductsFromCart:(NSString *)productId
{
    self.productArrayInCart=[[NSMutableArray alloc]init];
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"ProductId" equalTo:productId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct1=[[DataProduct alloc]init];
                dataproduct1.ProductId=object[@"ProductId"];
                dataproduct1.RandomProductId=object[@"RandomProductId"];
                dataproduct1.ProductName=object[@"productName"];
                dataproduct1.CategoryId=object[@"categoryid"];
                dataproduct1.productSize=object[@"productSize"];
                dataproduct1.productDescription=object[@"ProductDescription"];
                dataproduct1.productColor=object[@"productColor"];
                dataproduct1.ProductModel=object[@"productModel"];
                
                NSString *reqqty=object[@"RequiredQuantity"];
                dataproduct1.productreqQuantity=[reqqty integerValue];
                NSString *strproductQty=object[@"ProductQty"];
                NSString *strProductPrice=object[@"ProductPrice"];
                dataproduct1.ProductImage=object[@"ProductImage"];
                dataproduct1.productImages=object[@"ProductImages"];
                dataproduct1.productDescription=object[@"ProductDescription"];
                dataproduct1.productquantity=[strproductQty integerValue];
                dataproduct1.productUnitprice=[strProductPrice floatValue];
                [self.productArrayInCart addObject:dataproduct1];
                
                PFFile *theImage =(PFFile*)dataproduct1.ProductImage;
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    UIImage *image = [UIImage imageWithData:data];
                    dataproduct1.imgproduct=image;
                }];
            }
            NSLog(@"Products available on the Cart table %@",self.productArrayInCart);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


-(IBAction)clickedShowCart:(id)sender
{
    if (iOSDeviceScreenSize.height == 480)
    {
        if([self.cartArray count]>0)
        {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CartViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"CartView"];
            lvc.cartArray=self.cartArray;
    //        lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lvc animated:YES];
    }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Cart Is Empty" message:@"Cart is Empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alertView show];
            alertView.tag=567890;
            
        }
    }
    else if(iOSDeviceScreenSize.height==568)
    {
        if([self.cartArray count]>0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iphone4" bundle: nil];
            CartViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"CartView"];
            lvc.cartArray=self.cartArray;
            //        lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:lvc animated:YES];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Cart Is Empty" message:@"Cart is Empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alertView show];
             alertView.tag=567892;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==567892)
    {
        if(buttonIndex ==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    else if(alertView.tag==567890)
    {
        if(buttonIndex ==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}


-(void)CartProducts
{
    NSUserDefaults *userdefualts=[NSUserDefaults standardUserDefaults];
    NSString *struserId= [userdefualts objectForKey:@"UserId"];
    if(struserId!=NULL){
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"UserId" equalTo:struserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct1=[[DataProduct alloc]init];
                dataproduct1.ProductId=object[@"ProductId"];
                dataproduct1.RandomProductId=object[@"RandomProductId"];
                dataproduct1.ProductName=object[@"productName"];
                dataproduct1.CategoryId=object[@"categoryid"];
                dataproduct1.productSize=object[@"productSize"];
                dataproduct1.productDescription=object[@"ProductDescription"];
                dataproduct1.productColor=object[@"productColor"];
                dataproduct1.ProductModel=object[@"productModel"];
                NSString *strproductQty=object[@"ProductQty"];
                NSString *strProductPrice=object[@"ProductPrice"];
                NSString *strreqquantity=object[@"RequiredQuantity"];
                dataproduct1.productreqQuantity=[strreqquantity integerValue];
                dataproduct1.ProductImage=object[@"ProductImage"];
                dataproduct1.productImages=object[@"ProductImages"];
                dataproduct1.productDescription=object[@"ProductDescription"];
                dataproduct1.productquantity=[strproductQty integerValue];
                dataproduct1.productUnitprice=[strProductPrice floatValue];
                [self.cartArray addObject:dataproduct1];
                NSLog(@"Cart array products %@",self.cartArray);
                PFFile *theImage =(PFFile*)dataproduct1.ProductImage;
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    UIImage *image = [UIImage imageWithData:data];
                    dataproduct1.imgproduct=image;
                }];
            }
            [MMainCollectionView reloadData];
//             self.view.userInteractionEnabled=YES;
            [activity1 setHidden:YES];
            [activity1 stopAnimating];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
