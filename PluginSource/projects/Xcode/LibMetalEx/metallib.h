//
//  metallib.h
//  metallib
//
//  Created by sunborn-gf2 on 2024/6/27.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface metallib : NSObject


+(void) ApplyMetalFx:(nonnull id<MTLDevice>) _device 
               InTex:(nonnull id<MTLTexture>) inTex OutTex:(nonnull id<MTLTexture>) outTex
       CommandBuffer:(nonnull id<MTLCommandBuffer>) cb;

@end
