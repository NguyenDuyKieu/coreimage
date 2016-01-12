//
//  ViewController.m
//  CoreImages
//
//  Created by Nguyễn Duy Kiều on 1/9/16.
//  Copyright © 2016 NguyenDuyKieu Co.Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController{
    UIActivityIndicatorView * activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!activityView) {
         [self createActivityIndicatorView];
    }
   
}

- (IBAction)btnSave:(id)sender {
    [activityView startAnimating];
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
-(void) image:(UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo{
    [activityView stopAnimating];
    if (NSClassFromString(@"UIAlertController")) {
        if (error) {
            [self showAlertControllerWithTitle:@"Fail" andMessage:@"Can'nt save image"];
        }else {
            [self showAlertControllerWithTitle:@"Success" andMessage:@"Save"];
        }
    }//else if (NSClassFromString(@"UIAlertView")){
//        if (error) {
//            [self showAlertViewWithTitle:@"faill" andMessage:@"Can't save image"];
//        }else {
//            [self showAlertViewWithTitle:@"Success" andMessage:@"Save image"];
//        }
//    }
}
                                   
- (IBAction)btnAlbum:(id)sender {
    //Action sheet
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Open Photos",
                            @"Open Camera",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)popup    clickedButtonAtIndex:(NSInteger)buttonIndex {
      UIImagePickerController * imagePickerController = [[UIImagePickerController alloc ] init];
      imagePickerController.delegate =self;
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                    [imagePickerController setAllowsEditing:YES];
                    [self presentViewController:imagePickerController animated:true completion:nil];
                    break;
                case 1:
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];// Test trên device
                    [imagePickerController setAllowsEditing:YES];
                    [self presentViewController:imagePickerController animated:true completion:nil];

                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = selectImage;
    [self dismissViewControllerAnimated:true completion:nil];
}
//ios 7,8
//-(void) showAlertViewWithTitle: (NSString *) title andMessage: (NSString *) message {
//    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:title message:message
//                                                   delegate:self cancelButtonTitle:@"Ok"
//                                          otherButtonTitles: nil];
//    [alert show];
//    
//}

-(void) showAlertControllerWithTitle:(NSString *)
                    title andMessage:(NSString* ) message{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:true completion:nil];
    UIAlertAction * okAction =[UIAlertAction actionWithTitle:@"Ok" style: UIAlertViewStyleDefault handler:nil];
    [alertController addAction:okAction];
}

-(void) createActivityIndicatorView {
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    [activityView stopAnimating];
}
@end
