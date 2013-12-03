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

@interface ASOnCallViewController ()

@property (assign, nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSArray *peopleOnCall;
@property (nonatomic) BOOL addressBookAccessGranted;

@end

@implementation ASOnCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
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

@end
