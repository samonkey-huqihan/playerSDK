//
//  PlayViewController.m
//  SMVRPlayerDemo
//
//  Created by 高雅楠 on 2017/4/19.
//  Copyright © 2017年 com.samonkey. All rights reserved.
//

#import "PlayViewController.h"
#import "SMVRPlayer.h"

@interface PlayViewController ()<SMVRPlayerDelegate>

@property (nonatomic, strong) SMVRPlayer *player;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.player = [[SMVRPlayer alloc] initWithFrame:self.view.frame withUrl:self.url withNormalVideo:self.isNormalVideo withViewController:self];
    self.player.delegate = self;
    [self.view addSubview:self.player];
    typeof(self) __weak weakSelf = self;
    self.player.endBlock = ^(){
        [weakSelf closeVideo];
    };
}

- (void)changePlayModel{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"观看模式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *normalModel = [UIAlertAction actionWithTitle:@"普通模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.player changeLookMethod:0];
    }];
    
    UIAlertAction *glassModel = [UIAlertAction actionWithTitle:@"眼镜模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.player changeLookMethod:1];
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    [alertVc addAction:normalModel];
    [alertVc addAction:glassModel];
    [alertVc addAction:cancle];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)changeControlModel{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"控制模式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *gestureModel = [UIAlertAction actionWithTitle:@"手势模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.player changeControlMethod:0];
    }];
    
    UIAlertAction *gravityModel = [UIAlertAction actionWithTitle:@"重力模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.player changeControlMethod:1];
    }];
    
    UIAlertAction *allModel = [UIAlertAction actionWithTitle:@"全部模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.player changeControlMethod:2];
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    [alertVc addAction:gestureModel];
    [alertVc addAction:gravityModel];
    [alertVc addAction:allModel];
    [alertVc addAction:cancle];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)closeVideo{
    [self.player destoryPlayer];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"byebye");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
