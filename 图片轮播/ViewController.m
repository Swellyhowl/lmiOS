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
@property(nonatomic,strong) UIPageControl *pageChange;
@property(nonatomic,strong) NSTimer *timer;
/**需要一个数组，用来存放需要滚动的几张图片 */
@property(nonatomic,strong) NSMutableArray *imageNamesArray;
/** 用来记录当前显示的图片，在数组中的下标*/
@property(nonatomic,assign) NSInteger imgindex;
/**用来设置到leftmiddleright三个imgView中的图片名字数组*/
@property(nonatomic,strong) NSMutableArray *imgSetNameArr;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addNameForImgs];
    [self setImgs];
    
    [self move];
}
- (void)move{
    self.imgViewLeft.backgroundColor = [UIColor redColor];
    self.imgViewMiddle.backgroundColor = [UIColor greenColor];
    self.imgViewRight.backgroundColor = [UIColor yellowColor];
    [self addTimer];

}
- (NSMutableArray *)imgSetNameArr{
    if (!_imgSetNameArr) {
        _imgSetNameArr = [NSMutableArray new];
    }
    return _imgSetNameArr;

}
- (NSMutableArray *)imageNamesArray{
    if (!_imageNamesArray) {
        _imageNamesArray = [NSMutableArray new];
    }
    return _imageNamesArray;
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
        [_scrw setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        [self.view addSubview:_scrw];
    }
    return _scrw;

}
- (UIImageView *)imgViewLeft{
    if (!_imgViewLeft) {
        _imgViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        //_imgViewLeft.backgroundColor = [UIColor redColor];
        [self.scrw addSubview:_imgViewLeft];
    }
    return _imgViewLeft;
}
- (UIImageView *)imgViewMiddle{
    if (!_imgViewMiddle) {
        _imgViewMiddle = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 200)];
      //  _imgViewMiddle.backgroundColor = [UIColor grayColor];
    
        [self.scrw addSubview:_imgViewMiddle];
    }
    return _imgViewMiddle;
}
- (UIImageView *)imgViewRight{
    if (!_imgViewRight) {
        _imgViewRight = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        //_imgViewRight.backgroundColor = [UIColor greenColor];
        [self.scrw addSubview:_imgViewRight];
    }
    return _imgViewRight;
}
//往数组中添加图片的名字,这个地方采用的本地图片
- (void)addNameForImgs{
    [self.imageNamesArray addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];

}
//把数组中的图片取出来设置到left，middle，right上面
- (void) setImgs{
    [self updateImgSetArr];
    if (self.imageNamesArray.count != 0 && self.imgSetNameArr.count != 0) {
        [self.imgViewLeft setImage:[UIImage imageNamed:self.imgSetNameArr[0]]];
        [self.imgViewMiddle setImage:[UIImage imageNamed:self.imgSetNameArr[1]]];
        [self.imgViewRight setImage:[UIImage imageNamed:self.imgSetNameArr[2]]];
        self.imgindex = 1;
    }else{
        NSLog(@"imageNamesArray数组中没有内容");
    
    }

}
//更新设置到三个imageview中图片的数组
- (void) updateImgSetArr{
    for (int i = 0; i < 3; i++) {
        [self.imgSetNameArr addObject:self.imageNamesArray[i]];
    }


}
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeToNextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer{
    [self.timer invalidate];
}
//切换到下一张图片
- (void)changeToNextImage{
    //先将三张图片滚动起来
    if (self.imgindex == 2) {
        [self.imgSetNameArr removeObjectAtIndex:0];
        [self.imgSetNameArr addObject:self.imageNamesArray[0]];
        [self setImgs];
    }else{
        _imgindex++;
        
    }
    
    NSLog(@"这里是每隔两秒就调用一次吗");
    [self.scrw setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    NSInteger ofset = self.scrw.contentOffset.x / self.scrw.bounds.size.width;
//    [self.scrw setContentOffset:CGPointMake(ofset, 0) animated:YES];
/**
 *如何实现只需要3个imageView就可以实现大于3张图片的无限轮播
 *这里三个imageView分别为left。middle。right三个imageView
    *假设这里有5张图片，放在一个数组中，那么【0】-->left，【1】-->middle，【2】-->right;
    *显示的时候只显示middle这个imageView，将imageView放入重用池，向右滑一次，此时移动到right这个imageView上，
    *middle变为left，left可以进行重用变为right，此时【1】-->left,【2】-->middle,【3】-->right
    *知道right变成数组下标的最后一个，在向右移动的时候，left重新设置为数组【0】
 */
}
@end
