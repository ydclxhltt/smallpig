//
//  test.h
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_test_h
#define SmallPig_test_h

一些实例：
1.XML 请求
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest"]];
AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
    XMLParser.delegate = self;
    [XMLParser parse];
} failure:nil];
[operation start];


2.图片请求：
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
[imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];

3.图片上传处理，监测上传状态：
NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
}];
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
}];
[operation start];


4.在线流媒体请求
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/encode"]];
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
operation.inputStream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle] pathForResource:@"large-image" ofType:@"tiff"]];
operation.outputStream = [NSOutputStream outputStreamToMemory];
[operation start];

#endif
