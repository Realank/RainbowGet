//
//  AudioPlaybackTool.m
//  RainbowGet
//
//  Created by Realank on 2017/3/24.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "AudioPlaybackTool.h"
#import <AVFoundation/AVFoundation.h>
@interface AudioPlaybackTool ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSTimer *audioTimer;

@property (nonatomic, assign) BOOL shouldKeepReadyWhenPause;

@property (nonatomic, copy) void (^completeBlock)();
@property (nonatomic, copy) void (^interruptBlock)();
@end

@implementation AudioPlaybackTool

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    
    if (self = [super init]) {
        
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    
    return self;
}

- (BOOL)loadAudioFile:(NSString*)filename{
    if (_audioPlayer || _audioTimer) {
        [self stopAndCloseFile];
    }
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
//    _completeBlock = nil;
//    _interruptBlock = nil;
    NSString *urlStr=[[NSBundle mainBundle]pathForResource:filename ofType:@"mp3"];
    if (urlStr.length == 0) {
        NSLog(@"not found");
        return NO;
    }
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    NSError *error=nil;
    if (!url) {
        NSLog(@"not found");
        return NO;
    }
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        return NO;
    }
    //设置播放器属性
    _audioPlayer.numberOfLoops=0;//设置为0不循环
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];//加载音频文件到缓存
    return YES;
}

- (BOOL)playLoadedAudioFileFromTime:(NSTimeInterval)from withDuration:(NSTimeInterval)duration complete:(void(^)())completeBlock interrupt:(void(^)())interruptBlock{
    if (!_audioPlayer) {
        return NO;
    }
    if (_audioTimer) {
        [_audioTimer invalidate];
        _audioTimer = nil;
    }
    _completeBlock = completeBlock;
    _interruptBlock = interruptBlock;
    _audioPlayer.currentTime = from;
    BOOL success = [_audioPlayer play];
    if (!success) {
        [self stopAndCloseFile];
        return NO;
    }
    _audioTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(_stopPlayback) userInfo:nil repeats:NO];
    _shouldKeepReadyWhenPause = YES;
    return YES;
}

- (void)_stopPlayback{
    if (_audioTimer) {
        [_audioTimer invalidate];
        _audioTimer = nil;
    }
    
    
    
    if (_shouldKeepReadyWhenPause) {
        [_audioPlayer pause];
        if (_completeBlock) {
            _completeBlock();
        }
    }else{
        if (_completeBlock) {
            _completeBlock();
        }
        [self stopAndCloseFile];
    }
    
}

- (void)stopAndCloseFile{
    [_audioPlayer stop];
    _audioPlayer = nil;
    [_audioTimer invalidate];
    _audioTimer = nil;
    _completeBlock = nil;
    _interruptBlock = nil;
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (BOOL)playbackAudioFile:(NSString*)filename fromTime:(NSTimeInterval)from withDuration:(NSTimeInterval)duration complete:(void(^)())completeBlock interrupt:(void(^)())interruptBlock{
    
    BOOL success = [self loadAudioFile:filename];
    if (!success) {
        return NO;
    }
    
    success = [self playLoadedAudioFileFromTime:from withDuration:duration complete:^{
        if (completeBlock) {
            completeBlock();
        }
    } interrupt:^{
        if (interruptBlock) {
            interruptBlock();
        }
    }];
    
    _shouldKeepReadyWhenPause = NO;
    return success;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    [self _stopPlayback];
}

-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        NSString* description = portDescription.portType.lowercaseString;
        if ([description containsString:@"headphone"] || [description containsString:@"bluetooth"]) {
            if (_interruptBlock) {
                _interruptBlock();
            }
            [self _stopPlayback];
        }
    }
}

@end
