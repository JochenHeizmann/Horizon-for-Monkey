/*
This file is based on MKStoreKit by Mugunth Kumar. MKStoreKit files were merged for Monkey needs.
Some of them were modified for our needs.

MKStoreKit function wrappers by Roman Budzowski (c) 21.07.2011

*/


//
//  MKStoreObserver.m
//  MKStoreKit
//
//  Created by Mugunth Kumar on 17-Nov-2010.
//  Copyright 2010 Steinlogic. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website
//	2) or crediting me inside the app's credits page
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code,
//	if you are re-publishing after editing, please retain the above copyright notices



#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



@interface MKStoreObserver : NSObject<SKPaymentTransactionObserver> {


}

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;

@end
////////// MKStoreManager.h starts here
/////////
///////
/////

// CONFIGURATION STARTS -- Change this in your app
//#define kConsumableBaseFeatureId @"com.mycompany.myapp."
//#define kFeatureAId @"com.mycompany.myapp.featureA"
//#define kConsumableFeatureBId @"com.mycompany.myapp.005"
// consumable features should have only number as the last part of the product name
// MKStoreKit automatically keeps track of the count of your consumable product



#define SERVER_PRODUCT_MODEL 0
// CONFIGURATION ENDS -- Change this in your app

@protocol MKStoreKitDelegate <NSObject>
@optional
- (void)productFetchComplete;
- (void)productPurchased:(NSString *)productId;
- (void)transactionCanceled;
// as a matter of UX, don't show a "User Canceled transaction" alert view here
// use this only to "enable/disable your UI or hide your activity indicator view etc.,
@end

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *_purchasableObjects;
	MKStoreObserver *_storeObserver;

	NSMutableSet *productsList;
	NSString *bundleID;

	BOOL isProductsAvailable;
	BOOL isPurchaseInProgress;
    BOOL wasError;
	int purchaseResult;
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;
@property (nonatomic, retain) NSString *bundleID;
@property (readwrite, assign) BOOL isPurchaseInProgress;
@property (readwrite, assign) BOOL wasError;
@property (readwrite, assign) int purchaseResult;
@property (copy) NSSet *productsList;

// These are the methods you will be using in your app
+ (MKStoreManager*)sharedManager;

// this is a static method, since it doesn't require the store manager to be initialized prior to calling
+ (BOOL) isFeaturePurchased:(NSString*) featureId;

// these three are not static methods, since you have to initialize the store with your product ids before calling this function
- (void) buyFeature:(NSString*) featureId;
- (NSMutableArray*) purchasableObjectsDescription;
- (void) restorePreviousTransactions;
- (void) setProductsList:(NSSet*) value;

- (BOOL) canConsumeProduct:(NSString*) productIdentifier quantity:(int) quantity;
- (BOOL) consumeProduct:(NSString*) productIdentifier quantity:(int) quantity;


//DELEGATES
+(id)delegate;
+(void)setDelegate:(id)newDelegate;

@end

/////// implementations
///////
/////  MKStoreObsersver.cpp
///
//


