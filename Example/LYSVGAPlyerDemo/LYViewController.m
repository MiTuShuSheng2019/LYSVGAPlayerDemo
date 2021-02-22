//
//  LYViewController.m
//  LYSVGAPlyerDemo
//
//  Created by 904101287@qq.com on 02/19/2021.
//  Copyright (c) 2021 904101287@qq.com. All rights reserved.
//

#import "LYViewController.h"
#import <SVGA.h>
#import <SVGAVideoEntity+CHSVGA.h>

@interface LYViewController ()<SVGAPlayerDelegate>{
    NSArray *_items;
}

@property (nonatomic, strong) SVGAPlayer *player;

@property (nonatomic, strong) SVGAParser *parser;

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // 清除内存缓存
    //[SVGAVideoEntity chsvga_clearMemoryCache];
    // 设置内存缓存最大值, 默认为10M
    //[SVGAVideoEntity chsvga_setupMemoryCacheCostLimit:10 * 1024];
    
    //svga动画资源数组
    NSArray *items = @[
        @"https://github.com/yyued/SVGA-Samples/blob/master/EmptyState.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/HamburgerArrow.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/PinJump.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/TwitterHeart.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/Walkthrough.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/halloween.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/kingset.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/rose.svga?raw=true",
        @"https://github.com/yyued/SVGA-Samples/blob/master/posche.svga?raw=true"
    ];
    _items = items;
   
//    [self.player setImage:[UIImage imageNamed:@"icon_bad_network"] forKey:@"banner"];
//    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"我是替换标题啊~" attributes:@{
//        NSForegroundColorAttributeName: UIColor.redColor,
//        NSFontAttributeName: [UIFont boldSystemFontOfSize:40],
//    }];
//    [self.player setAttributedText:attStr forKey:@"banner"];
    
    [self.view addSubview:self.player];

    [self playAnimation];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self playAnimation];
}

//播放动画
-(void)playAnimation{
    NSLog(@"arc4random = %ld", arc4random() % _items.count);
    __weak typeof(self) weakSelf = self;
    [self.parser parseWithURL:[NSURL URLWithString:_items[arc4random() % _items.count]] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        
        if (videoItem != nil) {
            weakSelf.player.videoItem = videoItem;
            [weakSelf.player startAnimation];
        }
        
    } failureBlock:^(NSError * _Nullable error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark -- <SVGAPlayerDelegate>
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    //动画播放完成
}

- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame{
    NSLog(@"frame = %ld", (long)frame);
}

- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
    NSLog(@"percentage = %f", percentage);
}

#pragma mark -- lazy
- (SVGAPlayer *) player
{
    if (!_player) {
        _player = [[SVGAPlayer alloc] init];
        _player.frame = UIScreen.mainScreen.bounds;
        //动画播放1次
        _player.loops = 1;
        //设置代理
        _player.delegate = self;
        //动画停止后是否清除最后一帧
        _player.clearsAfterStop = YES;
    }
    return _player;
}

- (SVGAParser *) parser
{
    if (!_parser) {
        _parser = [[SVGAParser alloc] init];
        _parser.enabledMemoryCache = YES;
    }
    return _parser;
}

@end
