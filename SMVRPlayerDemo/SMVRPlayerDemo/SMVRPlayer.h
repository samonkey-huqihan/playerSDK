//
//  SMVRPlayer.h
//  SMVRPlayerDemo
//
//  Created by 高雅楠 on 2017/4/19.
//  Copyright © 2017年 com.samonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMVRPlayerDelegate <NSObject>

- (void)closeVideo;

- (void)changePlayModel;

- (void)changeControlModel;

@end

typedef void(^VideoEndBlock)();

@interface SMVRPlayer : UIView
@property (nonatomic, assign) id<SMVRPlayerDelegate>delegate;
@property (nonatomic, copy) VideoEndBlock endBlock;

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSURL *)url withNormalVideo:(BOOL)isNormalVideo withViewController:(UIViewController *)vc;

- (void)changeLookMethod:(NSInteger)type;

- (void)changeControlMethod:(NSInteger)type;

- (void)destoryPlayer;
@end