@implementation MKStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchasing:
				 NSLog(@"order start");
				[[MKStoreManager sharedManager] setIsPurchaseInProgress: YES];
				break;

			case SKPaymentTransactionStatePurchased:
				 NSLog(@"state purchased");                 
				[[MKStoreManager sharedManager] setIsPurchaseInProgress: NO];
				[[MKStoreManager sharedManager] setPurchaseResult: 2];
                [self completeTransaction:transaction];
                break;

            case SKPaymentTransactionStateFailed:
				 NSLog(@"state failed");
				[[MKStoreManager sharedManager] setIsPurchaseInProgress: NO];
				[[MKStoreManager sharedManager] setPurchaseResult: 3];
                [self failedTransaction:transaction];
                break;

            case SKPaymentTransactionStateRestored:
				 NSLog(@"State restored");
				[[MKStoreManager sharedManager] setIsPurchaseInProgress: NO];
				[[MKStoreManager sharedManager] setPurchaseResult: 4];
                [self restoreTransaction:transaction];

            default:
                break;
		}
	}
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	bool b_retry=false;
	NSLog(@"%@", transaction);
	switch (transaction.error.code)
	{
		case SKErrorPaymentCancelled:
			 NSLog(@"SKErrorPaymentCancelled");
		break;

		case SKErrorUnknown:
			 NSLog(@"SKErrorUnknown %@ | %@", transaction.error.localizedDescription, transaction.error.localizedFailureReason );
		break;

		case SKErrorClientInvalid:
			 NSLog(@"SKErrorClientInvalid");
		break;

		case SKErrorPaymentInvalid:
			 NSLog(@"SKErrorPaymentInvalid");
		break;

		case SKErrorPaymentNotAllowed:
			NSLog(@"SKErrorPaymentNotAllowed");
		break;

		default:
			 NSLog(@"## MISSING ERROR CODE TRANSCATION");
			b_retry=true;
			break;
	}

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	if (b_retry)
	{
//		BuyItem(0);
	}
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	[[MKStoreManager sharedManager] provideContent:transaction.payment.productIdentifier
									   forReceipt:transaction.transactionReceipt];

	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	NSLog(@"IAP Purchase completed: %@", transaction.payment.productIdentifier);

	#ifndef NDEBUG
	// NSLog(@"IAP Purchase completed");
	#endif
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[MKStoreManager sharedManager] provideContent: transaction.originalTransaction.payment.productIdentifier
									   forReceipt:transaction.transactionReceipt];

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	#ifndef NDEBUG
	 NSLog(@"IAP Restore Purchases completed");
	#endif

     [[MKStoreManager sharedManager] setIsPurchaseInProgress: YES];

}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[MKStoreManager sharedManager] setIsPurchaseInProgress: NO];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[MKStoreManager sharedManager] setIsPurchaseInProgress: NO];
    NSLog(@"Error: %@", error);
}


@end


/////// implementations
///////
///// MKStoreManager.cpp
///
//

@implementation MKStoreManager

@synthesize purchasableObjects = _purchasableObjects;
@synthesize storeObserver = _storeObserver;
@synthesize bundleID;
@synthesize purchaseResult;
@synthesize isPurchaseInProgress;
@synthesize wasError;

static NSString *ownServer = nil;

static __weak id<MKStoreKitDelegate> _delegate;
static MKStoreManager* _sharedStoreManager;


- (void)dealloc {

	[_purchasableObjects release];
	[_storeObserver release];

	[bundleID release];
//	[_productsList release];

	[_sharedStoreManager release];
	[super dealloc];
}

#pragma mark Delegates

+ (id)delegate {

    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {

    _delegate = newDelegate;
}

#pragma mark Singleton Methods

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {

        if (_sharedStoreManager == nil) {

#if TARGET_IPHONE_SIMULATOR
			// NSLog(@"You are running in Simulator MKStoreKit runs only on devices");
#else
            _sharedStoreManager = [[self alloc] init];
#endif
        }
    }
    return _sharedStoreManager;
}


+ (void)startManager
{
	#if TARGET_IPHONE_SIMULATOR
		// NSLog(@"IAP doesn't run on simulator");
	#else
		NSLog(@"start manager");
		_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
		[_sharedStoreManager requestProductData];
		_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
	#endif
}

+ (id)allocWithZone:(NSZone *)zone

