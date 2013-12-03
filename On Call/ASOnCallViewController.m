//
//  ASOnCallViewController.m
//  On Call
//
//  Created by Robbie Clarken on 3/12/13.
//  Copyright (c) 2013 Robbie Clarken. All rights reserved.
//

#import "ASOnCallViewController.h"
#import "ASPerson.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ASOnCallViewController () <ABPersonViewControllerDelegate>

@property (assign, nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSArray *peopleOnCall;
@property (nonatomic) BOOL addressBookAccessGranted;

@end

@implementation ASOnCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peopleOnCall = @[
        [ASPerson personWithName:@"James White" inGroup:@"Electrical"],
        [ASPerson personWithName:@"John Brown" inGroup:@"Mechanical"],
        [ASPerson personWithName:@"Jane Black" inGroup:@"Controls"]
    ];
    
    self.addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    [self checkAddressBookAccess];
}

#pragma mark - Address book access

-(void)checkAddressBookAccess {
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized:
            // All good
            self.addressBookAccessGranted = YES;
            break;
        case kABAuthorizationStatusNotDetermined:
            // User has not specified
            [self requestAddressBookAccess];
            break;
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            self.addressBookAccessGranted = NO;
            break;
    }
}

- (void)requestAddressBookAccess {
    ASOnCallViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(weakSelf.addressBook, ^(bool granted, CFErrorRef error) {
        weakSelf.addressBookAccessGranted = granted;
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peopleOnCall count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ASPerson *person = (ASPerson *)self.peopleOnCall[indexPath.row];

    cell.textLabel.text = person.group;
    cell.detailTextLabel.text = person.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.addressBookAccessGranted) {
        // TODO: Alert user that access must be granted
        return;
    }
    
    ASPerson *person = (ASPerson *)self.peopleOnCall[indexPath.row];
    CFStringRef name = (__bridge CFStringRef)person.name;
    NSArray *matches = (NSArray *)CFBridgingRelease(ABAddressBookCopyPeopleWithName(self.addressBook, name));
    if(matches != nil && [matches count]) {
        ABRecordRef personRecord = (__bridge ABRecordRef)matches[0];
        ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
        personViewController.personViewDelegate = self;
        personViewController.displayedPerson = personRecord;
        personViewController.allowsActions = YES;
        personViewController.allowsEditing = YES;
        [self.navigationController pushViewController:personViewController animated:YES];
    } else {
        // TODO: Alert user that person is not in addressbook
    }
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return YES;
}

@end
