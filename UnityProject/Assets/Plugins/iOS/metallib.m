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
static id<MTLTexture> privateTex;
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
        NSLog( @" %d ", outTex.storageMode);
        
        if(privateTex == nil)
        {
            MTLTextureDescriptor* _tdes = [MTLTextureDescriptor alloc];
            _tdes.textureType = MTLTextureType2D;
            _tdes.width = outTex.width;
            _tdes.height = outTex.height;
            _tdes.storageMode = MTLStorageModePrivate;
            _tdes.usage = outTex.usage;
            _tdes.swizzle = outTex.swizzle;
            _tdes.pixelFormat = outTex.pixelFormat;
            _tdes.depth = outTex.depth;
            _tdes.arrayLength = outTex.arrayLength;
            _tdes.sampleCount = outTex.sampleCount;
            _tdes.mipmapLevelCount = outTex.mipmapLevelCount;
            privateTex = [_device newTextureWithDescriptor:_tdes];
        }
        ssc = [des newSpatialScalerWithDevice:_device];
    }
    
    ssc.inputContentWidth = inTex.width;
    ssc.inputContentHeight = inTex.height;
    ssc.colorTexture = inTex;
    ssc.outputTexture = privateTex;
    [ssc encodeToCommandBuffer:cb];
    
    id <MTLBlitCommandEncoder> bb =  [cb blitCommandEncoder];
    
    [bb copyFromTexture:(privateTex) toTexture:(outTex)];
    
    [bb endEncoding];
}

+(void) Blit:(id<MTLDevice>)_device InTex:(id<MTLTexture>)inTex OutTex:(id<MTLTexture>)outTex CommandBuffer:(id<MTLCommandBuffer>)cb
{
    id <MTLBlitCommandEncoder> bb =  [cb blitCommandEncoder];
    
    [bb copyFromTexture:(inTex) toTexture:(outTex)];
    
    [bb endEncoding];
}
@end
