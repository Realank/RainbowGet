//
//  RLKTTS.m
//  TTS
//
//  Created by Realank on 2017/8/2.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "RLKTTS.h"
#import <AVFoundation/AVFoundation.h>
@interface RLKTTS ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, copy) void(^completeBlock)();
@property (nonatomic, strong) AVSpeechSynthesizer *synth;

@end
@implementation RLKTTS

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+ (void)speekChinese:(NSString*)chinese complete:(void(^)())completeBlock{
    [[self sharedInstance] speekChinese:chinese complete:completeBlock];
}

+ (void)stop{
    [[self sharedInstance] stop];
}

- (void)stop{
    [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    _synth = nil;
}

- (void)speekChinese:(NSString*)chinese complete:(void(^)())completeBlock{
    if (chinese.length == 0) {
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    _completeBlock = completeBlock;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:chinese];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voice;
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.07;
    utterance.volume = 0.7;
    utterance.pitchMultiplier = 0.6;
    utterance.postUtteranceDelay = 1.2;
    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    _synth = [[AVSpeechSynthesizer alloc]init];
    _synth.delegate = self;
    [_synth speakUtterance:utterance];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_completeBlock) {
        _completeBlock();
        _completeBlock = nil;
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_completeBlock) {
        _completeBlock();
        _completeBlock = nil;
    }
}


@end