{
    @synchronized(self) {

        if (_sharedStoreManager == nil) {

            _sharedStoreManager = [super allocWithZone:zone];
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

#pragma mark Internal MKStoreKit functions

//- (NSSet *) productsList {
//	return [NSSet setWithSet:_productsList];
//}

- (void) setProductsList:(NSSet *) value {

	if (productsList == nil) {
		productsList = [[NSMutableSet alloc] init];
	}

	[productsList setSet:value];
}


- (void) restorePreviousTransactions
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productsList];

	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[self.purchasableObjects addObjectsFromArray:response.products];

//#ifndef NDEBUG
	for(int i=0;i<[self.purchasableObjects count];i++)
	{
		SKProduct *product = [self.purchasableObjects objectAtIndex:i];
		 NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
		 	  [[product price] doubleValue], [product productIdentifier]);
	}

	for(NSString *invalidProduct in response.invalidProductIdentifiers) {
        [[MKStoreManager sharedManager] setWasError: YES];
	    NSLog(@"Problem in iTunes connect configuration for product: %@", invalidProduct);
    }
//#endif

	[request autorelease];

	isProductsAvailable = YES;

	if([_delegate respondsToSelector:@selector(productFetchComplete)])
		[_delegate productFetchComplete];
}


// call this function to check if the user has already purchased your feature
+ (BOOL) isFeaturePurchased:(NSString*) featureId
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:featureId];
}

// Call this function to populate your UI
// this function automatically formats the currency based on the user's locale

- (NSMutableArray*) purchasableObjectsDescription
{
	NSMutableArray *productDescriptions = [[NSMutableArray alloc] initWithCapacity:[self.purchasableObjects count]];
	for(int i=0;i<[self.purchasableObjects count];i++)
	{
		SKProduct *product = [self.purchasableObjects objectAtIndex:i];

		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:product.price];
		[numberFormatter release];

		// you might probably need to change this line to suit your UI needs
		NSString *description = [NSString stringWithFormat:@"%@;%@;%@",[product productIdentifier],[product localizedTitle], formattedString];

		[productDescriptions addObject: description];
	}

	[productDescriptions autorelease];
	return productDescriptions;
}


- (void) buyFeature:(NSString*) featureId
{
	if([self canCurrentDeviceUseFeature: featureId])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Review request approved", @"")
														message:NSLocalizedString(@"You can use this feature for reviewing the app.", @"")
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];

		[self enableContentForThisSession:featureId];
		return;
	}

	if ([SKPaymentQueue canMakePayments])
	{
		NSLog(@"[buyFeature] Trying to buy %@", featureId);
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchasing disabled", @"")
														message:NSLocalizedString(@"Check your parental control settings and try again later", @"")
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (BOOL) canConsumeProduct:(NSString*) productIdentifier
{
	int count = [[NSUserDefaults standardUserDefaults] integerForKey:productIdentifier];
	return (count > 0);

}

- (BOOL) canConsumeProduct:(NSString*) productIdentifier quantity:(int) quantity
{
	int count = [[NSUserDefaults standardUserDefaults] integerForKey:productIdentifier];
	return (count >= quantity);
}

- (BOOL) consumeProduct:(NSString*) productIdentifier quantity:(int) quantity
{
	int count = [[NSUserDefaults standardUserDefaults] integerForKey:productIdentifier];
	if(count < quantity)
	{
		return NO;
	}
	else
	{
        NSLog(@"old count: %d (-%d)", count, quantity);
		count -= quantity;
		[[NSUserDefaults standardUserDefaults] setInteger:count forKey:productIdentifier];
        NSLog(@"new count: %d", count);
		return YES;
	}

}

-(void) enableContentForThisSession: (NSString*) productIdentifier
{
	if([_delegate respondsToSelector:@selector(productPurchased:)])
		[_delegate productPurchased:productIdentifier];
}


#pragma mark In-App purchases callbacks
// In most cases you don't have to touch these methods
-(void) provideContent: (NSString*) productIdentifier
		   forReceipt:(NSData*) receiptData
{
	NSLog(@"Provide Content!");
	if(ownServer != nil && SERVER_PRODUCT_MODEL)
	{
		// ping server and get response before serializing the product
		// this is a blocking call to post receipt data to your server
		// it should normally take a couple of seconds on a good 3G connection
		if(![self verifyReceipt:receiptData]) return;
	}

	NSRange range = [productIdentifier rangeOfString: @"." options: NSBackwardsSearch];
	// if (range.location == NSNotFound) NSLog(@"invalid product id");

	NSString *countText = [productIdentifier substringFromIndex:range.location+1];

	int quantityPurchased = [countText intValue];
	NSLog(@"%d Quantity purchased", quantityPurchased);

	if(quantityPurchased != 0)
	{
		countText = [productIdentifier substringToIndex:range.location];
        /*
		int oldCount = [[NSUserDefaults standardUserDefaults] integerForKey:countText];
		oldCount += quantityPurchased;


		[[NSUserDefaults standardUserDefaults] setInteger:oldCount forKey:countText];
        */
        int count = [[NSUserDefaults standardUserDefaults] integerForKey:productIdentifier];
        count += quantityPurchased;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:productIdentifier];

        NSLog(@"%d <-- new count", count);
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
	}

	[[NSUserDefaults standardUserDefaults] synchronize];

	if([_delegate respondsToSelector:@selector(productPurchased:)])
		[_delegate productPurchased:productIdentifier];
}

