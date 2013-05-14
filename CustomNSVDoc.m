//
#import "CustomNSVDoc.h"

@implementation CustomNSVDoc

-(BOOL)configurePersistentStoreCoordinatorForURL:(NSURL*)u ofType:(NSS*)t 
			modelConfiguration:(NSS*)c storeOptions:(NSD*)opts error:(NSERR**)error	{
	return [super configurePersistentStoreCoordinatorForURL:u ofType:t modelConfiguration:c storeOptions:[opts dictionaryByAppendingEntriesFromDictionary:@{NSMigratePersistentStoresAutomaticallyOption : @"YES",NSInferMappingModelAutomaticallyOption : @"TRUE"}] error:error];
}
//- (NSString *)windowNibName 	{    return @"CustomNSVDoc";	}

- (void)makeWindowControllers
{
	NSWindowController *mainWindowController = [[NSWindowController alloc] initWithWindowNibName:@"CustomNSVDoc" owner:self];
 	[mainWindowController setShouldCloseDocument:YES];
	[self addWindowController:mainWindowController];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
	[super windowControllerDidLoadNib:windowController];
	
	[pieChartView bind:@"segmentNamesArray" toObject:segmentsArrayController withKeyPath:@"arrangedObjects.name" options:nil];
	[pieChartView bind:@"segmentValuesArray" toObject:segmentsArrayController withKeyPath:@"arrangedObjects.amount" options:nil];
	[pieChartView bind:@"selectionIndexes" toObject:segmentsArrayController withKeyPath:@"selectionIndexes" options:nil];
	[segmentsArrayController bind:@"selectionIndexes" toObject:pieChartView withKeyPath:@"selectionIndexes" options:nil];
	[sliderRotationControl bind:@"value" toObject:pieChartView withKeyPath:@"rotationAmount" options:nil];
	[well bind:@"value" toObject:segmentsArrayController withKeyPath:@"selection.color" options:nil];
}

@end



@implementation NSColorTransformer
// Here we override the method that returns the class of objects that this transformer can convert.
+ (Class)transformedValueClass 		{    return [NSData class];						}
+ (BOOL)allowsReversTransformation 	{   
// Here we indicate that our converter supports two-way conversions. That is, we need  to convert UICOLOR to an instance of NSData and back from an instance of NSData to an instance of UIColor. Otherwise, we wouldn't be able to beth save and retrieve values from the persistent store.
												return YES;										}
- (id)transfomedValue:(id)value 		{
	// Takes a UIColor, returns an NSData
	NSColor *color = value;
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
	return [colorAsString dataUsingEncoding:NSUTF8StringEncoding];
}
- (id)reverseTransformedValue:(id)v {
	// Takes an NSData, returns a UIColor
   NSString *colorAsString = [NSString.alloc initWithData:v encoding:NSUTF8StringEncoding];
	NSArray *comps = [colorAsString componentsSeparatedByString:@","];
   return [NSColor colorWithDeviceRed:[comps[0]floatValue] green:[comps[0]floatValue] blue:[comps[2]floatValue] alpha:[comps[3]floatValue]];
}
@end
