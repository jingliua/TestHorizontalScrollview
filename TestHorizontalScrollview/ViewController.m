//
//  ViewController.m
//  TestHorizontalScrollview
//
//  Created by liujing on 8/24/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

#define STATUSBAR_HEIGHT 20
#define SECTION_HEADER_HEIGHT 30
#define SCROLLVIEW_HEIGHT CGRectGetHeight(self.view.frame)-STATUSBAR_HEIGHT-SECTION_HEADER_HEIGHT-25

#define SCROLLVIEW_LEFT_PADDING 80
#define CELL_COUNT 30
#define CELL_HEIGHT 40

#define CELL_BACKGROUND_COLOR [UIColor grayColor]
#define HEADER_COLOR [UIColor purpleColor]

@interface ViewController ()
{
    UIScrollView *scrollview;
    UITableView *bigTableView;
    NSMutableArray *addedArr;
    UILabel *rightsectionLabel;
    
    UIScrollView *smallScrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addScrollviews];
    addedArr =[NSMutableArray arrayWithCapacity:CELL_COUNT];
    for (int i =0; i<CELL_COUNT; i++) {
        [addedArr addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addScrollviews{
    
    //因为先加bigTableView后加smallScrollView才不至于让bigTableView的section header把smallScrollView挡住
    bigTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), SCROLLVIEW_HEIGHT+SECTION_HEADER_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:bigTableView];
   
    smallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(SCROLLVIEW_LEFT_PADDING, STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame)-SCROLLVIEW_LEFT_PADDING, SECTION_HEADER_HEIGHT)];
    [self.view addSubview:smallScrollView];
    
    //此时scrollview的frame相对的是bigTableView的内容视图而不是其frame，所以高度应设置为CELL_HEIGHT*CELL_COUNT才不会显示不全
    //frame的height小于contenSize的height的话scrollview就可以上下滑动，所以这里设置成一样
     scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(SCROLLVIEW_LEFT_PADDING, SECTION_HEADER_HEIGHT, CGRectGetWidth(self.view.frame)-SCROLLVIEW_LEFT_PADDING, CELL_HEIGHT*CELL_COUNT)];
    [bigTableView addSubview:scrollview];

   
    bigTableView.delegate = self;
    bigTableView.dataSource = self;//此句不应漏掉
    scrollview.delegate = self;
    smallScrollView.delegate = self;

    bigTableView.showsVerticalScrollIndicator = NO;
    bigTableView.bounces = NO;//弹簧效果
    bigTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    smallScrollView.contentSize = CGSizeMake(1.5*scrollview.frame.size.width, SECTION_HEADER_HEIGHT);
    //content高设置为scrollview的frame的高度则无法上下滑动
    scrollview.contentSize = CGSizeMake(1.5*scrollview.frame.size.width, CELL_HEIGHT*CELL_COUNT);
    
    smallScrollView.showsHorizontalScrollIndicator = NO;
    smallScrollView.bounces = NO;
    scrollview.bounces = NO;//弹簧效果
    
    [self addHeaderForScrollView];
}

-(void)addHeaderForScrollView{
    UILabel *scrollHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1.5*scrollview.frame.size.width, SECTION_HEADER_HEIGHT)];
    scrollHeaderLabel.text = @"scrollview的头部~~~~~~~~~数值";
    scrollHeaderLabel.font = [UIFont systemFontOfSize:14];
    scrollHeaderLabel.textColor = [UIColor whiteColor];
    scrollHeaderLabel.backgroundColor = HEADER_COLOR;
    [smallScrollView addSubview:scrollHeaderLabel];
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return CELL_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

//这个方法一定要实现，不然viewForHeaderInSection不会执行
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SECTION_HEADER_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SECTION_HEADER_HEIGHT)];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0,0, SCROLLVIEW_LEFT_PADDING, SECTION_HEADER_HEIGHT)];
    sectionLabel.text = @"表头";
    sectionLabel.font = [UIFont systemFontOfSize:14];
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.backgroundColor = HEADER_COLOR;
    [headerView addSubview:sectionLabel];
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifierStr = @"jeancell";
    CustomTableViewCell *tableviewCell =(CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (tableviewCell == nil) {
        tableviewCell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
         }
    tableviewCell.headerTitleLabel.text = [NSString stringWithFormat:@"header%li",indexPath.row];
    //把rightLabel 加入到scrollView里面
    tableviewCell.rightLabel.text = [NSString stringWithFormat:@"%li~~左右滑动我试试看~~~~~%li",indexPath.row,indexPath.row];
   
    tableviewCell.rightLabel.frame = CGRectMake(0, indexPath.row*CELL_HEIGHT, 1.5*scrollview.frame.size.width, CELL_HEIGHT);
    if ([[addedArr objectAtIndex:indexPath.row]boolValue] == NO) {
        NSLog(@"第%li行还没有添加过scrollView里.....",indexPath.row+1);
         [scrollview addSubview:tableviewCell.rightLabel];
         [addedArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
    tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableviewCell.backgroundColor = CELL_BACKGROUND_COLOR;//此处设置个颜色，scrollview里因rightLabel透明所以显示为此颜色，分割线也可以显示完全
    return tableviewCell;
}
#pragma mark - uiscrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    if (scrollView1==scrollview) {
        [smallScrollView setContentOffset:scrollView1.contentOffset];
        }
    if (scrollView1 == smallScrollView) {
        [scrollview setContentOffset:scrollView1.contentOffset];
    }
}
@end
