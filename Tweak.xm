#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <substrate.h>

// Borrowed from Alex Zielenski <3
#define IS_RETINA() ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
#define RETINIZE(r) [(IS_RETINA()) ? [r stringByAppendingString:@"@2x"] : r stringByAppendingPathExtension: @"png"]

static CABasicAnimation *donutfadeIn;
static CABasicAnimation *donutfadeOut;
static CABasicAnimation *donutMoveDrawerUp;
static CABasicAnimation *donutMoveDrawerDown;
static CABasicAnimation *donutfadeInIcons;
static CABasicAnimation *donutfadeOutIcons;
static CABasicAnimation *donutFillAnimation;
static CABasicAnimation *donutEmptyAnimation;
static CAAnimationGroup *DOOpenFolderAnimationGroup;
static CAAnimationGroup *DOCloseFolderAnimationGroup;
static UIView *DOFrameOne;
static UIView *DOFrameTwo;
static UIView *DOFrameThree;
static UIView *DOFrameFour;
static UIView *DOFrameFive;
static UIView *DOFrameSix;
static UIView *DOClosingFrameOne;
static UIView *DOClosingFrameTwo;
static UIView *DOClosingFrameThree;
static UIView *DOClosingFrameFour;
static UIView *DOClosingFrameFive;
static UIView *DOClosingFrameSix;
static UIView *DonutDrawerImageView;
static CGRect folderRect;
static BOOL DOFOLDERISOPEN = NO;


@interface SBFolderIconView : UIView
- (void)setFrame:(struct CGRect)arg1;
- (void)longPressTimerFired;
- (UIImageView *)customImageView;
- (void)setCustomImageView:(UIImageView *)imageView;
- (void)setCustomIconImage:(UIImage *)image;
@end

@interface SBFolderIconImageView : NSObject
-(id)_folderIcon;
@end

@interface SBFolder : NSObject
-(id)allicons; // returns an NSMutableSet
@property(copy, nonatomic) NSString *displayName;
@end

@interface SBFolderView : UIView
-(id)initWithFolder:(id)folder orientation:(int)orientation viewMap:(id)map context:(id)cont;
-(id)_createIconListViewForList:(id)list;
@property(readonly, copy, nonatomic) NSArray* iconListViews;
@end

@interface SBFloatyFolderView : UIView
-(id)initWithFolder:(id)folder orientation:(int)orientation viewMap:(id)map context:(id)cont;
@end

@interface SBFolderController : NSObject
-(id)initWithFolder:(id)folder orientation:(int)orientation viewMap:(id)map;
@property(readonly, retain, nonatomic) SBFolderView* contentView;
@end

@interface SBIconController : NSObject
-(void)openFolder:(id)folder animated:(BOOL)animated;
-(void)closeFolderAnimated:(BOOL)animated;
-(void)closeFolderAnimated:(BOOL)animated withCompletion:(id)completion;
-(id)currentFolderIconList;
-(void)handleHomeButtonTap;
-(id)model;
-(CGRect)_contentViewRelativeFrameForIcon:(id)icon;
-(id)_currentFolderController;
-(UIView *)DOFolderContentView;
-(void)setDOFolderContentView:(UIView *)value;
-(UIView *)DOFolderView;
-(void)setDOFolderView:(UIView *)value;
-(SBFolderController *)DOFolderController;
-(void)setDOFolderController:(SBFolderController *)value;
-(UIView *)DOFolderContainerView;
-(void)setDOFolderContainerView:(UIView *)value;
-(UIView *)DOFolderContainerBackDropView;
-(void)setDOFolderContainerBackDropView:(UIView *)value;
-(void)animationDidStop:(id)anim finished:(BOOL)flag;
@end


@interface SBIconView : UIView
+ (struct CGSize)defaultIconImageSize;
- (void)setLabelHidden:(BOOL)hidden;
@end

@interface SBIcon : NSObject
- (id)displayName;
@end

@interface SBFolderIcon : SBIcon
- (void)launch;
@end

@interface SBFolderIconListView : NSObject

@end

