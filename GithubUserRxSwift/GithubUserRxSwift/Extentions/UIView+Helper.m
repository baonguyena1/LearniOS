//
//  UIView+Helper.m
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/23/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

@dynamic cornerRadius, borderWidth, borderColor;

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
