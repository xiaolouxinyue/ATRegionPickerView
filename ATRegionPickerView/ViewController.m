//
//  ViewController.m
//  ATRegionPickerView
//
//  Created by Jaym on 2017/11/24.
//  Copyright © 2017年 Auntec. All rights reserved.
//

#import "ViewController.h"
#import "ATRegionPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showRegionPickView:(id)sender {
    
    [ATRegionPickerView showWithRegions:nil finishBlock:^(NSDictionary *regionDic) {
        if (regionDic) {
            NSLog(@"select region is %@", regionDic);
        }else{
            NSLog(@"cancel select.");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
