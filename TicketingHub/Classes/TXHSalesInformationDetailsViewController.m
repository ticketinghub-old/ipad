//
//  TXHSalesInformationDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationDetailsViewController.h"

#import "TXHSalesInformationHeader.h"
#import "TXHSalesInformationTextCell.h"
#import "TXHSalesInformationSelectionCell.h"

#import "TXHOrderManager.h"
#import <iOS-api/TXHOrder.h>
#import <iOS-api/TXHField.h>
#import <iOS-api/TXHTicket.h>
#import <iOS-api/TXHCustomer.h>

@interface TXHSalesInformationDetailsViewController () <TXHSalesInformationTextCellDelegate, TXHSalesInformationSelectionCellDelegate, TXHSalesInformationHeaderDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (nonatomic, strong) NSArray *ticketIds; // to keep data sorted
@property (nonatomic, strong) NSDictionary *fields;
@property (strong, nonatomic) NSMutableArray *expandedSections;

@property (nonatomic, strong) NSMutableDictionary *userInput;

@end

@implementation TXHSalesInformationDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadFields];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadFields
{
    [self showLoadingIndicator];
    
    __weak typeof(self) wself = self;
    
    [TXHORDERMANAGER fieldsForCurrentOrderWithCompletion:^(NSDictionary *fields, NSError *error) {

        wself.fields = fields;

        
        [wself hideLoadingIndicator];
    }];
    
}

- (void)setupExpandedSectionsInfo
{
    self.expandedSections = [NSMutableArray array];
    
    for (int i = 0; i < [self.fields count]; i++)
    {
        NSNumber *value = (i == 0) ? @YES : @NO;
        [self.expandedSections addObject:value];
    }
}

- (BOOL)isSectionExpanded:(NSInteger)sectionIndex
{
    return [self.expandedSections[sectionIndex] boolValue];
}

- (void)setSection:(NSInteger)sectionIndex expanded:(BOOL)expanded
{
    self.expandedSections[sectionIndex] = @(expanded);
}

- (NSInteger)numberOfFieldsForTicketID:(NSString *)ticketID
{
    return [self.fields[ticketID] count];
}

#pragma mark accessors

- (void)setFields:(NSDictionary *)fields
{
    _fields = fields;
    
    [self setupExpandedSectionsInfo];
    
    self.ticketIds = [self.fields allKeys];
    
    self.userInput = [NSMutableDictionary dictionary];
    for (NSString *ticketID in self.ticketIds)
    {
        self.userInput[ticketID] = [NSMutableDictionary dictionary];
    }
    
    self.valid = [self hasAllfieldsFilled];
    
    [self.collectionView reloadData];
}

#pragma mark UI

- (void)showLoadingIndicator
{

}

