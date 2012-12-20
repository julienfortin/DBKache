/*
** DBKache.h for DBKache
**
** Made by Julien Fortin
** Login <julien.fortin@epitech.eu>
** Copyright (c) 2012 Julien Fortin. All rights reserved.
**
** Started on  Wed Dec 5 2012
** Last update Wed Dec 5 2012
*/

#import "DBKache.h"

@implementation DBKache
{
    @private
    __strong NSMutableDictionary    *_kache;
    __strong NSMutableDictionary    *_queue;
}

static DBKache *sharedDBKacheManager = nil;

+(DBKache*)sharedDBKacheManager
{
    @synchronized(self)
    {
        if (!sharedDBKacheManager)
            sharedDBKacheManager = [[self alloc] init];
    }
    return sharedDBKacheManager;
}

///////////////////// INTERNAL KACHE METHODS /////////////////////

-(id)init
{
    self = [super init];
    if (self)
    {
        _kache = [[NSMutableDictionary alloc] init];
        _queue = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//////////////////////////////////////////

-(id)objIsInKache:(id)key
{
    return [_kache objectForKey:[self getStringFromKey:key]];
}

-(BOOL)objIsInQueue:(id)key
{
    return [_queue objectForKey:[self getStringFromKey:key]] ? YES : NO;
}

-(BOOL)shouldKacheObj:(id)key
{
    return [self objIsInQueue:key] || [self objIsInKache:key] ? NO : YES;
}

//////////////////////////////////////////

-(NSString*)getStringFromKey:(id)key
{
    if (key)
        return [[NSString alloc] initWithFormat:@"%@", key];
    return nil;
}

-(NSURL*)getTargetURLFormId:(id)targetURL
{
    if ([targetURL isKindOfClass:[NSURL class]])
        return (NSURL*)targetURL;
    else if ([targetURL isKindOfClass:[NSString class]])
        return [[NSURL alloc] initWithString:targetURL];
    else if ([targetURL isKindOfClass:[NSData class]])
        return [[NSURL alloc] initWithString:[[NSString alloc] initWithData:targetURL encoding:NSUTF8StringEncoding]];
    return nil;
}

-(NSData*)getTargetFromURL:(NSURL*)URL
{ 
    return [NSData dataWithContentsOfURL:URL];
}

//////////////////////////////////////////

-(void)queueObjForKey:(id)key
{
    if (key)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            if (!_queue)
                _queue = [[NSMutableDictionary alloc] init];
            [_queue setObject:key forKey:[self getStringFromKey:key]];
        });
    }
}

-(void)kacheObj:(id)obj ForKey:(id)key
{
    if (obj && key)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            if (!_kache)
                _kache = [[NSMutableDictionary alloc] init];
            [_kache setObject:obj forKey:[self getStringFromKey:key]];
            [self removeFromQueueForKey:key];
        });
    }
}

-(void)removeFromKacheForKey:(id)key
{
    if (key)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            [_kache removeObjectForKey:[self getStringFromKey:key]];
        });
    }
}

-(void)removeFromQueueForKey:(id)key
{
    if (key)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            [_queue removeObjectForKey:[self getStringFromKey:key]];
        });
    }
}

-(void)removeObjFromKacheByTimer:(id)timer
{
    id key = [[timer userInfo] valueForKey:@"key"];
    if (key)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            [_kache removeObjectForKey:[self getStringFromKey:key]];
        });
    }
}

-(void)removeObjFromKacheWithTimer:(NSArray*)array
{
    [NSTimer scheduledTimerWithTimeInterval:[(NSNumber*)[array objectAtIndex:1] integerValue] target:self selector:@selector(removeObjFromKacheByTimer:)
                                   userInfo:[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:[array objectAtIndex:0]] forKeys:[NSArray arrayWithObject:@"key"]] repeats:NO];
}

//////////////////////////////////////////

-(void)performBlockOnMainThread:(NSArray*)array
{
    if (array && [array count] > 1)
        ((void(^)(NSData*))[array objectAtIndex:1])([array objectAtIndex:0]);
}

//////////////////////////////////////////

-(void)kacheTargetFromUrlWithBlock:(NSArray*)array
{
    NSUInteger count = [array count];
    if (array && count)
    {
        NSURL       *targetURL  = [array objectAtIndex:0];
        NSData      *data       = [self getTargetFromURL:targetURL];
        NSNumber    *time       = [array objectAtIndex:1];
        
        data = data.length ? data : nil;
        
        [self kacheObj:data ForKey:targetURL];

        if (count > 1)
            [self performSelectorOnMainThread:@selector(performBlockOnMainThread:) withObject:[NSArray arrayWithObjects:data, [array objectAtIndex:2], nil] waitUntilDone:NO];
        
        if ([time integerValue] > 0)
        {
            [self performSelectorOnMainThread:@selector(removeObjFromKacheWithTimer:) withObject:[NSArray arrayWithObjects:targetURL, time, nil] waitUntilDone:NO];
        }
    }
    [NSThread exit];
}

///////////////////// INSTANCE KACHE METHODS /////////////////////

-(void)eraseKache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
    ^{
        _kache = nil;
        _queue = nil;
    });
}

-(void)removeObjFromKacheForKey:(id)key
{
    if (!key)
        return;
    [self removeFromKacheForKey:key];
    [self removeFromQueueForKey:key];
}

-(void)setNewKey:(id)nKey ForKey:(id)key
{
    id obj = [self objIsInKache:key];
    if (obj)
    {
        [self removeObjFromKacheForKey:key];
        [self kacheObject:obj ForKey:nKey];
    }
}

//////////////////////////////////////////

-(id)getObjectFromKacheForKey:(id)key
{
    if (!key)
        return nil;
    return [self objIsInKache:key];
}

-(UIImage*)getImageFromKacheForKey:(id)key
{
    if (!key)
        return nil;
    id obj = [self getObjectFromKacheForKey:key];
    if ([obj isKindOfClass:[UIImage class]])
        return (UIImage*)obj;
    else if ([obj isKindOfClass:[NSData class]])
        return [UIImage imageWithData:obj];
    else if ([obj isKindOfClass:[UIImageView class]])
        return (UIImage*)((UIImageView*)obj).image;
    return nil;
}

//////////////////////////////////////////

-(void)kacheObject:(id)obj ForKey:(id)key
{
    if (!key)
        return;
    [self kacheObj:obj ForKey:key];
}

-(void)kacheTargetFromUrl:(id)targetURL withBlock:(void(^)(NSData *data))block andRemoveItAfter:(NSNumber*)removeTime
{
    if (!targetURL)
        return;
    void (^__strong b)(NSData*) = [block copy];
    
    if ([self shouldKacheObj:targetURL])
    {
        [self queueObjForKey:targetURL];
        [[[NSThread alloc] initWithTarget:self selector:@selector(kacheTargetFromUrlWithBlock:) object:[NSArray arrayWithObjects:[self getTargetURLFormId:targetURL], removeTime, b, nil]] start];
    }
    else if (block)
        block([self objIsInKache:targetURL]);
}

@end