@interface SBIconViewMap : NSObject
-(id)initWithIconModel:(id)model screen:(id)screen delegate:(id)del viewDelegate:(id)viewdel;
@end

@interface SBIconScrollView : UIView

@end

@interface SBRootFolderView : UIView

@end


@interface SBRootFolderController: SBFolderController
@property(readonly, retain, nonatomic) SBRootFolderView* contentView;
@end


%hook SBIconController
- (void)openFolder:(id)folder animated:(BOOL)animated {
	if(!DOFOLDERISOPEN){
		NSLog(@"Open folder with Donut animation");
		SBFolder *folderToOpen = folder;
		SBFolderIcon *folderIcon = MSHookIvar<SBIcon *>(folderToOpen, "_icon");

		if([folderToOpen.displayName isEqualToString: @"Video"]){
			//get the location of the folder that was tapped.
			CGRect selectedFolderRect = [self _contentViewRelativeFrameForIcon: folderIcon];
			NSLog(@"%@", CGRectCreateDictionaryRepresentation(selectedFolderRect));

			//this is the frame of the drawer icon
			CGRect drawerMovedFrame = DonutDrawerImageView.frame;
			//we are going to move it up by 20
			drawerMovedFrame.origin.y -= 20;

			CGRect folderContainerFrame = [UIScreen mainScreen].bounds;

			//this is the starting frame of the animating drawer
			CGFloat center = folderContainerFrame.size.width / 2;
			center -= 5;
			CGRect folderRect = selectedFolderRect;
			folderRect.origin.y -= 250;
			folderRect.origin.x = center - 150 / 2;
			folderRect.size.height = 150;
			folderRect.size.width = 150;

			DOFrameOne = [[UIView alloc] initWithFrame: folderRect];
			DOFrameOne.layer.cornerRadius = DOFrameOne.frame.size.width / 2;
			DOFrameOne.alpha = 0.0;
			DOFrameOne.backgroundColor = [UIColor whiteColor];

			folderRect.origin.y -= 100;
			folderRect.origin.x = center - 300 / 2;
			folderRect.size.height = 300;
			folderRect.size.width = 300;

			DOFrameTwo = [[UIView alloc] initWithFrame: folderRect];
			DOFrameTwo.layer.cornerRadius = DOFrameTwo.frame.size.width / 2;
			DOFrameTwo.alpha = 0.0;
			DOFrameTwo.backgroundColor = [UIColor whiteColor];

			folderRect.origin.y -= 100;
			folderRect.origin.x = center - 450/2;
			folderRect.size.height = 450;
			folderRect.size.width = 450;

			DOFrameThree = [[UIView alloc] initWithFrame: folderRect];
			DOFrameThree.layer.cornerRadius = DOFrameThree.frame.size.width / 2;
			DOFrameThree.alpha = 0.0;
			DOFrameThree.backgroundColor = [UIColor whiteColor];

			folderRect.origin.y -= 65;
			folderRect.origin.x = center - 550 / 2;
			folderRect.size.height = 550;
			folderRect.size.width = 550;

			DOFrameFour = [[UIView alloc] initWithFrame: folderRect];
			DOFrameFour.layer.cornerRadius = DOFrameFour.frame.size.width / 2;
			DOFrameFour.alpha = 0.0;
			DOFrameFour.backgroundColor = [UIColor whiteColor];

			folderRect.origin.y -= 75;
			folderRect.origin.x = center - 650 / 2;
			folderRect.size.height = 650;
			folderRect.size.width = 650;

			DOFrameFive = [[UIView alloc] initWithFrame: folderRect];
			DOFrameFive.layer.cornerRadius = DOFrameFive.frame.size.width / 2;
			DOFrameFive.alpha = 0.0;
			DOFrameFive.backgroundColor = [UIColor whiteColor];

			folderRect.origin.y -= 85;
			folderRect.origin.x = center - 750 / 2;
			folderRect.size.height = 750;
			folderRect.size.width = 750;

			DOFrameSix = [[UIView alloc] initWithFrame: folderRect];
			DOFrameSix.layer.cornerRadius = DOFrameSix.frame.size.width / 2;
			DOFrameSix.alpha = 0.0;
			DOFrameSix.backgroundColor = [UIColor whiteColor];

			//FRAMES USED ONLY FOR CLOSING ANIMATION
			CGRect closingFrame = DOFrameTwo.frame;
			DOClosingFrameSix = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameSix.layer.cornerRadius = DOClosingFrameSix.frame.size.width / 2;
			DOClosingFrameSix.alpha = 0.0;
			DOClosingFrameSix.backgroundColor = [UIColor whiteColor];

			DOClosingFrameFive = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameFive.layer.cornerRadius = DOClosingFrameFive.frame.size.width / 2;
			DOClosingFrameFive.alpha = 0.0;
			DOClosingFrameFive.backgroundColor = [UIColor whiteColor];

			DOClosingFrameFour = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameFour.layer.cornerRadius = DOClosingFrameFour.frame.size.width / 2;
			DOClosingFrameFour.alpha = 0.0;
			DOClosingFrameFour.backgroundColor = [UIColor whiteColor];

			DOClosingFrameThree = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameThree.layer.cornerRadius = DOClosingFrameThree.frame.size.width / 2;
			DOClosingFrameThree.alpha = 0.0;
			DOClosingFrameThree.backgroundColor = [UIColor whiteColor];

			DOClosingFrameTwo = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameTwo.layer.cornerRadius = DOClosingFrameTwo.frame.size.width / 2;
			DOClosingFrameTwo.alpha = 0.0;
			DOClosingFrameTwo.backgroundColor = [UIColor whiteColor];

			DOClosingFrameOne = [[UIView alloc] initWithFrame: closingFrame];
			DOClosingFrameOne.layer.cornerRadius = DOClosingFrameOne.frame.size.width / 2;
			DOClosingFrameOne.alpha = 0.0;
			DOClosingFrameOne.backgroundColor = [UIColor whiteColor];
			

			self.DOFolderView = [[UIView alloc] initWithFrame: folderContainerFrame];
			self.DOFolderView.backgroundColor = [UIColor whiteColor];
			self.DOFolderView.alpha = 0.0;

			//get content view and add subview to represent new folder
			SBRootFolderController *RootFolderController = [self _currentFolderController];

			//create the folder container and add the folder as a subview
			folderContainerFrame.origin.y = 40;
			folderContainerFrame.origin.x = 5;
			folderContainerFrame.size.width -= 10;
			folderContainerFrame.size.height -= 50;
			self.DOFolderContainerView = [[UIView alloc] initWithFrame: folderContainerFrame];
			self.DOFolderContainerView.backgroundColor = [UIColor clearColor];
			self.DOFolderContainerView.layer.cornerRadius = 5.0;
			self.DOFolderContainerView.layer.masksToBounds = YES;

			self.DOFolderContainerBackDropView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
			self.DOFolderContainerBackDropView.backgroundColor = [UIColor blackColor];
			self.DOFolderContainerBackDropView.alpha = 0.0;
			//self.DOFolderContainerBackDropView.layer.masksToBounds = YES;

			//add Donut views to the contentview
			DOFOLDERISOPEN = YES;
			[self.DOFolderContainerView addSubview: DOFrameOne];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameSix];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameFive];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameFour];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameThree];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameTwo];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOClosingFrameOne];//is only used for closing animation
			[self.DOFolderContainerView addSubview: DOFrameTwo];
			[self.DOFolderContainerView addSubview: DOFrameThree];
			[self.DOFolderContainerView addSubview: DOFrameFour];
			[self.DOFolderContainerView addSubview: DOFrameFive];
			[self.DOFolderContainerView addSubview: DOFrameSix];

			[self.DOFolderContainerView addSubview: self.DOFolderView];
			[RootFolderController.contentView addSubview: self.DOFolderContainerBackDropView];
			[RootFolderController.contentView addSubview: self.DOFolderContainerView];

			
			self.DOFolderContentView = [[UIView alloc] initWithFrame: folderContainerFrame];
			//set the alpha to zero and we will fade it in later
			self.DOFolderContentView.alpha = 0.0;
			//TODO: add icons to DOFolderContentView

			[RootFolderController.contentView addSubview: self.DOFolderContentView];

			[self startDOOpenAnimation];

		} else{
			%orig;
		}
	} 	
}

