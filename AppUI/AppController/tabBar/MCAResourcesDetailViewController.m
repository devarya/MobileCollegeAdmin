//
//  MCAResourcesDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourcesDetailViewController.h"

@interface MCAResourcesDetailViewController ()

@end

@implementation MCAResourcesDetailViewController

@synthesize reDHolder, detailCell, arr_resources;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr_url = [NSMutableArray new];
    
    self.navigationItem.title = reDHolder.str_book_name;
    NSArray * arr_url_old = [reDHolder.str_url componentsSeparatedByString:@"]["];
    for(NSString* strl in arr_url_old){
        if ([strl rangeOfString:@"\\n"].location != NSNotFound) {
            NSArray *arr_str = [strl componentsSeparatedByString:@"\\n"];
            for (NSString* strs in arr_str) {
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\\[]\""];
                NSString *str = [[strs componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                [arr_url addObject:str];
            }
        }else{
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\\[]\""];
            NSString *str = [[strl componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
            [arr_url addObject:str];
        }

    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    tbl_url.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [tbl_url reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_url.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"urlCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    NSString* str = [arr_url objectAtIndex:indexPath.row];
    UIImageView *img_cat=(UIImageView *)[cell.contentView viewWithTag:1];
    [img_cat removeFromSuperview];
    img_cat = nil;
    img_cat = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 26, 26)];
    img_cat.tag = 1;
    [cell.contentView addSubview:img_cat];
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];

    if ([reDHolder.str_url rangeOfString:@"http"].location == NSNotFound) {
        UIImage *img_book = [UIImage imageNamed:@"book.png"];
        [img_cat setImage:img_book];
        lbl_catName.text = str;
    }else{
        UIImage *img_web = [UIImage imageNamed:@"web.png"];
        [img_cat setImage:img_web];
        lbl_catName.text = str;
    };
    
  //  lbl_catName.numberOfLines = 0;
   // lbl_catName.lineBreakMode = NSLineBreakByWordWrapping;
  //  [lbl_catName sizeToFit];
    
    tbl_url.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString* str = [arr_url objectAtIndex:indexPath.row];
//    CGSize widthSize = CGSizeMake(236,9999);
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    CGRect textRect = [str boundingRectWithSize:widthSize
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSParagraphStyleAttributeName: paragraphStyle.copy}
//                                         context:nil];
//    CGSize size = textRect.size;
//    CGFloat height = MAX(size.height, 42.0f);
//    return height;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [arr_url objectAtIndex:indexPath.row];
    if ([str rangeOfString:@"http"].location!= NSNotFound) {
    NSString *url = [str substringFromIndex:[str rangeOfString:@"http"].location];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}



@end
