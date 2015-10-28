//
//  CLMRouteViewController.m
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import "CLMRouteViewController.h"

@implementation CLMRouteViewController

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.route.steps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell"];
    MKRouteStep *step = self.route.steps[indexPath.row];
    cell.textLabel.text = step.instructions;
    cell.detailTextLabel.text = step.notice;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(routeViewController:didSelectStep:)]) {
        [self.delegate routeViewController:self didSelectStep:self.route.steps[indexPath.row]];
    }
}

@end
