//
//  RegisterVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "RegisterVC.h"
#import "User.h"
#import "UserManager.h"
#import "NSString+CheckingEmpty.h"
#import <Photos/Photos.h>

@interface RegisterVC() <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (strong, nonatomic) UserManager *userManager;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) BOOL isRegistered;
@property (nonatomic) int seen;
@property (nonatomic, strong) NSString *selectedCity;
@end
@implementation RegisterVC

- (void)viewDidLoad
{
    if (!_userManager)
        _userManager = [UserManager sharedInstance];
    
    self.pickerView.delegate = self;
    [self.pickerView reloadAllComponents];
    self.seen = 0;
}
- (IBAction)browseButtonTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.thumbView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.seen--;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.seen--;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.seen++;
    
    if (self.seen > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)registerButtonTapped:(id)sender {

    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    NSString *name = self.nameText.text;
    
    
    @try {
        if ([username isCompleteEmpty] || [password isCompleteEmpty] || [name isCompleteEmpty]) {
            self.isRegistered = NO;
            @throw [[NSException alloc] initWithName:@"Custom" reason:@"emptyField" userInfo:nil];
        }
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [user setName:name];
        [user setUsername:username];
        [user setPassword:password];
        NSData *photo = UIImageJPEGRepresentation(self.thumbView.image, 0);
        [user setPhoto:photo];
        [user setCity:self.selectedCity];
        [self.userManager createUser:user];
        [self.userManager loginUser:username :password];
        self.isRegistered = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register successful" message:@"Please log into the system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self performSegueWithIdentifier:@"registerSuccessful" sender:nil];
        
        [self clearAllUIElements];
        
        
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"pickedUsername"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failed" message:@"Please full the fields." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    @finally {
        
    }

}
- (IBAction)loginButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clearAllUIElements
{
    self.usernameText.text = @"";
    self.nameText.text = @"";
    self.passwordText.text = @"";
}

- (BOOL)shouldPerformSegueWithIdentifier:(nonnull NSString *)identifier sender:(nullable id)sender
{
    return NO;
}

#pragma mark - picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self getCities] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id title = [[self getCities] objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", title];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    id title = [[self getCities] objectAtIndex:row];
    self.selectedCity = [NSString stringWithFormat:@"%@", title];
}

- (NSArray *)getCities{
    NSString *cities = @"Choose City/Adana/Adıyaman/Afyon/Ağrı/Amasya/Ankara/Antalya/Artvin/Aydın/Balıkesir/Bilecik/Bingöl/Bitlis/Bolu/Burdur/Bursa/Çanakkale/Çankırı/Çorum/Denizli/Diyarbakır/Edirne/Elazığ/Erzincan/Erzurum/Eskişehir/Gaziantep/Giresun/Gümüşhane/Hakkari/Hatay/Isparta/İçel (Mersin)/İstanbul/İzmir/Kars/Kastamonu/Kayseri/Kırklareli/Kırşehir/Kocaeli/Konya/Kütahya/Malatya/Manisa/K.maraş/Mardin/Muğla/Muş/Nevşehir/Niğde/Ordu/Rize/Sakarya/Samsun/Siirt/Sinop/Sivas/Tekirdağ/Tokat/Trabzon/Tunceli/Şanlıurfa/Uşak/Van/Yozgat/Zonguldak/Aksaray/Bayburt/Karaman/Kırıkkale/Batman/Şırnak/Bartın/Ardahan/Iğdır/Yalova/Karabük/Kilis/Osmaniye/Düzce";
    return [cities componentsSeparatedByString:@"/"];
}

@end