- (void)hideLoadingIndicator
{
    
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.expandedSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfFieldsForTicketID:self.ticketIds[section]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TXHField *field = [self fieldForIndexPath:indexPath];
    NSString *ticketID     = [self ticketIdForIndexPath:indexPath];
    NSString *fieldType    = field.name;
    NSString *userInput    = [self userInputWithType:fieldType forTicketID:ticketID];
    NSString *errorMessage = [self errorMessageForFieldType:fieldType withTicketID:ticketID];
    
    UICollectionViewCell *cell;
    
    // TODO improve this shit
    if ([field.inputType isEqualToString:@"select"])
    {
        TXHSalesInformationSelectionCell *selectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectionCell" forIndexPath:indexPath];
        
        NSMutableArray *ar = [NSMutableArray array];
        for (NSArray  *a in field.options)
        {
            [ar addObject:[a firstObject]];
        }
        
        selectCell.delegate     = self;
        selectCell.placeholder  = field.label;
        selectCell.value        = userInput;
        selectCell.options      = ar;
        selectCell.errorMessage = errorMessage;
        selectCell.name         = field.name;
        
        cell = selectCell;
    }
    else
    {
        TXHSalesInformationTextCell *textCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textCell" forIndexPath:indexPath];
        
        textCell.delegate     = self;
        textCell.name         = field.name;
        textCell.placeholder  = field.label;
        textCell.text         = userInput;
        textCell.errorMessage = errorMessage;
        
        cell = textCell;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        TXHSalesInformationHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationHeader" forIndexPath:indexPath];
        
        NSString *ticketID = [self ticketIdForIndexPath:indexPath];
        TXHTicket *ticket  = [TXHORDERMANAGER ticketFromOrderWithID:ticketID];
        BOOL hasFields = [self numberOfFieldsForTicketID:ticketID] > 0;

        header.tierTitle  = ticket.tier.name;
        header.subTitle   = hasFields ? @"" : NSLocalizedString(@"No extra information is required ", nil);
        header.delegate   = self;
        header.section    = indexPath.section;
        header.expanded   = [self isSectionExpanded:indexPath.section];
        header.expandable = hasFields;
       
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationFooter" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = [self isSectionExpanded:indexPath.section];
    
    CGSize size = CGSizeMake(220.0f, expanded ? 70.0f : 0.0f);
    return size;
}

- (void)makeCellVisible:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (TXHField *)fieldForIndexPath:(NSIndexPath *)indexPath
{
    NSString *ticketID = [self ticketIdForIndexPath:indexPath];
    
    return self.fields[ticketID][indexPath.item];
}

- (NSString *)ticketIdForIndexPath:(NSIndexPath *)indexPath
{
    return self.ticketIds[indexPath.section];
}

- (void)setUserInput:(NSString *)userInput withType:(NSString *)fieldType forTicketID:(NSString *)ticketID
{
    if ([userInput length])
    {
        if (!self.userInput[ticketID]) {
            self.userInput[ticketID] = [NSMutableDictionary dictionary];
        }
        self.userInput[ticketID][fieldType] = userInput;
    }
    else
        [self.userInput[ticketID] removeObjectForKey:fieldType];
    
    self.valid = [self hasAllfieldsFilled];
}

- (NSString *)userInputWithType:(NSString *)type forTicketID:(NSString *)ticketID
{
    return self.userInput[ticketID][type];
}

- (NSString *)errorMessageForFieldType:(NSString *)fieldType withTicketID:(NSString *)ticketID
{
    NSDictionary *errors = [TXHORDERMANAGER customerErrorsForTicketId:ticketID];
    
    return [errors[fieldType] firstObject];
}

- (BOOL)hasAllfieldsFilled
{
    for (NSString *ticketID in self.ticketIds)
    {
        for (TXHField *field in self.fields[ticketID])
        {
            if (![[self userInputWithType:field.name forTicketID:ticketID] length])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSDictionary *)buildCustomersInfo
{
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    for (NSString *ticketID in self.ticketIds)
    {
        NSMutableDictionary *customerDic = [NSMutableDictionary dictionary];
        
        for (TXHField *field in self.fields[ticketID])
        {
            customerDic[field.name] = [self userInputWithType:field.name forTicketID:ticketID];
        }
        
        infoDic[ticketID] = customerDic;
    }
    
    return infoDic;
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

#pragma mark - TXHSalesInformationTextCellDelegate

- (void)txhSalesInformationTextCellDidChangeText:(TXHSalesInformationTextCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSString *ticketId = [self ticketIdForIndexPath:indexPath];

    [self setUserInput:cell.text withType:cell.name forTicketID:ticketId];
}

#pragma mark - TXHSalesInformationSelectionCellDelegate

- (void)txhSalesInformationSelectionCellDidChangeOption:(TXHSalesInformationSelectionCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSString *ticketId = [self ticketIdForIndexPath:indexPath];
    
    [self setUserInput:cell.value withType:cell.name forTicketID:ticketId];
}

#pragma mark - TXHSalesInformationHeaderDelegate

- (void)txhSalesInformationHeaderIsExpandedDidChange:(TXHSalesInformationHeader *)header
{
    [self setSection:header.section expanded:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    NSDictionary *customersInfo = [self buildCustomersInfo];
    
    [TXHORDERMANAGER updateOrderWithCustomersInfo:customersInfo
                                       completion:^(TXHOrder *order, NSError *error) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                               if (error) {
                                                   [self.collectionView reloadData];
                                               }
                                               blockName(error);
                                           });
                                       }];
    
}

- (void)setOffsetBottomBy:(CGFloat)offset
{
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
}

@end