- (void) transactionCanceled: (SKPaymentTransaction *)transaction
{

#ifndef NDEBUG
	 NSLog(@"User cancelled transaction: %@", [transaction description]);

   if (transaction.error.code != SKErrorPaymentCancelled)
    {
		if(transaction.error.code == SKErrorUnknown) {
			 NSLog(@"Unknown Error (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
			UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
																	message: @"There was an error purchasing this item please try again."
																  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
			[failureAlert show];
			[failureAlert release];
		}

		if(transaction.error.code == SKErrorClientInvalid) {
			 NSLog(@"Client invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
			UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
																	message: @"There was an error purchasing this item please try again."
																  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
			[failureAlert show];
			[failureAlert release];
		}

		if(transaction.error.code == SKErrorPaymentInvalid) {
			 NSLog(@"Payment invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
			UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
																	message: @"There was an error purchasing this item please try again."
																  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
			[failureAlert show];
			[failureAlert release];
		}

		if(transaction.error.code == SKErrorPaymentNotAllowed) {
			 NSLog(@"Payment not allowed (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
			UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
																	message: @"There was an error purchasing this item please try again."
																  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
			[failureAlert show];
			[failureAlert release];
		}
    }
#endif

	if([_delegate respondsToSelector:@selector(transactionCanceled)])
		[_delegate transactionCanceled];
}



- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[transaction.error localizedFailureReason]
													message:[transaction.error localizedRecoverySuggestion]
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}


#pragma mark In-App purchases promo codes support
// This function is only used if you want to enable in-app purchases for free for reviewers
// Read my blog post http://mk.sg/31
- (BOOL) canCurrentDeviceUseFeature: (NSString*) featureID
{
	NSString *uniqueID = [[UIDevice currentDevice] uniqueIdentifier];
	// check udid and featureid with developer's server

	if(ownServer == nil) return NO; // sanity check

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ownServer, @"featureCheck.php"]];

	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60];

	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	NSString *postData = [NSString stringWithFormat:@"productid=%@&udid=%@", featureID, uniqueID];

	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	[theRequest setValue:length forHTTPHeaderField:@"Content-Length"];

	[theRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];

	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[[NSError alloc] init] autorelease];

	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
												 returningResponse:&urlResponse
															 error:&error];

	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];

	BOOL retVal = NO;
	if([responseString isEqualToString:@"YES"])
	{
		retVal = YES;
	}

	[responseString release];
	return retVal;
}

// This function is only used if you want to enable in-app purchases for free for reviewers
// Read my blog post http://mk.sg/

-(BOOL) verifyReceipt:(NSData*) receiptData
{
	if(ownServer == nil) return NO; // sanity check

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ownServer, @"verifyProduct.php"]];

	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60];

	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	NSString *receiptDataString = [[NSString alloc] initWithData:receiptData encoding:NSASCIIStringEncoding];
	NSString *postData = [NSString stringWithFormat:@"receiptdata=%@", receiptDataString];
	[receiptDataString release];

	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	[theRequest setValue:length forHTTPHeaderField:@"Content-Length"];

	[theRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];

	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[[NSError alloc] init] autorelease];

	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
												 returningResponse:&urlResponse
															 error:&error];

	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];

	BOOL retVal = NO;
	if([responseString isEqualToString:@"YES"])
	{
		retVal = YES;
	}

	[responseString release];
	return retVal;
}
@end





