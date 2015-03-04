//
//  UpdateLoadPhotoTool.h
//  SmallPig
//
//  Created by clei on 15/3/4.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadPhotoTool : NSObject

- (instancetype) initWithPhotoArray:(NSArray *)array upLoadUrl:(NSString *)url upLoadType:(int)type;

@end
