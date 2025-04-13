//
//  Renderer.h
//  RaytracingWithMotionCustom
//
//  Created by Ruben Glapa on 4/13/25.
//

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import "Scene.h"

@interface Renderer : NSObject <MTKViewDelegate>

- (instancetype)initWithDevice:(id<MTLDevice>)device
                         scene:(Scene *)scene
            usePrimitiveMotion:(BOOL)usePrimitiveMotion;

@end
