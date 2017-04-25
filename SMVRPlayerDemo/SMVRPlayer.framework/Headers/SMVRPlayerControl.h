//
//  SMVRPlayerControl.h
//  test
//
//  Created by 高雅楠 on 2017/4/18.
//  Copyright © 2017年 com.samonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//可调节视角远近变量值
#define SMVRNear 0.55f

typedef enum : NSUInteger {
    nomalVideo,
    panoramaVideo,
} VideoModel;

typedef enum : NSUInteger {
    normalModel,
    glassModel,
} PanoramaModel;

typedef enum : NSUInteger {
    gestureModel,
    gravityModel,
    allModel
} ControlModel;

@protocol SMVRVideoPlayerControlStateDelegate <NSObject>

//视频可以播放
- (void)videoPlayerIsReadyToPlay;

//视频播放完成
- (void)videoPlayerDidReachEnd;

/**
 视频进度变化

 @param cmTime 变化值
 */
- (void)videoPlayerTimeDidChange:(CMTime)cmTime;

/**
 视频缓存

 @param duration 缓冲值
 */
- (void)videoPlayerLoadedTimeRangeDidChange:(float)duration;

//视频缓冲区为空
- (void)videoPlayerPlaybackBufferEmpty;

//视频缓存满足播放的时候调用
- (void)videoPlayerPlaybackLikelyToKeepUp;

/**
 视频加载失败

 @param error 失败原因
 */
- (void)videoPlayerDidFailWithError:(NSError *)error;
@end

@interface SMVRPlayerControl : NSObject

@property (nonatomic, assign) id<SMVRVideoPlayerControlStateDelegate>delegate;

//视频地址
- (void)setVideoUrl:(NSURL *)url;

/**
 视频类型

 @param type 普通/全景
 */
- (void)setVideoModel:(VideoModel)type;

/**
 全景模式

 @param type 普通模式/眼镜模式
 */
- (void)setPanoramaModel:(PanoramaModel)type;

/**
 控制模式

 @param type 手势控制/重力控制/全部模式
 */
- (void)setControlModel:(ControlModel)type;

/**
 设置视频容器

 @param vc 控制器
 @param view 视频界面
 */
- (void)setController:(UIViewController *)vc withView:(UIView *)view;

/**
 是否支持缩放

 @param isSupport 布尔值
 */
- (void)setSupportPinch:(BOOL)isSupport;

//配置播放器
- (void)setUp;

//播放
- (void)videoPlay;

//暂停
- (void)videoPause;

//销毁播放器
- (void)videoPlayerDestory;

//跳转进度
- (void)videoSeekToTime:(float)timeValue;

/**
 改变观看模式

 @param model 手势控制/重力控制
 */
- (void)changePanoramaModel:(PanoramaModel)model;

/**
 改变控制模式

 @param model 手势控制/重力控制/全部模式
 */
- (void)changeControlModel:(ControlModel)model;
@end
