//
//  QGHOrderListBottomCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderListBottomCell.h"
#import "QGHOrderListItem.h"


@interface QGHOrderListBottomCell ()

@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@end


@implementation QGHOrderListBottomCell

- (void)awakeFromNib {
    self.payPriceLabel.textColor = C6;
    
    _button1 = [[UIButton alloc] init];
    [_button1 setTitleColor:C21 forState:UIControlStateNormal];
    _button1.backgroundColor = C20;
    _button1.layer.cornerRadius = 3;
    _button1.titleLabel.font = F4;
    [_button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button1];
    
    _button2 = [[UIButton alloc] init];
    [_button2 setTitleColor:C21 forState:UIControlStateNormal];
    _button2.backgroundColor = C20;
    _button2.layer.cornerRadius = 5;
    _button2.titleLabel.font = F4;
    [_button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button2];
}

- (void)setItem:(QGHOrderListItem *)item {
    _item = item;
    
    self.payPriceLabel.text = [NSString stringWithFormat:@"实付款：¥%g", item.amount];
    
    switch (item.status) {
        case QGHOrderListItemStatusToPay:
            self.button1.hidden = YES;
            self.button2.hidden = NO;
            [self.button2 setTitle:@"立即支付" forState:UIControlStateNormal];
            break;
        case QGHOrderListItemStatusToExpress:
            self.button1.hidden = YES;
            self.button2.hidden = YES;
            break;
        case QGHOrderListItemStatusToReceipt:
            self.button1.hidden = NO;
            self.button2.hidden = NO;
            [self.button1 setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.button2 setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case QGHOrderListItemStatusToComment:
            self.button1.hidden = YES;
            self.button2.hidden = NO;
            [self.button2 setTitle:@"立即评价" forState:UIControlStateNormal];
            break;
        case QGHOrderListItemStatusFinish:
            self.button1.hidden = YES;
            self.button2.hidden = YES;
            break;
        case QGHOrderListItemStatusCancel:
            self.button1.hidden = YES;
            self.button2.hidden = NO;
            [self.button2 setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
        case QGHOrderListItemStatusRefund:
            self.button1.hidden = YES;
            self.button2.hidden = NO;
            [self.button2 setTitle:@"追踪退款退货" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [self.button1 sizeToFit];
    [self.button2 sizeToFit];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(self.button2.width + 24);
    }];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.button1.left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(self.button1.width + 24);
    }];
}


- (void)button1Action {
    
}


- (void)button2Action {
    switch (self.item.status) {
        case QGHOrderListItemStatusToPay:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToPay)]) {
                [self.delegate orderListBottomCellToPay];
            }
            break;
        case QGHOrderListItemStatusToExpress:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToLookExpress)]) {
                [self.delegate orderListBottomCellToLookExpress];
            }
            break;
        case QGHOrderListItemStatusToReceipt:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToConfirmReceipt)]) {
                [self.delegate orderListBottomCellToConfirmReceipt];
            }
            break;
        case QGHOrderListItemStatusToComment:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToComment)]) {
                [self.delegate orderListBottomCellToComment];
            }
            break;
        case QGHOrderListItemStatusFinish:
            break;
        case QGHOrderListItemStatusCancel:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToDeleteOrder)]) {
                [self.delegate orderListBottomCellToDeleteOrder];
            }
            break;
        case QGHOrderListItemStatusRefund:
            if ([self.delegate respondsToSelector:@selector(orderListBottomCellToPursueRefund)]) {
                [self.delegate orderListBottomCellToPursueRefund];
            }
            break;
        default:
            break;
    }
}


@end
