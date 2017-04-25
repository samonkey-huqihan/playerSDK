//
//  ViewController.m
//  SMVRPlayerDemo
//
//  Created by 高雅楠 on 2017/4/19.
//  Copyright © 2017年 com.samonkey. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTf;
@property (nonatomic, assign) BOOL videoType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.urlTf endEditing:YES];
}
- (IBAction)localNormalPlay:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"oooo" ofType:@"mp4"];
    self.videoType = YES;
    [self pushPlayerVC:[NSURL fileURLWithPath:path]];
}

- (IBAction)localVRPlay:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iiii" ofType:@"mp4"];
    self.videoType = NO;
    [self pushPlayerVC:[NSURL fileURLWithPath:path]];
}

- (IBAction)netNormalPlay:(UIButton *)sender {
    if (self.urlTf.text.length == 0) {
        [self promptMsg];
        return;
    }
    self.videoType = YES;
    [self pushPlayerVC:[NSURL URLWithString:self.urlTf.text]];
    
}

- (IBAction)netVRPlay:(UIButton *)sender {
    if (self.urlTf.text.length == 0) {
        [self promptMsg];
        return;
    }
    self.videoType = NO;
    [self pushPlayerVC:[NSURL URLWithString:self.urlTf.text]];
}

- (void)promptMsg{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入视频地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [alertVc addAction:okAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)pushPlayerVC:(NSURL *)url{
    PlayViewController *playVc = [[PlayViewController alloc] init];
    playVc.url = url;
    playVc.isNormalVideo = self.videoType;
    [self presentViewController:playVc animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
