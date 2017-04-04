static BOOL adjusted = false;

#import "LetsTakePicturesViewController.h"
#define kBundlePath @"/Library/Application Support/BeLikeThem.bundle"

@interface UIImage (twofers)
-(UIImage *)_flatImageWithColor:(UIColor *)color;
@end

%group storyislit

%hook UITableView 

-(void)reloadData{
	%orig;

	adjusted = false;


	if (self.tableHeaderView == nil){
		UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
	    UICollectionView *_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80.0f) collectionViewLayout:layout];
	    [_collectionView setDataSource:(id<UICollectionViewDataSource>)self];
	    [_collectionView setDelegate:(id<UICollectionViewDelegateFlowLayout>)self];
	    
	    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
	    [_collectionView setBackgroundColor:[UIColor clearColor]];
	    self.tableHeaderView = _collectionView;
	}

	//return test;
}

%new
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 0, 0);
}


%new
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

%new
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LetsTakePicturesViewController *controller = [[LetsTakePicturesViewController alloc] init];

    [[[self window] rootViewController] presentViewController:controller animated:true completion:nil];
}

%new
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
%new
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];

    NSBundle *bundle = [[[NSBundle alloc] initWithPath:kBundlePath] autorelease];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(10,0,50,50)];
    circle.layer.cornerRadius = 50/2;
    circle.layer.masksToBounds = YES;
    circle.backgroundColor = [UIColor whiteColor];
    circle.layer.borderColor = [UIColor blackColor].CGColor;
    circle.layer.borderWidth = 1.0f;
    
    UIImageView *profile = [[UIImageView alloc] initWithFrame:CGRectMake(5,11,40,40)];
    [profile setContentMode:UIViewContentModeScaleAspectFit];
    profile.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"user" ofType:@"png"]] _flatImageWithColor:[UIColor darkGrayColor]];
    [circle addSubview:profile];
    
    UIView *smallplus = [[UIView alloc] initWithFrame:CGRectMake(circle.frame.size.width,circle.frame.size.height-15,15,15)];
    smallplus.layer.cornerRadius = 15/2;
    smallplus.layer.masksToBounds = YES;
    smallplus.backgroundColor = [UIColor colorWithRed:0.00 green:0.76 blue:1.00 alpha:1.0];
    smallplus.layer.borderColor = [UIColor whiteColor].CGColor;
    smallplus.layer.borderWidth = 1.0f;

    
    
    UILabel *plus = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, 15, 15)];
    plus.text = @"+";
    plus.textAlignment = NSTextAlignmentCenter;
    plus.textColor = [UIColor whiteColor];
    [smallplus addSubview:plus];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 70, 14)];
    title.text = @"Your story";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [title.font fontWithSize:12];
    title.textColor = [UIColor lightGrayColor];
    
    [cell.contentView addSubview:circle];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:smallplus];


    return cell;
}

%new
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

%end

%end

%ctor{
	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];

	if (bundleIdentifier && ![bundleIdentifier isEqualToString:@"com.readdle.smartemail"]) {
		%init(storyislit);
	}
}