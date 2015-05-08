  //
//  FBProfileVC.m
//  FBProfileImage
//
//  Created by Ravi Deshmukh on 25/08/12.
//  Copyright (c) 2012 QUAGNITIA. All rights reserved.
//

#import "FBProfileVC.h"
#import "TournamentSelectinScreenViewController.h"
#import "AppDelegate.h"

@interface FBProfileVC ()


@end

#define FbClientID @"477001782317654"
#define clearText @""
#define showActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define hideActivityIndicator()  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@implementation FBProfileVC
@synthesize userID;
@synthesize imgvprofileImage,username;

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
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"splash.png"],
                             
                             
                             nil];
    UIImageView *animationView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320, 568)];
    animationView.animationImages=animationArray;
    animationView.animationDuration=1.0;
    animationView.animationRepeatCount=1;
    [animationView startAnimating];
    [self.view addSubview:animationView];
    
    self.imgvprofileImage.clipsToBounds = YES;
    self.imgvprofileImage.hidden=YES;
    
    
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"Login_screen.jpg"]];

//    self.imgvprofileImage.hidden =YES;
    
    // Do any additional setup after loading the view from its nib.
   
}
- (IBAction)displayFBGraphPopup:(id)sender
{
    showActivityIndicator();
    objFBGraph = [[FbGraph alloc]initWithFbClientID:FbClientID];
    
    //mark some permissions for your access token so that it knows what permissions it has
    
    [objFBGraph authenticateUserWithCallbackObject:self andSelector:@selector(FBGraphResponse) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,publish_checkins,email,user_birthday"];
}




- (void)FBGraphResponse
{
    @try 
    {
        if (objFBGraph.accessToken) 
        {
            SBJSON *jsonparser = [[SBJSON alloc]init];
            
            FbGraphResponse *fb_graph_response = [objFBGraph doGraphGet:@"me" withGetVars:nil];
            
            NSString *resultString = [NSString stringWithString:fb_graph_response.htmlResponse];
            NSDictionary *dict =  [jsonparser objectWithString:resultString];
            
            
            NSURL *url =[NSURL URLWithString:@"http://countmyapp.com/spj/webscripts/adduser.php?"];
            
            
            NSString *post =[NSString stringWithFormat:@"firstName=%@&lastName=%@&email=%@&gender=%@&userId=%@&dob=%@",dict[@"first_name"],dict[@"last_name"],dict[@"email"],dict[@"gender"],dict[@"id"],dict[@"birthday"]]  ;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dict[@"id"] forKey:@"fbID" ] ;
            [defaults synchronize];
            
            //[(AppDelegate*)[[UIApplication sharedApplication] delegate]saveFBID:dict[@"id"]];
            NSData *data = [post dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:data];
            
            NSURLResponse *response ;
            
            NSError *error ;
            
            NSData *responsedata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response  error:&error];
            
            
            NSString *success = @"success";
            [success dataUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"responce is %@",responsedata);

            
            
            TournamentSelectinScreenViewController *trnmntview =[[TournamentSelectinScreenViewController alloc]initWithNibName:@"TournamentSelectinScreenViewController" bundle:nil];
            [self presentViewController:trnmntview animated:YES completion:nil];

            self.userID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            
            
            [self performSelectorOnMainThread:@selector(getProfilePic) withObject:nil waitUntilDone:NO];
            
            
            
            
        }
    }
    @catch (NSException *exception) {
        UIAlertView *objALert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Something bad happened due to %@",[exception reason]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [objALert show];
    }
    
    
}

- (void)getProfilePic
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.userID]];
    NSData *tempData =  [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
    UIImage *FBimage = [UIImage imageWithData:tempData];
    self.imgvprofileImage.image = FBimage;
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setFbprofileImage:FBimage];
    hideActivityIndicator();
}
// implenment here in gettwiterdata function bt i remove the previous code..write the code here..


        
-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

