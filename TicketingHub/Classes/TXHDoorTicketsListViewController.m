//
//  TXHDoorTicketsListViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsListViewController.h"

#import "TXHDoorSearchViewController.h"
#import "TXHDoorTicketCell.h"

@interface TXHDoorTicketsListViewController ()

@property (strong, nonatomic) NSArray *tickets;

@end

@implementation TXHDoorTicketsListViewController

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
    
    self.tickets = @[@"",@"",@"",@"",@"",@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gueryFor:) name:kRecognizedQRCodeNotification object:nil];
}

- (void)gueryFor:(NSNotification *)note
{
    NSString *text = note.object;
    
    DLog(@"%@",text);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
    
    [cell setIsFirstRow:indexPath.row == 0];
    [cell setIsLastRow:indexPath.row == [self.tickets count] - 1];
    [cell setTitle:@"John Appleseed"];
    [cell setSubtitle:@"Adult"];
    [cell setAttendedAt:[NSDate date]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
