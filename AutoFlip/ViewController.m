//
//  ViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "ViewController.h"
#import "KxMenu.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import <DropboxSDK/DropboxSDK.h>
#import <DBChooser/DBChooser.h>

@interface ViewController ()

@end

@implementation ViewController {
    
    UIImage *drive;
    UIImage *dropbox;
    UIImage *custom;
}

@synthesize restClient = _restClient;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    drive   = [UIImage imageNamed:@"drive.png"];
    dropbox = [UIImage imageNamed:@"dropbox.png"];
    custom  = [UIImage imageNamed:@"custom.png"];
    
    //scale 4.0 = 1/4 original image size
    //makes assumptions on image sizes, which is bad but this is just to test the menu thing.
    drive = [self scaleImage:drive withScale:8.0];
    dropbox=[self scaleImage:dropbox withScale:8.0];
    custom =[self scaleImage:custom withScale:4.0];
    
    self.logoLabel.font = [UIFont flatFontOfSize:36];
    self.logoLabel.textColor = [UIColor midnightBlueColor];
  //  self.logoLabel.font = [UIFont systemFontOfSize:36];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.importButton.buttonColor = [UIColor turquoiseColor];
    self.importButton.shadowColor = [UIColor greenSeaColor];
    self.importButton.shadowHeight = 3.0f;
    self.importButton.cornerRadius = 6.0f;
    self.importButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.importButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.importButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
   
    self.startButton.buttonColor = [UIColor turquoiseColor];
    self.startButton.shadowColor = [UIColor greenSeaColor];
    self.startButton.shadowHeight = 3.0f;
    self.startButton.cornerRadius = 6.0f;
    self.startButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale {
    
    return [UIImage imageWithCGImage:[image CGImage]
                              scale:(image.scale * scale)
                        orientation:(image.imageOrientation)];
}

- (IBAction)showMenu:(UIButton *)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Import Notecards"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Google Drive"
                     image:drive
                    target:self
                    action:@selector(pushDriveView:)],
      
      [KxMenuItem menuItem:@"Dropbox"
                     image:dropbox
                    target:self
                    action:@selector(pushDropboxView:)],
      
      [KxMenuItem menuItem:@"Create cards"
                     image:custom
                    target:self
                    action:@selector(pushCreateCardsView:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor turquoiseColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)pushDriveView:(id)sender {
    
    [self performSegueWithIdentifier:@"createCards" sender:sender];
}

#pragma mark - Dropbox Core API methods

- (void)pushDropboxView:(id)sender {
    
    [self didPressLink];
    //[self performSegueWithIdentifier:@"createCards" sender:sender];
}

- (void)didPressLink {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    [[self restClient] loadMetadata:@"/"];
    NSLog(@"link pressed");
}

- (DBRestClient *)restClient {
    
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    
    NSLog(@"There was an error loading the file - %@", error);
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

#pragma mark - Dropbox Drop-ins methods

- (void)dropboxChoose {
    
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview
                                    fromViewController:self completion:^(NSArray *results)
    {
         if ([results count]) {
             // Process results from Chooser
         } else {
             // User canceled the action
         }
     }];
}

- (IBAction)didPressChoose {
    
    [self dropboxChoose];
}

- (void)pushCreateCardsView:(id)sender {
    
    [self performSegueWithIdentifier:@"createCards" sender:sender];
}

- (void)returnToRoot {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

