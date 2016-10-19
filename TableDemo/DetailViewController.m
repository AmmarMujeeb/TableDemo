//
//  DetailViewController.m
//  TableDemo
//
//  Created by Ammar Mujeeb on 10/5/16.
//  Copyright © 2016 ammar. All rights reserved.
//

#import "DetailViewController.h"
#import <UAProgressView.h>

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UAProgressView *progressview;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    _progressview.hidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:_imgurl];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    self.receivedBytes += data.length;
    
    // Actual progress is
    _progressview.progress =  self.receivedBytes / self.totalBytes;
    NSLog(@"%lu",(unsigned long)self.receivedBytes);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _imgv.image = [UIImage imageWithData:self.imageData];
    _progressview.hidden = YES;

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //handle error
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
