//
//  TXHSalesInformationDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

/*
 {
     "id": 4000,
     "currency": "GBP",
     "opt_out": false,
     "expires_in": 600,
     "total": 3400,
     "commission": 200,
     "customer": null,
     "coupon": null,
     "payment": null,
     "products": [
         {
             "id": 3000,
             "name": "Guide Book",
             "description": "A detailed outline of the venue which you can read",
             "price": 300,
             "quantity": 2,
             "errors": {}
         }
     ],
     "tickets": [
         {
         "id": 7000,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 800,
         "commission": 50,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2000,
             "name": "Child",
             "description": "Under 18 years old"
         },
         "errors": {}
     },
     {
         "id": 7001,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 800,
         "commission": 50,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2000,
             "name": "Child",
             "description": "Under 18 years old"
         },
         "errors": {}
     },
     {
         "id": 7002,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 1200,
         "commission": 100,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2001,
             "name": "Adult",
             "description": "18 years old or more"
         },
         "errors": {
             "customer": [
                 "can't be blank"
             ]
         }
         }
    ],
    "errors": {}
 }

*/

#import "TXHSalesInformationDetailsViewController.h"

#import "TXHEmailCollectionViewCell.h"
#import "TXHTextCollectionViewCell.h"
#import "TXHSalesInformationHeader.h"
#import "TXHSalesInformationTextCell.h"

@interface TXHSalesInformationDetailsViewController ()

@end

@implementation TXHSalesInformationDetailsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#pragma unused (collectionView, section)
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXHSalesInformationTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"temp" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.ticket = @"First Name";
                break;
            case 1:
                cell.ticket = @"Last Name";
                [cell hasErrors:YES];
                break;
            case 2:
                cell.ticket = @"Email";
                break;
            default:
                cell.ticket = [NSString stringWithFormat:@"indexPath:{%d,%d}", indexPath.section, indexPath.row];
                break;
        }
        return cell;
    } else {
        switch (indexPath.row) {
            case 0: {
                TXHTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
                cell.textField.placeholder = @"Placeholder Text";
                cell.errorMessage = [NSString stringWithFormat:@"error %d", indexPath.row];
                return cell;
            }
            case 1: {
                TXHTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"email" forIndexPath:indexPath];
                return cell;
            }
            default: {
                TXHSalesInformationTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"temp" forIndexPath:indexPath];
                cell.ticket = [NSString stringWithFormat:@"temp %d", indexPath.row];
                return cell;
            }
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        TXHSalesInformationHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationHeader" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                header.tierTitle = [NSString stringWithFormat:@"Adult"];
                break;
            case 1:
                header.tierTitle = [NSString stringWithFormat:@"Under 18"];
                break;
            default:
                header.tierTitle = [NSString stringWithFormat:@"Section:%d", indexPath.section];
                break;
        }
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationFooter" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

- (void)makeCellVisible:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}


//#pragma mark - Keyboard notifications
//
//- (void)keyboardWillShown:(NSNotification *)notification {
//    NSDictionary *info = [notification userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, keyboardSize.width, 0.0f);
//    self.collectionView.contentInset = contentInsets;
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    NSDictionary *keyboardAnimationDetail = [notification userInfo];
//    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
//        self.collectionView.contentInset = UIEdgeInsetsZero;
//        [self.collectionView layoutIfNeeded];
//    } completion:nil];
//}

@end
