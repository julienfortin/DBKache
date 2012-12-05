//
//  DBKacheImage.h
//  ClicClac
//
//  Created by MacMniLeankr on 29/11/12.
//  Copyright (c) 2012 Leankr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBKache : NSObject

+(DBKache*)sharedDBKacheManager;

-(void)eraseKache;
-(void)removeObjFromKacheForKey:(id)key;
-(void)kacheObject:(id)obj ForKey:(id)key;
-(void)kacheTargetFromUrl:(id)targetURL withBlock:(void(^)(NSData *data))block andRemoveItAfter:(NSNumber*)removeTime;

-(id)getObjectFromKacheForKey:(id)key;

-(UIImage*)getImageFromKacheForKey:(id)key;

@end
