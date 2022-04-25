//
//  ZOOViewController.m
//  Zoo.UI
//
//  Created by lzackx on 04/24/2022.
//  Copyright (c) 2022 lzackx. All rights reserved.
//

#import "ZOOViewController.h"

@interface ZOOViewController ()

@end

@implementation ZOOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    v.backgroundColor = UIColor.cyanColor;
    [self.view addSubview:v];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
