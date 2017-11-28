//
//  ATRegionPickerView.m
//  ATRegionPickerView
//
//  Created by Jaym on 2017/11/24.
//  Copyright © 2017年 Auntec. All rights reserved.
//

#import "ATRegionPickerView.h"

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight (IS_IPHONEX ? ([[UIScreen mainScreen] bounds].size.height - 34) : ([[UIScreen mainScreen] bounds].size.height))
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]

@interface ATRegionPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *regionPickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regionRootViewBottomCons;

@property (nonatomic, strong) NSArray *regionArray;
///完成回调
@property (nonatomic, copy) void (^finishBlock)(NSDictionary *regionDic);
@end

static ATRegionPickerView *_view = nil;

@implementation ATRegionPickerView


+ (instancetype)showWithRegions:(NSArray *)regionArray finishBlock:(void(^)(NSDictionary *regionDic))block
{
    _view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    _view.regionArray = regionArray ? regionArray : [_view defultRegionArray];
    _view.finishBlock = block;

    [_view showPickerView];
    return _view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.regionRootViewBottomCons.constant = -266;
    [self layoutIfNeeded];

    self.regionPickView.dataSource = self;
    self.regionPickView.delegate = self;
    self.regionPickView.showsSelectionIndicator=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelRegionSelectAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark UIPickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.regionArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dic = [self.regionArray objectAtIndex:row];
    return [NSString stringWithFormat:@"+%@ %@", [dic valueForKey:@"code"], [dic valueForKey:@"country"]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = HexColor(0xc6c6c6);
        }
    }
    //设置字体大小、颜色
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
        [pickerLabel setTextColor:HexColor(0x333333)];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (IBAction)cancelRegionSelectAction:(id)sender
{
    [self hidePickerView];
    if (_finishBlock) {
        _finishBlock(nil);
    }
}

- (IBAction)finishRegionSelectAction:(id)sender
{
    [self hidePickerView];
    NSInteger selectedRow = [self.regionPickView selectedRowInComponent:0];
    NSDictionary *dic = [self.regionArray objectAtIndex:selectedRow];
    if (_finishBlock) {
        _finishBlock(dic);
    }
}

//显示
- (void)showPickerView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        self.regionRootViewBottomCons.constant = 0;
        [self layoutIfNeeded];
    }];
}

