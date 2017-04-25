# SMVRPlayerDemo

#版本:v1.0

SMVRPlayerDemo

使用说明：

此静态库提供本地和网络环境下普通视频和全景视频的播放
支持：
    1、全景手势旋转和陀螺仪模式
    2、观看模式有全屏和眼镜模式
    3、支持画面缩放功能

注：此静态库不提供UI界面，只提供播放功能及相关方法回调，您可自定义播放界面。
   具体使用方法请参考demo和静态库的接口。

# 将SMVRPlayer.framework和vrlibraw.bundle导入项目中
# 导入头文件 #import <SMVRPlayer/SMVRPlayerControl.h>

# 普通视频播放方法
self.controlPlayer = [[SMVRPlayerControl alloc] init];
[self.controlPlayer setVideoUrl:url];
[self.controlPlayer setVideoModel:nomalVideo];
[self.controlPlayer setController:vc withView:self];

#功能回调
self.controlPlayer.delegate = self;

[self.controlPlayer setUp];
[self.controlPlayer videoPlay];

# 全景视频播放方法
self.controlPlayer = [[SMVRPlayerControl alloc] init];
[self.controlPlayer setVideoUrl:url];
[self.controlPlayer setController:vc withView:self];

# 视频画面是否支持缩放功能
[self.controlPlayer setSupportPinch:NO];

[self.controlPlayer setVideoModel:panoramaVideo];
[self.controlPlayer setControlModel:gestureModel];
[self.controlPlayer setPanoramaModel:normalModel];
self.controlPlayer.delegate = self;
[self.controlPlayer setUp];
[self.controlPlayer videoPlay];