///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////








//------ IS PRODUCT PURCHASED ------
int isProductPurchased(String product) {
	NSString *kFeatureID = product.ToNSString();

	if([MKStoreManager isFeaturePurchased:kFeatureID])
	{
		NSLog(@"Product %@ purchased", kFeatureID);
		return true;
	}
//NSLog(@"Product %@ not purchased", kFeatureID);
	return false;
}



//------ BUY PRODUCT ------
void buyProduct(String product) {
	NSString *kProductID = product.ToNSString();
    NSLog(@"[buyProduct] Trying to purchase: %@", kProductID);

	[[MKStoreManager sharedManager] buyFeature:kProductID];
}



/* ------ GET PRODUCTS DESCRIPTION ------ */

Array<String> getProductsDescription() {
	NSMutableArray *productDescriptions;
	productDescriptions = [[MKStoreManager sharedManager] purchasableObjectsDescription];

	NSString *item;

	unsigned count = [productDescriptions count];
    unsigned count2 = 0;

//	String *descriptions = malloc(count*sizeof(String));
	Array<String> descriptions(count);

	while (count--) {
	    item = [productDescriptions objectAtIndex:count];
		descriptions[count2++] = String([item lossyCString]);
	}

	return descriptions;
}


//------ CAN CONSUME PRODUCT -----
bool canConsumeProduct(String product) {
	NSString *kFeatureID = product.ToNSString();

	#ifndef NDEBUG
	// NSLog(@"can consume product?: %@", kFeatureID);
	#endif

	return [[MKStoreManager sharedManager] canConsumeProduct:kFeatureID];
}

//------ CONSUME PRODUCT -----
bool consumeProduct(String product, int quantity = 1) {
    NSString *kFeatureID = product.ToNSString();

    return [[MKStoreManager sharedManager] consumeProduct:kFeatureID quantity: quantity];
}

//------ INIT IAP ------
void InitInAppPurchases(String bundleID, Array<String> prodList) {

    [[MKStoreManager sharedManager] setWasError: NO];

	[MKStoreManager sharedManager];

	[[MKStoreManager sharedManager] setBundleID:bundleID.ToNSString()];

	NSMutableArray *nsaProdList = [[NSMutableArray alloc] init];
	NSString *prodID;
	for (int i=0; i < prodList.Length(); i++) {
		prodID = prodList[i].ToNSString();
		[nsaProdList addObject: prodID];

	}
	NSLog(@"BundleId: %@", bundleID.ToNSString());
	NSLog(@"Init %@", nsaProdList);

	[[MKStoreManager sharedManager] setProductsList:[NSSet setWithArray:nsaProdList]];
	// [nsaProdList release];

	[MKStoreManager startManager];
}

void requestProductData()
{
    [[MKStoreManager sharedManager] requestProductData];
}

void restorePurchasedProducts() {
//	NSLog(@"trying to restore");
    [[MKStoreManager sharedManager] setIsPurchaseInProgress: YES];
	[[MKStoreManager sharedManager] restorePreviousTransactions];
}


bool isPurchaseInProgress() {
	return [[MKStoreManager sharedManager] isPurchaseInProgress];
}

bool wasError() {
    return [[MKStoreManager sharedManager] wasError];
}
int productQuantity(String product)
{
    int count = [[NSUserDefaults standardUserDefaults] integerForKey:product.ToNSString()];
    return count;
}

int getPurchaseResult() {
	return [[MKStoreManager sharedManager] purchaseResult];
}

void resetPurchaseResult() {
	[[MKStoreManager sharedManager] setPurchaseResult: 0];
}