//隐藏
- (void)hidePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.regionRootViewBottomCons.constant = -266;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSArray *)defultRegionArray
{
    NSArray *regionArray = @[
        @{@"abbr":@"CN",@"name":@"China",@"country":@"中国大陆",@"code":@"86"},
        @{@"abbr":@"AR",@"name":@"Argentina",@"country":@"阿根廷",@"code":@"54"},
        @{@"abbr":@"AU",@"name":@"Australia",@"country":@"澳大利亚",@"code":@"61"},
        @{@"abbr":@"AT",@"name":@"Austria",@"country":@"奥地利",@"code":@"43"},
        @{@"abbr":@"BS",@"name":@"Bahamas",@"country":@"巴哈马",@"code":@"1242"},
        @{@"abbr":@"BY",@"name":@"Belarus",@"country":@"白俄罗斯",@"code":@"375"},
        @{@"abbr":@"BE",@"name":@"Belgium",@"country":@"比利时",@"code":@"32"},
        @{@"abbr":@"BZ",@"name":@"Belize",@"country":@"伯利兹",@"code":@"501"},
        @{@"abbr":@"BR",@"name":@"Brazil",@"country":@"巴西",@"code":@"55"},
        @{@"abbr":@"BG",@"name":@"Bulgaria",@"country":@"保加利亚",@"code":@"359"},
        @{@"abbr":@"KH",@"name":@"Cambodia",@"country":@"柬埔寨",@"code":@"855"},
        @{@"abbr":@"CA",@"name":@"Canada",@"country":@"加拿大",@"code":@"1"},
        @{@"abbr":@"CL",@"name":@"Chile",@"country":@"智利",@"code":@"56"},
        @{@"abbr":@"CO",@"name":@"Colombia",@"country":@"哥伦比亚",@"code":@"57"},
        @{@"abbr":@"DK",@"name":@"Denmark",@"country":@"丹麦",@"code":@"45"},
        @{@"abbr":@"EG",@"name":@"Egypt",@"country":@"埃及",@"code":@"20"},
        @{@"abbr":@"EE",@"name":@"Estonia",@"country":@"爱沙尼亚",@"code":@"372"},
        @{@"abbr":@"FI",@"name":@"Finland",@"country":@"芬兰",@"code":@"358"},
        @{@"abbr":@"FR",@"name":@"France",@"country":@"法国",@"code":@"33"},
        @{@"abbr":@"DE",@"name":@"Germany",@"country":@"德国",@"code":@"49"},
        @{@"abbr":@"GR",@"name":@"Greece",@"country":@"希腊",@"code":@"30"},
        @{@"abbr":@"HK",@"name":@"Hong Kong",@"country":@"中国香港",@"code":@"852"},
        @{@"abbr":@"HU",@"name":@"Hungary",@"country":@"匈牙利",@"code":@"36"},
        @{@"abbr":@"IN",@"name":@"India",@"country":@"印度",@"code":@"91"},
        @{@"abbr":@"ID",@"name":@"Indonesia",@"country":@"印度尼西亚",@"code":@"62"},
        @{@"abbr":@"IE",@"name":@"Ireland",@"country":@"爱尔兰",@"code":@"353"},
        @{@"abbr":@"IL",@"name":@"Israel",@"country":@"以色列",@"code":@"972"},
        @{@"abbr":@"IT",@"name":@"Italy",@"country":@"意大利",@"code":@"39"},
        @{@"abbr":@"JP",@"name":@"Japan",@"country":@"日本",@"code":@"81"},
        @{@"abbr":@"JO",@"name":@"Jordan",@"country":@"约旦",@"code":@"962"},
        @{@"abbr":@"KG",@"name":@"Kyrgyzstan",@"country":@"吉尔吉斯斯坦",@"code":@"996"},
        @{@"abbr":@"LT",@"name":@"Lithuania",@"country":@"立陶宛",@"code":@"370"},
        @{@"abbr":@"LU",@"name":@"Luxembourg",@"country":@"卢森堡",@"code":@"352"},
        @{@"abbr":@"MO",@"name":@"Macau",@"country":@"中国澳门",@"code":@"853"},
        @{@"abbr":@"MY",@"name":@"Malaysia",@"country":@"马来西亚",@"code":@"60"},
        @{@"abbr":@"MV",@"name":@"Maldives",@"country":@"马尔代夫",@"code":@"960"},
        @{@"abbr":@"MX",@"name":@"Mexico",@"country":@"墨西哥",@"code":@"52"},
        @{@"abbr":@"MN",@"name":@"Mongolia",@"country":@"蒙古",@"code":@"976"},
        @{@"abbr":@"MA",@"name":@"Morocco",@"country":@"摩洛哥",@"code":@"212"},
        @{@"abbr":@"NL",@"name":@"Netherlands",@"country":@"荷兰",@"code":@"31"},
        @{@"abbr":@"NZ",@"name":@"New Zealand",@"country":@"新西兰",@"code":@"64"},
        @{@"abbr":@"NG",@"name":@"Nigeria",@"country":@"尼日利亚",@"code":@"234"},
        @{@"abbr":@"NO",@"name":@"Norway",@"country":@"挪威",@"code":@"47"},
        @{@"abbr":@"PA",@"name":@"Panama",@"country":@"巴拿马",@"code":@"507"},
        @{@"abbr":@"PE",@"name":@"Peru",@"country":@"秘鲁",@"code":@"51"},
        @{@"abbr":@"PH",@"name":@"Philippines",@"country":@"菲律宾",@"code":@"63"},
        @{@"abbr":@"PL",@"name":@"Poland",@"country":@"波兰",@"code":@"48"},
        @{@"abbr":@"PT",@"name":@"Portugal",@"country":@"葡萄牙",@"code":@"351"},
        @{@"abbr":@"QA",@"name":@"Qatar",@"country":@"卡塔尔",@"code":@"974"},
        @{@"abbr":@"RO",@"name":@"Romania",@"country":@"罗马尼亚",@"code":@"40"},
        @{@"abbr":@"RU",@"name":@"Russia",@"country":@"俄罗斯",@"code":@"7"},
        @{@"abbr":@"SA",@"name":@"Saudi Arabia",@"country":@"沙特阿拉伯",@"code":@"966"},
        @{@"abbr":@"RS",@"name":@"Serbia",@"country":@"塞尔维亚",@"code":@"381"},
        @{@"abbr":@"SC",@"name":@"Seychelles",@"country":@"塞舌尔",@"code":@"248"},
        @{@"abbr":@"SG",@"name":@"Singapore",@"country":@"新加坡",@"code":@"65"},
        @{@"abbr":@"ZA",@"name":@"South Africa",@"country":@"南非",@"code":@"27"},
        @{@"abbr":@"KR",@"name":@"South Korea",@"country":@"韩国",@"code":@"82"},
        @{@"abbr":@"ES",@"name":@"Spain",@"country":@"西班牙",@"code":@"34"},
        @{@"abbr":@"LK",@"name":@"Sri Lanka",@"country":@"斯里兰卡",@"code":@"94"},
        @{@"abbr":@"SE",@"name":@"Sweden",@"country":@"瑞典",@"code":@"46"},
        @{@"abbr":@"CH",@"name":@"Switzerland",@"country":@"瑞士",@"code":@"41"},
        @{@"abbr":@"TW",@"name":@"Taiwan",@"country":@"中国台湾",@"code":@"886"},
        @{@"abbr":@"TH",@"name":@"Thailand",@"country":@"泰国",@"code":@"66"},
        @{@"abbr":@"TN",@"name":@"Tunisia",@"country":@"突尼斯",@"code":@"216"},
        @{@"abbr":@"TR",@"name":@"Turkey",@"country":@"土耳其",@"code":@"90"},
        @{@"abbr":@"UA",@"name":@"Ukraine",@"country":@"乌克兰",@"code":@"380"},
        @{@"abbr":@"AE",@"name":@"United Arab Emirates",@"country":@"阿联酋",@"code":@"971"},
        @{@"abbr":@"GB",@"name":@"United Kingdom",@"country":@"@英国",@"code":@"44"},
        @{@"abbr":@"US",@"name":@"United States",@"country":@"美国",@"code":@"1"},
        @{@"abbr":@"VE",@"name":@"Venezuela",@"country":@"委内瑞拉",@"code":@"58"},
        @{@"abbr":@"VN",@"name":@"Vietnam",@"country":@"越南",@"code":@"84"},
        @{@"abbr":@"VG",@"name":@"Virgin Islands, British",@"country":@"英属维尔京群岛",@"code":@"1285"}
    ];
    
    return regionArray;
}

@end
