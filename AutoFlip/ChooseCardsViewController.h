//
//  ChoosePresentationViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeckTableCell.h"

@interface ChooseCardsViewController : UITableViewController
                                        <UITableViewDataSource,
                                         UITableViewDelegate,
                                         UISearchBarDelegate,
                                         UISearchDisplayDelegate>

@property (strong,nonatomic) NSMutableArray *searchResults;
@property IBOutlet UISearchBar *searchBar;

- (IBAction)toggleEditing;
- (IBAction)chooseButtonPressed:(id)sender;

@end
