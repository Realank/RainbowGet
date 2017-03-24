//
//  AudioPlaybackTool.h
//  RainbowGet
//
//  Created by Realank on 2017/3/24.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlaybackTool : NSObject

+(instancetype) sharedInstance;

- (BOOL)loadAudioFile:(NSString*)filename;
- (BOOL)playLoadedAudioFileFromTime:(NSTimeInterval)from withDuration:(NSTimeInterval)duration complete:(void(^)())completeBlock interrupt:(void(^)())interruptBlock;
- (void)stopAndCloseFile;


- (BOOL)playbackAudioFile:(NSString*)filename fromTime:(NSTimeInterval)from withDuration:(NSTimeInterval)duration;

@end
