//
//  UpdateLoadPhotoTool.m
//  SmallPig
//
//  Created by clei on 15/3/4.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "UpLoadPhotoTool.h"
#import "AFNetworking.h"

@interface UpLoadPhotoTool()
{
    AFHTTPRequestOperation *requestOperation;
}
@property(nonatomic, strong) NSString *upLoadUrl;
@property(nonatomic, strong) NSArray *photoArray;
@property(nonatomic, assign) int type;
@end

@implementation UpLoadPhotoTool

- (instancetype) initWithPhotoArray:(NSArray *)array upLoadUrl:(NSString *)url  upLoadType:(int)type
{
    self = [super init];
    
    if (self)
    {
        self.photoArray = array;
        url = (url) ? url : @"";
        self.upLoadUrl = url;
        self.type = type;
        [self upLoadPhotos];
    }
    return self;
}


- (void)upLoadPhotos
{
    if (!self.photoArray || [self.photoArray count] == 0)
        return;
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
        ^{
            for (int i = 0; i < [self.photoArray count]; i++)
            {
                [self upLoadPhotoWithImage:self.photoArray[i] upLoadType:self.type];
            }
        });
    }
}


- (void)upLoadPhotoWithImage:(UIImage *)image upLoadType:(int)type
{
    //上传图片
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer  serializer];
    //manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    NSLog(@"[NSHTTPCookieStorage sharedHTTPCookieStorage]===%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
    requestOperation =  [manager POST:self.upLoadUrl parameters:@{@"category":@(type)}
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        if (!image)
        {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFormData:data name:@"file"];
        }

    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"responseObject===%@",responseObject);
        NSLog(@"operationresponseObject===%@",operation.responseString);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"error===%@",error);
    }];
    //添加进度
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         
     }];
    
}

@end
