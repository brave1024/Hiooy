//
//  WebViewController.h
//  Xia
//
//  Created by Xia Zhiyong on 13-9-24.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliPayPostModel.h"

@interface UIApplication(Browser)
-(BOOL)openURL:(NSURL *)url forceOpenInSafari:(BOOL)forceOpenInSafari;
@end

@protocol BrowserViewDelegate <NSObject>
- (BOOL)openURL:(NSURL*)url;
@end

// The names of the images for the 'back' and 'forward' buttons in the toolbar.
#define PNG_BUTTON_FORWARD @"right_btn"
#define PNG_BUTTON_BACK @"left_btn"

// List of all strings used
#define ACTION_CANCEL           @"Cancel"
#define ACTION_OPEN_IN_SAFARI   @"Open in Safari"


@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UINavigationBarDelegate> {
    
    // the current URL of the UIWebView
    NSURL *url;
    
    // html content
    NSString *htmlStr;
    
    // the UIWebView where we render the contents of the URL
    IBOutlet UIWebView *webView;
    
    // the UIToolbar with the "back" "forward" "reload" and "action" buttons
    IBOutlet UIToolbar *toolbar;
    
    // used to indicate that we are downloading content from the web
    UIActivityIndicatorView *activityIndicator;
    
    // pointers to the buttons on the toolbar
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIBarButtonItem *stopButton;
    UIBarButtonItem *reloadButton;
    UIBarButtonItem *actionButton;
    
    IBOutlet UINavigationBar *navBar;
    
}

@property(nonatomic, retain) NSURL *url;
@property(nonatomic, copy) NSString *htmlStr;   // add by xia zhiyong 20140527
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) UIToolbar *toolbar;
@property(nonatomic, retain) UIBarButtonItem *backButton;
@property(nonatomic, retain) UIBarButtonItem *forwardButton;
@property(nonatomic, retain) UIBarButtonItem *stopButton;
@property(nonatomic, retain) UIBarButtonItem *reloadButton;
@property(nonatomic, retain) UIBarButtonItem *actionButton;
@property(nonatomic, retain) UINavigationBar *navBar;

@property(nonatomic, strong) AliPayPostModel *post;

// Initializes the BrowserViewController with a specific URL
- (id)initWithUrls:(NSURL*)u;

@end
