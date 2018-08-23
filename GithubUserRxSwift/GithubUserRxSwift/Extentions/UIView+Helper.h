//
//  UIView+Helper.h
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/23/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (Helper)

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@end
