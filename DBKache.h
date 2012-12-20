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

#import <Foundation/Foundation.h>

@interface DBKache : NSObject

+(DBKache*)sharedDBKacheManager;

-(void)eraseKache;
-(void)removeObjFromKacheForKey:(id)key;
-(void)kacheObject:(id)obj ForKey:(id)key;
-(void)setNewKey:(id)nKey ForKey:(id)key;
-(void)kacheTargetFromUrl:(id)targetURL withBlock:(void(^)(NSData *data))block andRemoveItAfter:(NSNumber*)removeTime;

-(id)getObjectFromKacheForKey:(id)key;

-(UIImage*)getImageFromKacheForKey:(id)key;

@end
