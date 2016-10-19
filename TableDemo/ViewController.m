//
//  ViewController.m
//  TableDemo
//
//  Created by ammar on 13/07/2015.
//  Copyright (c) 2015 ammar. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "Reachability.h"

@interface ViewController (){
    NSArray *arr;
}


@end

@implementation ViewController
@synthesize table;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //arr = [NSArray arrayWithObjects:@"one",@"two", nil];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
        [self fetchdata];
    }
    else {
        //there-is-no-connection warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"You are not connected to Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)fetchdata{
    NSString *strurl = @"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json";
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text =[[arr objectAtIndex:indexPath.row] objectForKey:@"position"];
    cell.tag = indexPath.row;
    //    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"smallpic"]]]];
    [self updateImage:indexPath cellIs:cell];
    return cell;
}

-(void)updateImage:(NSIndexPath*)indexPath cellIs:(UITableViewCell*)cell{
    //    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"smallpic"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            cell.imageView.image = [UIImage imageWithData:data];
            [cell setNeedsLayout];
        });
        
        //[tableView reloadData];
    }];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"pushdetail"])
    {
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        //        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        //        DetailViewController *vc = [[navigationController viewControllers] lastObject];
        
        int cellno = (int)[sender tag];
        vc.imgurl = [NSURL URLWithString:[[arr objectAtIndex:cellno] objectForKey:@"smallpic"]];
        //        [vc setUrl:[NSURL URLWithString:[[arr objectAtIndex:cellno] objectForKey:@"smallpic"]]];
        //        [vc :[NSURL URLWithString:[[arr objectAtIndex:cellno] objectForKey:@"smallpic"]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
