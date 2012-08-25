//
//  ViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarViewController.h"

@interface LoginViewController : UIViewController{
    TabbarViewController *tabbarController;
}
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginBtn:(id)sender;


// Evernote 로그인 되어 있는지 확인
-(void)check_login;

// 이 어플을 위한 notebook이 있는지 확인
-(void)check_notebook;

// Notebook 만들기
-(void)createNotebook:(NSString *)notebookName;


// Evernote 로그인하기 (성공하면 앱을 들어간다)
-(void)login;
    

@end
