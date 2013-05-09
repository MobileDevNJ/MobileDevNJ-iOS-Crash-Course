//
//  MDNJViewController.m
//  JokeMachine
//
//  Created by Neo on 5/7/13.
//  Copyright (c) 2013 MobileDevNJ. All rights reserved.
//

#import "MDNJViewController.h"

@interface MDNJViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *btnJokes;

@property (strong, nonatomic) NSString *myName;

@end

@implementation MDNJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myName = [[NSString alloc] init];
}

- (IBAction)actionEndOfEditing:(UITextField*)sender {
    self.myName = sender.text;
    self.navigationItem.title=_myName;

    [sender resignFirstResponder];
    sender.hidden=TRUE;
    sender.text=@"";
}

- (IBAction)btnChangeName:(id)sender {
    self.txtName.hidden=FALSE;
    [self.txtName becomeFirstResponder];
}

- (IBAction)actionGetJokes:(id)sender {
    NSString *urlString = @"http://api.icndb.com/jokes/random";
    NSArray *nameArray = [NSArray array];
    NSError *error;
    
    if (_myName.length > 0) {
        nameArray = [_myName componentsSeparatedByString:@" "];
        urlString = [urlString stringByAppendingFormat:@"?firstName=%@",nameArray[0]];
        
        if ([nameArray count] > 1) {
            urlString = [urlString stringByAppendingFormat:@"&lastName=%@",[nameArray lastObject]];
        }
    }

    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    // Will hold response from Server
    NSURLResponse *urlResponse;
    // Call Joke API
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    if (!error) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSString *jsonString = [[json objectForKey:@"value"] objectForKey:@"joke"];
        
        self.txtView.text = jsonString;

    } else {
        self.txtView.text = @"No Joke For You!";
    }
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
