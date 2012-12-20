# DBKache
*An user-friendly cache.*

The easy way to cache data (downloaded asynchronously from the internet or not), what ever you want in your App. Access the cache data everywhere in your code.

### DBKache 2.0.0
 * An asynchronous data download. 
 * no several download for the same URL.
 * A non blocked main thread.
 * Use block to be notified when cache is complete.
 * Possibility to set a lifetime to a caching object

## How to use it

It's very easy to get started using DBKache just download the 2 files:
 * DBKache.m
 * DBKache.h

Drag/Add it in your project then it's almost ready to answer your needs.

##### Everywhere you want to access the cache data simple import DBKache.m in your source file.

```objective-c
#import "DBKache.h"
```

#### Usefull methods

##### -(void)kacheTargetFromUrl:withBlock:andRemoveItAfter:

```ojbective-c
[[DBKache sharedDBKacheManager] kacheTargetFromUrl:@"http://fever42.net/smth/resouceToDownload" withBlock:^(NSData *data)
{
  if (data)
  {
    // To get an UIImage
    UIImage *img = [UIImage imageWithData:data];
  }
  else
  { ... }
} andRemoveItAfter:[[NSNumber alloc] initWithInt:42]];
```
This method will download the resource targeted by an URL, then execute the specified block and remove the caching datas after n second(s).
Arguments are the following:
 * An id which is an (NSString, NSURL, NSData) URL (required);
 * A block which receive a NSData such as : ^(NSData *data){} (can be nil);
 * A NSNumber which represent the time interval until the object is cache is remove. Passing a value < 0 mean that DBKache will not remove automatically this object.

##### -(void)kacheObject:ForKey:

```ojbective-c
[[DBKache sharedDBKacheManager] kacheObject:obj ForKey:@"michelsardou"];
```
This method will cache an object with a unique key.


##### -(id)getObjectFromKacheForKey:

```ojbective-c
id obj = [[DBKache sharedDBKacheManager] getObjectFromKacheForKey:@"jeanjacquesgoldman"];
```

This method will return an `id` if any data are save in the DBKache for the specified key. Otherwise it return nil.
####### You may use this method to test if the needed data are in cache.


##### -(UIImage*)getImageFromKacheForKey:

```ojbective-c
 UIImage *img  = [[DBKache sharedDBKacheManager] getImageFromKacheForKey:@"http://lamasticot.fr/logo.png"]
```
If you want to extract an `UIImage` from the cache just use this method. Do not forget to specified a valid key.


##### -(void)setNewKey:ForKey:

```ojbective-c
[[DBKache sharedDBKacheManager] setNewKey:@"myNewKey" ForKey:@"myOldKey"];
```
Rename a key.


##### -(void)removeObjFromKacheForKey:

```ojbective-c
[[DBKache sharedDBKacheManager] removeObjFromKacheForKey:@"http://lamasticot.fr/logo.png"];
```
Remove manually an object in cache.


##### -(void)eraseKache

```ojbective-c
[[DBKache sharedDBKacheManager] eraseKache];
```
Remove the whole cache.


## Requirements

 * Xcode 4+
 * ARC

## They use DBKache

* [WoozonTV](https://itunes.apple.com/fr/app/woozontv/id569099995?mt=8&ign-mpt=uo%3D4)
* And more others !

## Credits

All DBKache's source code is free to use, free to share, free to modify for any purpose.


Please forgive my english.

If you have any suggestions and comments please feel free to email me at: julien.fortin@epitech.eu or via my personal website http://www.fever42.net/
