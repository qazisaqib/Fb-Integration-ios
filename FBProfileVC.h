//
//  FBProfileVC.h
//  FBProfileImage
//
//  Created by Ravi Deshmukh on 25/08/12.
//  Copyright (c) 2012 QUAGNITIA. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FbGraph.h"
#import "SBJSON.h"


@class ACAccount;

@interface FBProfileVC : UIViewController
{
    FbGraph *objFBGraph;
}


@property(nonatomic,strong)NSArray *theacountarray;



@property (nonatomic,strong) IBOutlet UIImageView *imgvprofileImage;
@property (nonatomic,strong) NSString *userID;

@property (nonatomic, retain) NSString *username;

- (IBAction)displayFBGraphPopup:(id)sender;

//FBGraphAPI response will be handled by this method
- (void)FBGraphResponse;

- (void)getProfilePic;
- (void)performRequestWithHandler:(SLRequestHandler)handler;


@end
