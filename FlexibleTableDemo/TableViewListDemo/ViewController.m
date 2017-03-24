//
//  ViewController.m
//  TableViewListDemo
//
//  Created by Liwp on 17/1/24.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "ViewController.h"
#import "ListCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UITableView* table;
@property (nonatomic ,strong)NSMutableArray *touchPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.touchPoint =  [NSMutableArray new];
    [self.view addSubview:self.table];
    
}
- (UITableView *)table{
    if (!_table) {
        _table =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator =NO;
        _table.bounces = YES;
//        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setLongPressDrag];
        [_table registerClass:[ListCell class] forCellReuseIdentifier:@"ListCell"];
    }
    return _table;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId =@"ListCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"drawing ---- %zd",indexPath.row];
    cell.textLabel.textColor = [UIColor yellowColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}

#pragma mark- fountion
-(void)setLongPressDrag{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tableLongPress:)];
    longPress.delegate = self;
    [self.table addGestureRecognizer:longPress];
}
#pragma mark- 获取截图
- (UIView *)customSnapshotFromView:(UIView *)inputView{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc]initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
    
}

- (void)tableLongPress:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:location];
    static UIView      *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshotFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.table addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    center.y =  location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.9;
                    cell.alpha = 0.0;
                }completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            [self.touchPoint addObject:[NSValue valueWithCGPoint:location]];
            
            if (self.touchPoint.count > 2) {
                [self.touchPoint removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            center.y = location.y;
            CGPoint ppoint = [[self.touchPoint firstObject]CGPointValue];
            CGPoint npoint = [[self.touchPoint lastObject]CGPointValue];
            CGFloat movex = npoint.x - ppoint.x;
            
            center.y +=movex;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.table moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
        
            
            
        }
            break;
        default:
            //取消长按手势
        {
            
            [self.touchPoint  removeAllObjects];
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform =  CGAffineTransformIdentity;
                snapshot.alpha = 0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
                sourceIndexPath = nil;
                cell.hidden = NO;
            }];
            
            
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