%new 
-(void)startDOOpenAnimation
{
	[UIView animateWithDuration:0.03 delay:0.0 options:nil
    animations:^{
        DOFrameOne.alpha = 1.0;
    }
    completion:^(BOOL finished) { 
		[UIView animateWithDuration:0.03 delay:0.0 options:nil
		animations:^{
		    DOFrameTwo.alpha = 1.0;
		    self.DOFolderContainerBackDropView.alpha = 0.6;
		}
		completion:^(BOOL finished) { 
		    [UIView animateWithDuration:0.03 delay:0.0 options:nil
		    animations:^{
		        DOFrameThree.alpha = 1.0;
		    }
		    completion:^(BOOL finished) { 
		        [UIView animateWithDuration:0.03 delay:0.0 options:nil
			    animations:^{
			        DOFrameFour.alpha = 1.0;
			    }
			    completion:^(BOOL finished) { 
			    	DonutDrawerImageView.alpha = 0.0;
			    	CGRect frame = self.DOFolderContainerView.frame;
		            frame.size.height -= 20;
			        [UIView animateWithDuration:0.03 delay:0.0 options:nil
				    animations:^{
				        DOFrameFive.alpha = 1.0;
				        self.DOFolderContainerView.frame = frame;
				    }
				    completion:^(BOOL finished) { 
				        [UIView animateWithDuration:0.03 delay:0.0 options:nil
					    animations:^{
					        DOFrameSix.alpha = 1.0;
					    }
					    completion:^(BOOL finished) {
					    	DOFrameOne.alpha = 0.0; 
					    	[self.DOFolderContainerView addSubview: self.DOFolderView];
					    	CGRect frame = self.DOFolderContainerView.frame;
		    				frame.origin.y -= 20;
					    	[UIView animateWithDuration:0.03 delay:0.0 options:nil
						    animations:^{
								self.DOFolderContainerView.frame = frame;
						    }
						    completion:^(BOOL finished) { 

						    }];
					    }];
				    }];
			    }];
		    }];
		}];
	}];
}

