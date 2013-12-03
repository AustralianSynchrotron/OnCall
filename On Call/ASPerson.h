//
//  ASPerson.h
//  On Call
//
//  Created by Robbie Clarken on 3/12/13.
//  Copyright (c) 2013 Robbie Clarken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPerson : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *group;

+ (instancetype)personWithName:(NSString *)name inGroup:(NSString *)group;

@end
