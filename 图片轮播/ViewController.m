//
//  ViewController.m
//  图片轮播
//
//  Created by 风鹰 on 2017/8/2.
//  Copyright © 2017年 风鹰. All rights reserved.
//

#import "ViewController.h"
#define offsetX [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrw;
@property(nonatomic,strong) UIImageView *imgViewLeft;
@property(nonatomic,strong) UIImageView *imgViewMiddle;
@property(nonatomic,strong) UIImageView *imgViewRight;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UIPageControl *pageC;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self move];
    [self setPageControl];

    NSLog(@"子视图%@",self.view.subviews);

}
- (void)move{
    self.imgViewLeft.backgroundColor = [UIColor redColor];
    self.imgViewMiddle.backgroundColor = [UIColor greenColor];
    self.imgViewRight.backgroundColor = [UIColor yellowColor];
    [self addTimer];

}

- (UIPageControl *)pageC{
    if (!_pageC) {
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, offsetX - 240, offsetX,40 )];
    }
    return _pageC;
}


- (UIScrollView *)scrw{
    if (!_scrw) {
        _scrw = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
       // _scrw = [[UIScrollView alloc] init];
        self.automaticallyAdjustsScrollViewInsets = YES;
        _scrw.showsHorizontalScrollIndicator = NO;
        _scrw.bounces = NO;
        _scrw.pagingEnabled = YES;
        _scrw.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
        //创建出来的scrowView默认显示第二章图片，也就是中间那张）
        [_scrw setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        NSLog(@"刚创建出来的contentoffset%f,%f",_scrw.contentOffset.x,_scrw.contentOffset.y);
        _scrw.delegate = self;
        [self.view addSubview:_scrw];
    }
    return _scrw;

}
- (UIImageView *)imgViewLeft{
    if (!_imgViewLeft) {
        _imgViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        //_imgViewLeft.backgroundColor = [UIColor redColor];
        [_imgViewLeft setImage:[UIImage imageNamed:@"5"]];
        [self.scrw addSubview:_imgViewLeft];
    }
    return _imgViewLeft;
}
- (UIImageView *)imgViewMiddle{
    if (!_imgViewMiddle) {
        _imgViewMiddle = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 200)];
      //  _imgViewMiddle.backgroundColor = [UIColor grayColor];
        [_imgViewMiddle setImage:[UIImage imageNamed:@"0"]];

        [self.scrw addSubview:_imgViewMiddle];
    }
    return _imgViewMiddle;
}
- (UIImageView *)imgViewRight{
    if (!_imgViewRight) {
        _imgViewRight = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        //_imgViewRight.backgroundColor = [UIColor greenColor];
        [self.scrw addSubview:_imgViewRight];
        [_imgViewRight setImage:[UIImage imageNamed:@"1"]];

    }
    return _imgViewRight;
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self.scrw setContentOffset:CGPointMake(0, 0) animated:NO];
//
//
//}
- (void) setPageControl{
    NSLog(@"self.pageC%@",self.pageC);
    self.pageC.numberOfPages = 5;
    self.pageC.currentPage = 0;
    self.pageC.userInteractionEnabled = NO;
    self.pageC.pageIndicatorTintColor = [UIColor redColor];
    
    //self.pageC.center = self.scrw.center;
    [self.view addSubview:_pageC];
//    [self.view insertSubview:_pageC atIndex:1];

}

//上一张图片
- (void)preImg{
    if (self.pageC.currentPage == 0) {
        self.pageC.currentPage = 4;
    }else{
        self.pageC.currentPage -= 1;
    }
    [self.scrw setContentOffset:CGPointMake(0, 0) animated:YES];

}
//下一张图片
- (void)nextImg{
    if (self.pageC.currentPage == 4) {
        self.pageC.currentPage = 0;
    }else{
        self.pageC.currentPage += 1;
    }
    //[self.scrw setBackgroundColor:[UIColor whiteColor]];
    [self.scrw setContentOffset:CGPointMake(offsetX * 2, 0) animated:YES];
    NSLog(@"第一次移动后的contentoffset%f,%f",_scrw.contentOffset.x,_scrw.contentOffset.y);

    NSLog(@"nextImg");

    
}
//重新加载图片，重新设置三个imgView
- (void) reloadImgs{
    int currentIndex = (int)self.pageC.currentPage;
    NSLog(@"currentIndex%d",currentIndex);
    int preIndex = (currentIndex + 4) % 5;
    int nextIndex = (currentIndex + 1) % 5;
    [self.imgViewLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",preIndex]]];
    [self.imgViewMiddle setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",currentIndex]]];
    [self.imgViewRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",nextIndex]]];

}
//开始滑动的时候要终止timer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"willbeginDragging");
    [self removeTimer];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"DidEndDragging");
    [self addTimer];
    if (self.scrw.contentOffset.x < offsetX) {
        [self preImg];
    }else{
        [self nextImg];
    
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"DidEndScrollingAnimation");
    [self reloadImgs];
    [self.scrw setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer{
    [self.timer invalidate];
}


@end