%new
-(void)startDOCloseAnimation{

	CGFloat center =  [UIScreen mainScreen].bounds.size.width / 2;
	center -= 5;
	CGRect frame = self.DOFolderContainerView.frame;
	frame.size.height += 30;
	CGRect frame1 = DOFrameOne.frame;
	CGRect frameSixRect = DOFrameTwo.frame;
	frameSixRect.size.width -= 50;
	frameSixRect.size.height -= 50;
	frameSixRect.origin.y += 60;
	frameSixRect.origin.x = center - frameSixRect.size.width / 2;
	DOClosingFrameSix.frame = frameSixRect;
	DOClosingFrameSix.layer.cornerRadius = DOClosingFrameSix.frame.size.width / 2;

	CGRect frameFiveRect = frameSixRect;
	frameFiveRect.size.width -= 50;
	frameFiveRect.size.height -= 50;
	frameFiveRect.origin.y += 60;
	frameFiveRect.origin.x = center - frameFiveRect.size.width / 2;
	DOClosingFrameFive.frame = frameFiveRect;
	DOClosingFrameFive.layer.cornerRadius = DOClosingFrameFive.frame.size.width / 2;

	CGRect frameFourRect = frameFiveRect;
	frameFourRect.size.width -= 40;
	frameFourRect.size.height -= 40;
	frameFourRect.origin.y += 55;
	frameFourRect.origin.x = center - frameFourRect.size.width / 2;
	DOClosingFrameFour.frame = frameFourRect;
	DOClosingFrameFour.layer.cornerRadius = DOClosingFrameFour.frame.size.width / 2;

	CGRect frameThreeRect = frameFourRect;
	frameThreeRect.size.width -= 35;
	frameThreeRect.size.height -= 35;
	frameThreeRect.origin.y += 55;
	frameThreeRect.origin.x = center - frameThreeRect.size.width / 2;
	DOClosingFrameThree.frame = frameThreeRect;
	DOClosingFrameThree.layer.cornerRadius = DOClosingFrameThree.frame.size.width / 2;

	CGRect frameTwoRect = frameThreeRect;
	frameTwoRect.size.width -= 35;
	frameTwoRect.size.height -= 35;
	frameTwoRect.origin.y += 55;
	frameTwoRect.origin.x = center - frameTwoRect.size.width / 2;
	DOClosingFrameTwo.frame = frameTwoRect;
	DOClosingFrameTwo.layer.cornerRadius = DOClosingFrameTwo.frame.size.width / 2;

	CGRect frameOneRect = frameTwoRect;
	frameOneRect.size.width -= 35;
	frameOneRect.size.height -= 35;
	frameOneRect.origin.y += 47;
	frameOneRect.origin.x = center - frameOneRect.size.width / 2;
	DOClosingFrameOne.frame = frameOneRect;
	DOClosingFrameOne.layer.cornerRadius = DOClosingFrameOne.frame.size.width / 2;

	NSLog(@"closing the folder");
	[self.DOFolderView removeFromSuperview];
	[UIView animateWithDuration:0.03 delay:0.0 options:nil
    animations:^{
        DOFrameSix.alpha = 0.0;
    }
    completion:^(BOOL finished) { 
        [UIView animateWithDuration:0.03 delay:0.0 options:nil
	    animations:^{
	        DOFrameFive.alpha = 0.0;
	    }
	    completion:^(BOOL finished) { 
	        [UIView animateWithDuration:0.03 delay:0.0 options:nil
		    animations:^{
		        DOFrameFour.alpha = 0.0;
		    }
		    completion:^(BOOL finished) { 
		        [UIView animateWithDuration:0.02 delay:0.0 options:nil
			    animations:^{
			        DOFrameThree.alpha = 0.0;
			        self.DOFolderContainerBackDropView.alpha = 0.0;
			    }
			    completion:^(BOOL finished) { 
			        [UIView animateWithDuration:0.02 delay:0.0 options:nil
				    animations:^{
				        DOFrameTwo.alpha = 0.0;
						DOClosingFrameSix.alpha = 1.0;
				    }
				    completion:^(BOOL finished) { 
				    	self.DOFolderContainerView.frame = frame;
				    	[UIView animateWithDuration:0.02 delay:0.0 options:nil
					    animations:^{
					        DOClosingFrameSix.alpha = 0.0;
					        DOClosingFrameFive.alpha = 1.0;
					    }
					    completion:^(BOOL finished) { 
					    	[UIView animateWithDuration:0.02 delay:0.0 options:nil
						    animations:^{
						        DOClosingFrameFive.alpha = 0.0;
				        		DOClosingFrameFour.alpha = 1.0;
						    }
						    completion:^(BOOL finished) {
						    	// CGRect tempframeTwo = self.DOFolderContainerView.frame;
					    		// tempframeTwo.origin.y += 40; 
						    	[UIView animateWithDuration:0.03 delay:0.0 options:nil
							    animations:^{
							    	//self.DOFolderContainerView.frame = tempframeTwo;
							        DOClosingFrameFour.alpha = 0.0;
							        DOClosingFrameThree.alpha = 1.0;
							    }
							    completion:^(BOOL finished) { 
							    	[UIView animateWithDuration:0.03 delay:0.0 options:nil
								    animations:^{
								        DOClosingFrameThree.alpha = 0.0;
								        DOClosingFrameTwo.alpha = 1.0;
								    }
								    completion:^(BOOL finished) { 
									    [UIView animateWithDuration:0.03 delay:0.0 options:nil
									    animations:^{
									        DOClosingFrameTwo.alpha = 0.0;
									        DOClosingFrameOne.alpha = 1.0;
									    }
									    completion:^(BOOL finished) { 
										    [UIView animateWithDuration:0.03 delay:0.0 options:nil
										    animations:^{
										        DOClosingFrameOne.alpha = 0.0;
										        DonutDrawerImageView.alpha = 1.0;
										    }
										    completion:^(BOOL finished) { 
											    [self releaseDOFolderViews];
										    }];
									    }];
								    }];
							    }];
						    }];
					    }];
				    }];
			    }];
		    }];
	    }];
    }];
}

