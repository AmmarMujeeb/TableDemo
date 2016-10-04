//
//  ViewController.m
//  TableDemo
//
//  Created by ammar on 13/07/2015.
//  Copyright (c) 2015 ammar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSArray *arr;
}


@end

@implementation ViewController
@synthesize table;
NSString *strurl;

- (void)viewDidLoad {
    [super viewDidLoad];
    strurl = @"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json";
    
    // Do any additional setup after loading the view, typically from a nib.
    //arr = [NSArray arrayWithObjects:@"one",@"two", nil];
    [self fetchdata];
    self.imgv.hidden = YES;
    
}

-(void)fetchdata{
    arr = (NSArray*)[self parseJsonResponse:strurl];
    int total = (int)[arr count];
    
    if(total>=0){
        NSLog(@"arr = %@",arr);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arr count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.imgv.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"lrgpic"]]]];
    self.imgv.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text =[[arr objectAtIndex:indexPath.row] objectForKey:@"position"];
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"smallpic"]]]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"smallpic"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
        [tableView reloadData];
    }];
    return cell;
}

#pragma  mark - Json Parsing -
- (NSDictionary *)parseJsonResponse:(NSString *)urlString
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        UIAlertView *alert =
        [[UIAlertView alloc]initWithTitle:@"Error"
                                  message:[NSString stringWithFormat:@"Error : %@",error.localizedDescription]
                                 delegate:self
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    // Parsing the JSON data received from web service into an NSDictionary object
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: data
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    return JSON;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
