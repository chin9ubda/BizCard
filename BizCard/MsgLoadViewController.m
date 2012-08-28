//
//  MsgLoadViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "MsgLoadViewController.h"
#import "Msg_Cell.h"

@interface MsgLoadViewController ()

@end

@implementation MsgLoadViewController


/* -----------------------------------------------------
   DataBase Class getInstance;
   Msg GetIds
   nowType Init
   nowType = 0 SMS
   nowType = 1 Email
   ----------------------------------------------------- */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        msgArray = [db getMsgIds];
        nowType = 0;
    }
    return self;
}


/* -----------------------------------------------------
   Tabbar Hide
   ----------------------------------------------------- */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];


    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



//------------------ Cancel Btn Event ------------------//

/* -----------------------------------------------------
   Tabbar Show
   NowViewController Dismiss
   ----------------------------------------------------- */

- (IBAction)cancelBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}


//------------------ Cancel Btn Event ------------------//

/* -----------------------------------------------------
 Tabbar Show
 NowViewController Dismiss
 ----------------------------------------------------- */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return msgArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    
    Msg_Cell *msg_cell = (Msg_Cell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    
    if(msg_cell == nil){
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"Msg_Cell" owner:nil options:nil];
        msg_cell = [array objectAtIndex:0];
        msg_cell.frame = CGRectMake(0, 0, 0, 0);
    }
    msg_cell.textLabel.text = [db getMsg:[[msgArray objectAtIndex:index]integerValue]];
    
    return msg_cell;
    
}


// ---------------- TableViewCell Select Event ---------------- //

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    [self sendMsg:[db getMsg:index + 1]];
}


// ---------------- set Number or Email Array ---------------- //

-(void)setArray:(NSArray *)arry{
    bcArray = arry;
}


// ---------------- Set Type ---------------- //

/* ------------------------------------------
   nowType = 0 SMS
   nowType = 1 Email
   ------------------------------------------ */
-(void)setType:(int)type{
    nowType = type;
}



// ---------------- Set Type ---------------- //

/* ------------------------------------------
   nowType = 0 SMS
   nowType = 1 Email
    
   Body 에 입력된 Msg 를 넣고
   Recipients 에 setArray의 bcArray 를활용
   ------------------------------------------ */

-(void)sendMsg:(NSString *)msg{
    if (nowType == 0) {
        MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
        smsController.messageComposeDelegate = self;
        if([MFMessageComposeViewController canSendText])
        {
            smsController.body = msg;
            [smsController setRecipients:bcArray];
            smsController.messageComposeDelegate = self;
            [self presentModalViewController:smsController animated:YES];
        }
    }else if (nowType == 1){
        MFMailComposeViewController *mailsome = [[MFMailComposeViewController alloc] init];
        mailsome.mailComposeDelegate=self;
        if([MFMailComposeViewController canSendMail]){
            [mailsome setToRecipients:bcArray];
            [mailsome setSubject:nil];
            [mailsome setMessageBody:msg isHTML:NO];
            [self presentModalViewController:mailsome animated:YES];
        }
    }
}


// ----------- Mail Result Event ----------- //

/* -----------------------------------------
   지금은 모두 dismiss
   ----------------------------------------- */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}


// ----------- SMS Result Event ----------- //

/* -----------------------------------------
   지금은 모두 dismiss
   ----------------------------------------- */

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}

@end