-(void)handleHomeButtonTap{
	if(DOFOLDERISOPEN){
		[self startDOCloseAnimation];
	}else {
		%orig;
	}
}

%new 
-(void)releaseDOFolderViews
{
	NSLog(@"releasing the views");
	[self.DOFolderContentView removeFromSuperview];
	[self.DOFolderView.layer removeAllAnimations];
	[self.DOFolderView release];
	[self.DOFolderView removeFromSuperview];
	[self.DOFolderContainerView release];
	[self.DOFolderContainerView removeFromSuperview];	
	[self.DOFolderContainerBackDropView release];
	[self.DOFolderContainerBackDropView removeFromSuperview];	
	DOFOLDERISOPEN = NO;
}

%new 
-(SBFolderController *)DOFolderController {
	return objc_getAssociatedObject(self, @selector(DOFolderController));
}

%new
- (void)setDOFolderController:(SBFolderController *)value {
    objc_setAssociatedObject(self, @selector(DOFolderController), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new 
-(UIView *)DOFolderContentView {
	return objc_getAssociatedObject(self, @selector(DOFolderContentView));
}

%new
- (void)setDOFolderContentView:(UIView *)value {
    objc_setAssociatedObject(self, @selector(DOFolderContentView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new 
-(UIView *)DOFolderView {
	return objc_getAssociatedObject(self, @selector(DOFolderView));
}

%new
- (void)setDOFolderView:(UIView *)value {
    objc_setAssociatedObject(self, @selector(DOFolderView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new 
-(UIView *)DOFolderContainerBackDropView {
	return objc_getAssociatedObject(self, @selector(DOFolderContainerBackDropView));
}

%new
- (void)setDOFolderContainerBackDropView:(UIView *)value {
    objc_setAssociatedObject(self, @selector(DOFolderContainerBackDropView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new 
-(UIView *)DOFolderContainerView {
	return objc_getAssociatedObject(self, @selector(DOFolderContainerView));
}

%new
- (void)setDOFolderContainerView:(UIView *)value {
    objc_setAssociatedObject(self, @selector(DOFolderContainerView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
%end


//Thanks magn2o https://github.com/magn2o/CustomFolderIcons/blob/master/Tweak.xm
%hook SBFolderIconView
- (void)setIcon:(SBIcon *)icon
{
	%log;
    %orig;
    if([icon isFolderIcon]){
	    SBFolder * folderForIcon = MSHookIvar<SBFolder *>(icon, "_folder");
    
 	    if([folderForIcon.displayName isEqualToString:@"Video"]){
	    	NSString *customImagePath = [NSString stringWithFormat:@"/Library/Donut/donutdrawer.png"];
		    if([[NSFileManager defaultManager] fileExistsAtPath:customImagePath])
		    {
		    	
		        [self setCustomIconImage:[[UIImage alloc] initWithContentsOfFile:customImagePath]];
		        
		        MSHookIvar<UIView *>([self _folderIconImageView], "_backgroundView").hidden = YES;
		        MSHookIvar<UIView *>([self _folderIconImageView], "_pageGridContainer").hidden = YES;
		    }
		}
	}
}

- (void)dealloc
{
    [self.customImageView release];
    %orig;
}

- (id)initWithFrame:(struct CGRect)frame
{
    UIView *view = %orig;
    CGSize size = [%c(SBIconView) defaultIconImageSize];
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, size.width, size.height)];
    self.customImageView.backgroundColor = [UIColor clearColor];
    
    [view insertSubview:self.customImageView atIndex:1]; 

    return view;
}

%new(@@:)
- (UIImageView *)customImageView
{
    return objc_getAssociatedObject(self, @selector(customImageView));
}

%new(v@:@)
- (void)setCustomImageView:(UIImageView *)imageView
{
    objc_setAssociatedObject(self, @selector(customImageView), imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new(v@:@)
- (void)setCustomIconImage:(UIImage *)image
{
	NSLog(@"setting the image icon");
    UIImage *_image = image;
    self.customImageView.image = _image;
    DonutDrawerImageView = self.customImageView;
}
%end

//
//Remove dark image when you hold on folders
//
%hook SBFolderIconImageView
-(id)darkeningOverlayImage{
	SBFolderIcon *folderIcon = [self _folderIcon];
	SBFolder *folder = MSHookIvar<SBFolder *>(folderIcon, "_folder");
	if([folder.displayName isEqualToString:@"Video"]){
		return nil;
	}
	else{
		return %orig;
	}
}
%end

%ctor {
	//build animations
    donutMoveDrawerUp = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    donutMoveDrawerUp.duration=0.2;
    donutMoveDrawerUp.removedOnCompletion = NO;
	donutMoveDrawerUp.fillMode = kCAFillModeForwards;

	donutMoveDrawerDown = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    donutMoveDrawerDown.duration=0.1;
    donutMoveDrawerDown.removedOnCompletion = NO;
	donutMoveDrawerDown.fillMode = kCAFillModeForwards;

	donutfadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[donutfadeIn setFromValue:[NSNumber numberWithFloat:0.0]];
	[donutfadeIn setToValue:[NSNumber numberWithFloat:1.0]];
	[donutfadeIn setDuration:0.1];
	[donutfadeIn setBeginTime:0.0];
	donutfadeIn.fillMode = kCAFillModeForwards;
	donutfadeIn.removedOnCompletion = NO;

	donutFillAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	[donutFillAnimation setToValue:[NSNumber numberWithFloat:40.0]];
	[donutFillAnimation setDuration:0.3];
	[donutFillAnimation setBeginTime:0.2];
	donutFillAnimation.fillMode = kCAFillModeForwards;
	donutFillAnimation.removedOnCompletion = NO;

	donutEmptyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	[donutEmptyAnimation setToValue:[NSNumber numberWithFloat:0.0]];
	[donutEmptyAnimation setDuration:0.3];
	[donutEmptyAnimation setBeginTime:0.0];
	donutEmptyAnimation.fillMode = kCAFillModeForwards;
	donutEmptyAnimation.removedOnCompletion = NO;

	donutfadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[donutfadeOut setFromValue:[NSNumber numberWithFloat:1.0]];
	[donutfadeOut setToValue:[NSNumber numberWithFloat:0.0]];
	[donutfadeOut setDuration:0.05];
	[donutfadeOut setBeginTime:0.25];
	donutfadeOut.fillMode = kCAFillModeForwards;
	donutfadeOut.removedOnCompletion = NO;

	DOOpenFolderAnimationGroup = [CAAnimationGroup animation];
	[DOOpenFolderAnimationGroup setDuration:0.5];
	[DOOpenFolderAnimationGroup setAnimations:[NSArray arrayWithObjects: donutMoveDrawerUp, donutfadeIn, donutFillAnimation, nil]];
	DOOpenFolderAnimationGroup.fillMode = kCAFillModeForwards;
	DOOpenFolderAnimationGroup.removedOnCompletion = NO;
	[DOCloseFolderAnimationGroup setValue:@"DOOpenFolderAnimationGroup" forKey:@"animationName"];

	DOCloseFolderAnimationGroup = [CAAnimationGroup animation];
	[DOCloseFolderAnimationGroup setDuration:0.3];
	[DOCloseFolderAnimationGroup setAnimations:[NSArray arrayWithObjects: donutEmptyAnimation, donutfadeOut, nil]];
	DOCloseFolderAnimationGroup.fillMode = kCAFillModeForwards;
	DOCloseFolderAnimationGroup.removedOnCompletion = NO;
	[DOCloseFolderAnimationGroup setValue:@"DOCloseFolderAnimationGroup" forKey:@"animationName"];
	//reloadPreferences();

	//CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
	//CFNotificationCenterAddObserver(center, NULL, &prefsChanged, (CFStringRef)@"com.atrocity.donut/prefsChanged", NULL, 0);
}
