//
//  ViewController.m
//  LNStompClientDemo
//
//  Created by Thanh Tu on 10/13/15.
//  Copyright © 2015 Thanh Tu. All rights reserved.
//

#import "ViewController.h"
#import "LNStompClient.h"


@interface ViewController ()

@end

@implementation ViewController


LNStompClient* stompClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    stompClient = [[LNStompClient alloc]
                   initWithURL: [NSURL URLWithString: @"http://localhost:15674/stomp"]];
    
    
    // opening the STOMP client returns a raw WebSocket signal that you can subscribe to
    [[stompClient open]
     
     subscribeNext:^(id x) {
         if ([x class] == [SRWebSocket class]) {
             // First time connected to WebSocket, receiving SRWebSocket object
             //NSLog(@"web socket connected with: %@", x);
             
             [stompClient connectWithHeaders:@{
                                               kHeaderLogin: @"guest",
                                               kHeaderPasscode: @"guest"
                                               }];
             
             
             // subscribe to a STOMP destination
             [[stompClient stompMessagesFromDestination:@"/topic/test" withHeaders:@{kHeaderPersistent : @"true"}]
              subscribeNext:^(MMPStompMessage *message) {
                  NSLog(@"STOMP message received: body = %@", message.body);
              }];
             
             
         } else if ([x isKindOfClass:[NSString class]]) {
             // Subsequent signals should be NSString
             // NSLog(@"STOMP message received: body = %@", x);
         }
     }
     error:^(NSError *error) {
         NSLog(@"web socket failed: %@", error);
     }
     completed:^{
         NSLog(@"web socket closed");
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
