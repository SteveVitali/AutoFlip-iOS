//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "SidebarRootViewController.h"
#import "SidebarMenuViewController.h"

@interface SidebarRootViewController ()

@end

@implementation SidebarRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    self.backgroundImage = [UIImage imageNamed:@"blue1"];
    self.delegate = (SidebarMenuViewController *)self.menuViewController;
    
}

@end
