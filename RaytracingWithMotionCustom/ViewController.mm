//
//  ViewController.m
//  RaytracingWithMotionCustom
//
//  Created by Ruben Glapa on 4/13/25.
//
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <TargetConditionals.h>
#import "ViewController.h"
#import "Renderer.h"

@implementation ViewController
{
    MTKView *_view;
    
    Renderer *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view = (MTKView *)self.view;
    
    NSArray<id<MTLDevice>> *devices = MTLCopyAllDevices();
    
    id<MTLDevice> selectedDevice;
    
    for(id<MTLDevice> device in devices)
    {
        if (device.supportsRaytracing)
        {
            if (!selectedDevice || !device.isLowPower)
            {
                selectedDevice = device;
            }
        }
    }
    _view.device = selectedDevice;
    
    NSLog(@"Selected Device: %@", _view.device.name);
    
    NSAssert(_view.device && _view.device.supportsRaytracing,
             @"Ray tracing isn't supported on this device");
    
#if defined(MTL_SUPPORT_PRIMITIVE_MOTION_QUERY) && MTL_SUPPORT_PRIMITIVE_MOTION_QUERY
    BOOL usePrimitiveMotion = _view.device.supportsPrimitiveMotionBlur;
#else
    BOOL usePrimitiveMotion = false;
#endif

#if TARGET_OS_IPHONE
    _view.backgroundColor = UIColor.blackColor;
#endif
    _view.colorPixelFormat = MTLPixelFormatRGBA16Float;

    Scene *scene = [Scene newMotionBlurSceneWithDevice:_view.device
                                    usePrimitiveMotion:usePrimitiveMotion];

    _renderer = [[Renderer alloc] initWithDevice:_view.device
                                           scene:scene
                              usePrimitiveMotion:usePrimitiveMotion];

    [_renderer mtkView:_view drawableSizeWillChange:_view.bounds.size];

    _view.delegate = _renderer;

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
