//
//  CustomTableViewCell.m
//  TestHorizontalScrollview
//
//  Created by liujing on 8/24/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerTitleLabel=[[UILabel alloc]init];
        [self.contentView addSubview:self.headerTitleLabel];
        self.headerTitleLabel.textColor = [UIColor whiteColor];
        self.headerTitleLabel.backgroundColor = [UIColor darkGrayColor];
        
        
        self.lineView = [[UIView alloc]init];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = [UIColor whiteColor];
        
        
        //不把rightLabel addSubview到self.contentView里，因rightLabel是要addSubview到scrollView的
        self.rightLabel = [[UILabel alloc]init];
        NSLog(@"alloc rightLabel....");
        self.rightLabel.textColor = [UIColor orangeColor];
        self.rightLabel.font = [UIFont systemFontOfSize:14];
//        self.rightLabel.backgroundColor = [UIColor clearColor];//此处设置为透明，这样分割线才能显示完全
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.headerTitleLabel setFrame:CGRectMake(0, 0, 80, 40)];
    [self.lineView setFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
}
@end
