//
//  ASPerson.m
//  On Call
//
//  Created by Robbie Clarken on 3/12/13.
//  Copyright (c) 2013 Robbie Clarken. All rights reserved.
//

#import "ASPerson.h"

@implementation ASPerson

+ (instancetype)personWithName:(NSString *)name inGroup:(NSString *)group {
    ASPerson *person = [[ASPerson alloc] init];
    person.name = name;
    person.group = group;
    return person;
}

@end
