//
//  SMVRPlayer.m
//  SMVRPlayerDemo
//
//  Created by 高雅楠 on 2017/4/19.
//  Copyright © 2017年 com.samonkey. All rights reserved.
//

#import "SMVRPlayer.h"
#import "Masonry.h"
#import <SMVRPlayer/SMVRPlayerControl.h>


#define VIEWHEIGHT   50
#define BUTTONWIDTH  60
#define BUTTONHEIGHT 30
#define DISTANCE     10


@interface SMVRPlayer ()<SMVRVideoPlayerControlStateDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *playModelBtn;
@property (nonatomic, strong) UIButton *controlModelBtn;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) SMVRPlayerControl *controlPlayer;
@property (nonatomic, assign) float videoDuration;
@property (nonatomic, copy)   NSString *timeDuration;
@property (nonatomic, strong) UIActivityIndicatorView *seekindicator;
@property (nonatomic, assign) BOOL sliderIsChanging;
@end

@implementation SMVRPlayer

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSURL *)url withNormalVideo:(BOOL)isNormalVideo withViewController:(UIViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self.topView addSubview:self.closeBtn];
        [self.topView addSubview:self.playModelBtn];
        [self.topView addSubview:self.controlModelBtn];
        [self.bottomView addSubview:self.playOrPauseBtn];
        [self.bottomView addSubview:self.progressSlider];
        [self.bottomView addSubview:self.timeLabel];
        [self addSubview:self.seekindicator];
        
        [self addMasnory];
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.videoDuration = [self getDurationWithVideo:url];
            self.progressSlider.maximumValue = self.videoDuration;
        });
    
        //初始化播放器
        self.controlPlayer = [[SMVRPlayerControl alloc] init];
        //视频地址
        [self.controlPlayer setVideoUrl:url];
        //提供播放视图
        [self.controlPlayer setController:vc withView:self];
        //回调的代理方法注册
        self.controlPlayer.delegate = self;
        if (!isNormalVideo){
            //全景视频配置
            //是否支持缩放功能
            [self.controlPlayer setSupportPinch:NO];
            //视频为全景视频
            [self.controlPlayer setVideoModel:panoramaVideo];
            //配置操控模式
            [self.controlPlayer setControlModel:gestureModel];
            //配置观看模式
            [self.controlPlayer setPanoramaModel:normalModel];
        }
        else{
            [self.controlPlayer setVideoModel:nomalVideo];
            self.controlModelBtn.hidden = YES;
            self.playModelBtn.hidden = YES;
        }
        //创建播放器配置
        [self.controlPlayer setUp];
        //开始播放
        [self.controlPlayer videoPlay];
        
        [self.seekindicator startAnimating];
        [self bringSubviewToFront:self.topView];
        [self bringSubviewToFront:self.bottomView];
    }
    return self;
}

- (void)updateProgressChange:(UISlider *)sender{
    if (self.sliderIsChanging) {
        self.sliderIsChanging = NO;
    }
    //视频进度跳转
    [self.controlPlayer videoSeekToTime:sender.value];
}

- (void)updateSliderValue:(UISlider *)sender{
    if (!self.sliderIsChanging) {
        self.sliderIsChanging = YES;
    }
    self.progressSlider.value = sender.value;
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertTime:sender.value],self.timeDuration];
}

- (void)playOrPauseClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
        //视频暂停
        [self.controlPlayer videoPause];
    }
    else{
        [self.playOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        //视频播放
        [self.controlPlayer videoPlay];
    }
}

- (void)changeLookMethod:(NSInteger)type{
    if (type == 0) {
        //观看模式为普通模式
        [self.controlPlayer changePanoramaModel:normalModel];
    }
    else{
        //观看模式为眼镜模式
        [self.controlPlayer changePanoramaModel:glassModel];
    }
}

