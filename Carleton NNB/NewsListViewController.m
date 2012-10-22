//
//  NewsListViewController.m
//  Carleton NNB
//
//  Created by Shunji Li on 12-10-21.
//  Copyright (c) 2012年 Shunji Li. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewDetailViewController.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController
@synthesize events= _events;
@synthesize parsingArray = _parsingArray;
@synthesize currentItem = _currentItem;
@synthesize currentString = _currentString;
@synthesize previousCategory = _previousCategory;
@synthesize sectionArray = _sectionArray;
@synthesize currentSection= _currentSection;
@synthesize sectionTitles=_sectionTitles;

#pragma mark -load news 

-(void) loadNews{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    self.navigationController.title = dateString;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://apps.carleton.edu/campact/nnb/show.php3?thedate=%@&style=rss", dateString];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSXMLParser *newsParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [newsParser setDelegate:self];
    _previousCategory = nil;
    _sectionArray = nil;
    _currentItem = nil;
    _currentSection = nil;
    _sectionArray = [[NSMutableArray alloc] init];
    _currentSection = [[NSMutableArray alloc] init];
    BOOL success = [newsParser parse];
    NSLog(@"count: %i", _sectionArray.count);
    // test the result
    if (success) {
        NSLog(@"sucessfully parsed");
        } else {
        NSLog(@"Error parsing document!");
    }
    
}

#pragma mark - NSXML parsing delegate method
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"item"]) {
        _currentItem = [[NewFeedItem alloc] init];
        _currentString = nil;
    }else if ([elementName isEqualToString:@"channel"]){
        //start of the xml parsing
        _parsingArray = [[NSMutableArray alloc] init];
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!_currentString) {
        // init the ad hoc string with the value
        _currentString = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [_currentString appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"channel"]) {
        _events = _parsingArray;
        //reached the end of the XML file
        return;
    }else if ([elementName isEqualToString:@"item"]){
        //reached the end of the item
        [_parsingArray addObject:_currentItem];
        [_currentSection addObject:_currentItem];
        _currentItem = nil;
        _currentString = nil;
        itemCount += 1;
    }else if ([elementName isEqualToString:@"category"]){
        
        if (!_previousCategory) {
            _previousCategory  = _currentString;
            
        }else if (![_previousCategory isEqualToString:_currentString]) {
            //inser the new cumulative count into the array
            [_sectionArray addObject:_currentSection];
             _currentSection = [[NSMutableArray alloc] init];
            _previousCategory = _currentString;
            
        }
        [_currentItem setValue:_currentString forKey:elementName];
        _currentString = nil;
    }else if ([elementName isEqualToString:@"description"]){
        _currentString  = [self escapeHTML:_currentString];
        [_currentItem setValue:_currentString forKey:elementName];
        _currentString = nil;
    }


}

-(NSString*) escapeHTML: (NSMutableString*) aString {
    NSMutableString *mutString = [NSMutableString stringWithString:aString];
    [mutString replaceOccurrencesOfString:@"&quot;" withString:@"'" options:0 range:NSMakeRange(0, mutString.length)];
    [mutString replaceOccurrencesOfString:@"&Icirc;" withString:@"'" options:0 range:NSMakeRange(0, mutString.length)];
    [mutString replaceOccurrencesOfString:@"&acirc;" withString:@"'" options:0 range:NSMakeRange(0, mutString.length)];
    [mutString replaceOccurrencesOfString:@"&amp;quot;" withString:@"'" options:0 range:NSMakeRange(0, mutString.length)];
    [mutString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, mutString.length)];
    [mutString replaceOccurrencesOfString:@"&euro;" withString:@"$" options:0 range:NSMakeRange(0, mutString.length)];

    return mutString;
}
#pragma mark -initialize

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadNews)];
    [self loadNews];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) reloadNews{
    _sectionArray = nil;
    _currentItem = nil;
    _currentSection = nil;
    [self loadNews];
    [[self tableView] reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSLog(@"%@", [_sectionTitles objectAtIndex:0]);
    return _sectionTitles;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sectionArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NewFeedItem *cellItem = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSLog(@"description: %@ \n", cellItem.description);
    //NSLog(@"category: %@ \n", cellItem.category);
    NSString *itemDescription = cellItem.description;
    cell.textLabel.text = [itemDescription substringToIndex:20];
    cell.detailTextLabel.text = [itemDescription substringFromIndex:20];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[_sectionArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"category"];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     NewDetailViewController *detailViewController = [[NewDetailViewController alloc] initWithNibName:@"NewDetailViewController" bundle:nil];
    detailViewController.item = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];

}

@end
