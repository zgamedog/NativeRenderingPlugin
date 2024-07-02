//
//  metallib.m
//  metallib
//
//  Created by sunborn-gf2 on 2024/6/27.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "metallib.h"
#import "MetalFX/MetalFX.h"
//@import  MetalKit;

@implementation metallib

static bool metalfxInited =false;
static MTLFXSpatialScalerDescriptor* des;
static id <MTLFXSpatialScaler> ssc ;

+(void) ApplyMetalFx:(nonnull id<MTLDevice>) _device InTex:(nonnull id<MTLTexture>) inTex OutTex:(nonnull id<MTLTexture>) outTex
       CommandBuffer:(    id<MTLCommandBuffer>) cb
{
    if( metalfxInited ==false )
    {
        metalfxInited =true;
        des = [MTLFXSpatialScalerDescriptor alloc];
        des.inputWidth = inTex.width;
        des.inputHeight = inTex.height;
        des.outputWidth = outTex.width;
        des.outputHeight = outTex.height;
        des.colorTextureFormat = inTex.pixelFormat;
        des.outputTextureFormat = outTex.pixelFormat;
        des.colorProcessingMode = MTLFXSpatialScalerColorProcessingModePerceptual;
        //MTLFXSpatialScalerColorProcessingModeLinear
        
        ssc = [des newSpatialScalerWithDevice:_device];
    }
    
    ssc.inputContentWidth = inTex.width;
    ssc.inputContentHeight = inTex.height;
    ssc.colorTexture = inTex;
    ssc.outputTexture = outTex;
    [ssc encodeToCommandBuffer:cb];
    
}


@end
