//
//  AcknowledgementsViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 31/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "AcknowledgementsViewController.h"

@interface AcknowledgementsViewController ()

@end

@implementation AcknowledgementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url =[[NSBundle mainBundle] URLForResource:@"Acknowledgments" withExtension:@".rtf"];
    NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc]   initWithFileURL:url options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    
    self.tfTextView.attributedText = attributedStringWithRtf;
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    [self setupNavigationBarImage];
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)setupNavigationBarImage
{
    UIImage *image = [UIImage imageNamed:@"simplesaver"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    self.navigationItem.titleView = imageView;
}
@end
