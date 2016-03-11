//
//  SearchDisPlayerController.m
//  highlight
//
//  Created by xiayong on 16/3/11.
//  Copyright © 2016年 xiayong. All rights reserved.
//

#import "SearchDisPlayerController.h"
#import "ZYTokenManager.h"

#define fontCOLOR [UIColor colorWithRed:163/255.0f green:163/255.0f blue:163/255.0f alpha:1]

@interface SearchDisPlayerController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)IBOutlet UITableView * myTableView;
@property (nonatomic,strong)IBOutlet UIView * navView;
@property (nonatomic,strong)IBOutlet UITextField * searchText;

@property (nonatomic,strong)NSMutableArray * searchHistory;
@property (nonatomic,strong)NSArray *myArray;//搜索记录的数组

@end

@implementation SearchDisPlayerController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self readNSUserDefaults];
}
-(void)viewDidLoad{
    
    _searchHistory = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.myTableView.backgroundColor = BGCOLOR;
    self.searchText.returnKeyType = UIReturnKeySearch;//更改键盘的return
    self.searchText.delegate = self;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(IBAction)cancelBtn:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{//搜索方法
    if (textField.text.length > 0) {
        
        [ZYTokenManager SearchText:textField.text];//缓存搜索记录
        [self readNSUserDefaults];
        
    }else{
        NSLog(@"请输入查找内容");
    }
    
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (_myArray.count>0) {
            return _myArray.count+1+1;
        }else{
            return 1;
        }
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(indexPath.row ==0){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"历史搜索";
            cell.textLabel.textColor = fontCOLOR;
            return cell;
        }else if (indexPath.row == _myArray.count+1){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"清除历史记录";
            cell.textLabel.textColor = fontCOLOR;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }else{
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
        NSArray* reversedArray = [[_myArray reverseObjectEnumerator] allObjects];
        cell.textLabel.text = reversedArray[indexPath.row-1];
        return cell;
        }
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
    return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.myTableView.estimatedRowHeight = 44.0f;
//    self.searchTableView.estimatedRowHeight = 44.0f;
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _myArray.count+1) {//清除所有历史记录
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除历史记录" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        //@“ UIAlertControllerStyleAlert，改成这个就是中间弹出"
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [ZYTokenManager removeAllArray];
            _myArray = nil;
            [self.myTableView reloadData];
        }];
        //            UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        //            [alertController addAction:archiveAction];
            [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
}


-(void)readNSUserDefaults{//取出缓存的数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:@"myArray"];
    self.myArray = myArray;
    [self.myTableView reloadData];
    NSLog(@"myArray======%@",myArray);
}


@end