- (void)changeControlMethod:(NSInteger)type{
    switch (type) {
        case 0:
            //操控模式为手势模式
            [self.controlPlayer changeControlModel:gestureModel];
            break;
        case 1:
            //操控模式为重力模式
            [self.controlPlayer changeControlModel:gravityModel];
            break;
        case 2:
            //操控模式为两种模式都有
            [self.controlPlayer changeControlModel:allModel];
            break;
            
        default:
            break;
    }
}

//视频可以播放
- (void)videoPlayerIsReadyToPlay{
    [self.seekindicator stopAnimating];;
    self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@",[self convertTime:self.videoDuration]];
    self.timeDuration = [self convertTime:self.videoDuration];
}

//视频播放完成
- (void)videoPlayerDidReachEnd{
    if (self.endBlock) {
        self.endBlock();
    }
}

/**
 视频进度变化
 
 @param cmTime 变化值
 */
- (void)videoPlayerTimeDidChange:(CMTime)cmTime{
    float tmpTime = CMTimeGetSeconds(cmTime);
    if (!self.sliderIsChanging) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertTime:tmpTime],self.timeDuration];
        self.progressSlider.value = tmpTime;
    }
}

/**
 视频缓存
 
 @param duration 缓冲值
 */
- (void)videoPlayerLoadedTimeRangeDidChange:(float)duration{
    NSLog(@"%f",duration);
}

//视频缓冲区为空
- (void)videoPlayerPlaybackBufferEmpty{
    [self.seekindicator startAnimating];
}

//视频缓存满足播放的时候调用
- (void)videoPlayerPlaybackLikelyToKeepUp{
    [self.seekindicator stopAnimating];
}

/**
 视频加载失败
 
 @param error 失败原因
 */
- (void)videoPlayerDidFailWithError:(NSError *)error{

}

- (void)destoryPlayer{
    //播放结束后销毁播放器
    [self.controlPlayer videoPlayerDestory];
}

- (float)getDurationWithVideo:(NSURL *)videoUrl{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts];
    float second = 0.0;
    second = urlAsset.duration.value / urlAsset.duration.timescale;
    return second;
}

- (NSString *)convertTime:(CGFloat)time{
    int seconds = (int)time;
    int minute = seconds/60;
    int second = seconds%60;
    NSString * format_time = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    return format_time;
}

- (void)addMasnory{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).offset = DISTANCE;
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    [self.controlModelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView.mas_right).offset = - DISTANCE;
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    [self.playModelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.controlModelBtn.mas_left).offset = - DISTANCE;
        make.centerY.mas_equalTo(self.controlModelBtn.mas_centerY);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset = DISTANCE;
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.playOrPauseBtn.mas_right).offset = 10;
        make.right.mas_equalTo(self.timeLabel.mas_left).offset = -5;
    }];
    
    [self.seekindicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(37);
    }];
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _bottomView;
}

- (UISlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumValue = 0.0;
        _progressSlider.value = 0.0;
        _progressSlider.minimumTrackTintColor = [UIColor redColor];
        [_progressSlider addTarget:self action:@selector(updateProgressChange:) forControlEvents:UIControlEventTouchUpInside];
        [_progressSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}

- (UIButton *)playModelBtn{
    if (!_playModelBtn) {
        _playModelBtn = [[UIButton alloc] init];
        [_playModelBtn setTitle:@"观看模式" forState:UIControlStateNormal];
        [_playModelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playModelBtn addTarget:self.delegate action:@selector(changePlayModel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playModelBtn;
}

- (UIButton *)controlModelBtn{
    if (!_controlModelBtn) {
        _controlModelBtn = [[UIButton alloc] init];
        [_controlModelBtn setTitle:@"控制模式" forState:UIControlStateNormal];
        [_controlModelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_controlModelBtn addTarget:self.delegate action:@selector(changeControlModel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlModelBtn;
}

- (UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [[UIButton alloc] init];
        [_playOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_playOrPauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self.delegate action:@selector(closeVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"00:00/00:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)seekindicator
{
    if (!_seekindicator) {
        _seekindicator = [[UIActivityIndicatorView alloc] init];
        [_seekindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _seekindicator.hidesWhenStopped = YES;
    }
    return _seekindicator;
}




@end
