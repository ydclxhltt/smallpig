//
//  RequestTool.m
//  SmallPig
//
//  Created by chenlei on 14/11/25.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "RequestTool.h"

#define TIMEOUT 15.0

@interface RequestTool()
{
    AFHTTPRequestOperation *requestOperation;
}
@end

@implementation RequestTool

//发起请求
- (void)requestWithUrl:(NSString *)url requestParamas:(NSDictionary *)paramas requestType:(RequestType)type requestSucess:(void (^)(AFHTTPRequestOperation *operation,id responseDic))sucess requestFail:(void (^)(AFHTTPRequestOperation *operation,NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer  serializer];
    //[manager.requestSerializer setValue:@"JSESSIONID=BF9C6E368CDF5012B85D60D42E921385" forHTTPHeaderField:@"cookie"];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    NSLog(@"[NSHTTPCookieStorage sharedHTTPCookieStorage]===%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
    requestOperation = [manager POST:url parameters:paramas
          success:^(AFHTTPRequestOperation *operation,id responeDic)
          {
              if ([responeDic isKindOfClass:[NSDictionary class]] || [responeDic isKindOfClass:[NSMutableDictionary class]])
              {
                  if (sucess)
                  {
                      sucess(operation,responeDic);
                  }
              }
              else
              {
                  //服务器异常
                  if (fail)
                  {
                      fail(operation,nil);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error)
          {
              if (fail)
              {
                  fail(operation,error);
              }
          }];
    
    if (RequestTypeSynchronous == type)
    {
        [requestOperation waitUntilFinished];
    }
}


//取消请求
- (void)cancelRequest
{
    if (requestOperation)
    {
        [requestOperation cancel];
        requestOperation = nil;
    }
}


@end
