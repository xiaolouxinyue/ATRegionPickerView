//
//  ATRegionPickerView.h
//  ATRegionPickerView
//
//  Created by Jaym on 2017/11/24.
//  Copyright © 2017年 Auntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATRegionPickerView : UIView

/**
 * 创建地区选择器
 * regionArray：地区列表
 * FinishBlock：完成回调
 */
+ (instancetype)showWithRegions:(NSArray *)regionArray finishBlock:(void(^)(NSDictionary *regionDic))block;

@end
