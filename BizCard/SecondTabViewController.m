//
//  SecondTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "SecondTabViewController.h"

@interface SecondTabViewController ()

@end

@implementation SecondTabViewController
@synthesize msgTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        msgArray = [db getMsgIds];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"msgTableReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgTableReload) name:@"msgTableReload" object:nil];}

- (void)viewDidUnload
{
    [self setMsgTable:nil];
    [super viewDidUnload];
    db = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// --------------- Msg Table Count Return --------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return msgArray.count;
    
}


// --------------- Msg TableViewCell Setting --------------- //

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    
    msg_cell = (Msg_Cell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    
    if(msg_cell == nil){
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"Msg_Cell" owner:nil options:nil];
        msg_cell = [array objectAtIndex:0];
        msg_cell.frame = CGRectMake(0, 0, 0, 0);
    }
    
    msg_cell.msgLabel.text = [db getMsg:[[msgArray objectAtIndex:index]integerValue]];
    
    return msg_cell;
    
}


// --------------- Cell Select Event --------------- //

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    //    NSLog(@"%@", [db getMsg:index + 1]);
    addMsgBtn = [[Add_MsgViewController alloc]init];
    [addMsgBtn setId:[[msgArray objectAtIndex:index] integerValue]];
    [addMsgBtn setTextView:[db getMsg:[[msgArray objectAtIndex:index] integerValue]]];
//    [self.view insertSubview:addMsgBtn.view aboveSubview:self.view];
    [self presentModalViewController:addMsgBtn animated:YES];
}



// --------------- Msg TableView Reload --------------- //

-(void)msgTableReload{
    NSLog(@"msgTableReload");
    msgArray = [db getMsgIds];
    [msgTable reloadData];
}


// --------------- Msg Add Btn Event --------------- //

- (IBAction)addMsg:(id)sender {
    addMsgBtn = [[Add_MsgViewController alloc]init];
    [addMsgBtn setTextView:@""];
    
    [self presentModalViewController:addMsgBtn animated:YES];
//    [self.view insertSubview:addMsgBtn.view aboveSubview:self.view];
}

@end
