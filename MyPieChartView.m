
#import "MyPieChartView.h"
static inline NSDocument *docContext()	{
    return [NSDocumentController.sharedDocumentController currentDocument];
}
@implementation MyPieChartView

- (NSA*)findAllObjects	{
	return (self.managedObjectContext)?
	 [self.managedObjectContext fetchObjectsForEntityName:@"PieSegment"]: nil;
}

- (void) awakeFromNib {


	[[@0 to:@5] do:^(id obj) {
		NSManagedObject *source;
		[_ac add: source];
	}];
//	NSManagedObject *centipede = [NSManagedObject.alloc initWithEntity:[NSEntityDescription entityForName:@"PieSegment" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
//	[centipede setValue:@11 forKey:@"amount"];
//	[centipede setValue:@"Centipede" forKey:@"name"];
//	[centipede setValue:RED forKey:@"color"];
	//[NSKeyedArchiver archivedDataWithRootObject:PURPLE] forKey:@"color"];
	//[file stringByAppendingString:[AZAPPBUNDLE pathForImageResource:@"centipede.jpg"]] forKey:@"imagePath"];
}
#pragma mark Initialization and Destruction
+ (void)initialize						{
	[@[@"segmentNamesArray",@"segmentValuesArray", @"selectionIndexes",@"rotationAmount"]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self exposeBinding:obj];
	}];
}
#pragma mark Drawing
- (void)drawRect:(NSRect)rect			{

	[[@0 to:@3] eachWithIndex:^(id obj, NSInteger idx) {
		NSRectFillWithColor(AZRectOfQuadInRect(self.bounds,idx),[NSC colorFromAZeColor:RAND_INT_VAL(0, 124)]);
	}];
//	[self inLiveResize] ? [self generateDrawingInformation] : nil;
	
	[self.segmentPathsArray enumerateObjectsUsingBlock:^(NSBP *path, NSUInteger idx, BOOL *stop) {
		// fill the path with the drawing color for this index unless it's selected
		[self.selectionIndexes containsIndex:idx] ?
			[NSGraphicsContext state:^{
				[[NSBP diagonalLinesInRect:rect phase:.2] addClip];
				[path fillWithColor:BLACK];
			}] : ^{
			[path fillWithColor:[self colorForIndex:idx]];
		}();		
		// draw a black border around it
		[[NSColor blackColor] set];
		[path stroke];
		NSDictionary *txt;
		if ((txt = self.segmentTextsArray[idx]))
			[txt[@"text"] drawAtPoint:(NSPoint){ [txt[@"textPointX"] floatValue], [txt[@"textPointY"] floatValue] } withAttributes:txt[@"textAttributes"]];
	}];
}
- (NSColor *)colorForIndex:(NSUInteger)index {	
	return [_ac.arrangedObjects count] >= index ? [_ac.arrangedObjects[index] valueForKey:@"color"] : RANDOMCOLOR;
}
//- (void)generateDrawingInformation
//{
//
////	[newSelectionIndexes release];
//}
#pragma mark View Behavior Overrides
- (BOOL)isFlipped					{	return YES;	}
- (BOOL)acceptsFirstResponder	{	return YES;	}

#pragma mark Accessors
+ (NSSet*) keyPathsForValuesAffectingNeedsDisplay 	{
	return [NSSet setWithObjects:@"segmentValuesArray", @"segmentNamesArray", @"rotationAmount", @"selectionIndexes", nil]; 
}
- (BOOL) needsDisplay 					 {

	
		[self.findAllObjects log];
	
//	[self generateDrawingInformation];
	// Keep pointers to the segmentValuesArray and segmentNamesArray
	NSArray *cachedSegmentValuesArray 	= self.segmentValuesArray;
	NSArray *cachedSegmentNamesArray 	= self.segmentNamesArray;
	// Get rid of any existing Paths Array
	if( _segmentPathsArray )		_segmentPathsArray = nil;
	// Get rid of any existing Texts Array
	if( _segmentTextsArray )		_segmentTextsArray = nil;
	// If there aren't any values to display, we can exit now
	if( [cachedSegmentValuesArray count] < 1 )		return NO;
	// Get the sum of the amounts and exit if it is zero
	NSNumber *sumOfAmounts = [cachedSegmentValuesArray sum];
	if( [sumOfAmounts isEqualToNumber:@0] )	return NO;
	_segmentPathsArray = NSMA.new;	_segmentTextsArray = NSMA.new;
	NSIndexSet *selectionIndexes = self.selectionIndexes;
	BOOL shouldOffsetSelectedSegment = selectionIndexes.count;
	
#define PADDINGAROUNDGRAPH 20.0
#define TEXTPADDING 5.0
#define SELECTEDSEGMENTOFFSET 5.0
	
	NSRect viewBounds = self.bounds;
	NSRect graphRect = NSInsetRect(viewBounds, PADDINGAROUNDGRAPH, PADDINGAROUNDGRAPH);
	
	// Make the graphRect square and centred
	BOOL wide = graphRect.size.width > graphRect.size.height;
	double sizeDifference = wide ? graphRect.size.width - graphRect.size.height : graphRect.size.height - graphRect.size.width;
	if (wide) graphRect.size.width = graphRect.size.height; 	else graphRect.size.height = graphRect.size.width;
	if (wide) graphRect.origin.x += (sizeDifference / 2); 	else graphRect.origin.y += (sizeDifference / 2);

	// get NSRects for the different quarters of the pie-chart
//	NSRect topLeftRect, topRightRect;
//	NSDivideRect(viewBounds, &topLeftRect, &topRightRect, (viewBounds.size.width / 2), NSMinXEdge );
//	NSRect bottomLeftRect, bottomRightRect;
//	NSDivideRect(topLeftRect, &topLeftRect, &bottomLeftRect, (viewBounds.size.height / 2), NSMinYEdge );
//	NSDivideRect(topRightRect, &topRightRect, &bottomRightRect, (viewBounds.size.height / 2), NSMinYEdge );
	
	// Calculate how big a 'unit' is
	CGF unitSize = (360.0 / sumOfAmounts.floatValue);
	if( unitSize > 360 )	unitSize = 360;
	CGF radius = graphRect.size.width / 2;
	NSPoint midPoint = NSMakePoint( NSMidX(graphRect), NSMidY(graphRect) );
	
	// Set the text attributes to be used for each textual display
	NSD *attrs = @{NSBackgroundColorAttributeName:WHITE, NSForegroundColorAttributeName:BLACK,NSFontAttributeName:AtoZ.controlFont};
	
	// cycle through the segmentValues and create the bezier paths Also add the text details (note we expect the texts' indexes to tie up with the values' indexes)
	__block CGF currentDegree = self.rotationAmount.floatValue;
	[cachedSegmentValuesArray eachWithIndex:^(NSN* eachValue, NSInteger idx) {

		float startDegree = currentDegree;
		currentDegree += (eachValue.floatValue * unitSize);
		float endDegree = currentDegree;
		float midDegree = startDegree + ((endDegree - startDegree) / 2);
		
		NSBP *eachSegmentPath = [NSBP bezierPath];
		[eachSegmentPath moveToPoint:midPoint];
		[eachSegmentPath appendBezierPathWithArcWithCenter:midPoint radius:radius startAngle:startDegree endAngle:midDegree clockwise:NO];
		NSPoint textPoint = [eachSegmentPath currentPoint];
		
		[eachSegmentPath appendBezierPathWithArcWithCenter:midPoint radius:radius startAngle:midDegree endAngle:endDegree clockwise:NO];
		[eachSegmentPath closePath]; // close path also handles the lines from the midPoint to the start and end of the arc
		[eachSegmentPath setLineWidth:2.0];
		// Check to see whether we should offset this segment if it's currently selected in the array controller
		if( shouldOffsetSelectedSegment && [selectionIndexes containsIndex:idx] )
		{
			float differenceRatio = (SELECTEDSEGMENTOFFSET / radius) + (SELECTEDSEGMENTOFFSET / (endDegree - startDegree));
			float diffY = (textPoint.y - midPoint.y) * differenceRatio;
			float diffX = (textPoint.x - midPoint.x) * differenceRatio;
			NSAffineTransform *transform = NSAffineTransform.transform;
			[transform translateXBy:diffX yBy:diffY];
			[eachSegmentPath transformUsingAffineTransform: transform];
			textPoint = [transform transformPoint:textPoint];
		}
		[_segmentPathsArray addObject:eachSegmentPath];
		
		// Get the text to be displayed, if it exists, and see how big it is
		NSString *eachText =  cachedSegmentNamesArray.count > idx ? cachedSegmentNamesArray[idx] : @"";
		NSSize textSize = [eachText sizeWithAttributes:attrs];
		// Offset it by TEXTPADDING in direction suitable for whichever quarter of the view it is in
		if( NSPointInRect(textPoint, AZRectOfQuadInRect(viewBounds, AZQuadTopLeft))) {  //topLeftRect) )			{
			textPoint.y -= (textSize.height + TEXTPADDING);	textPoint.x -= (textSize.width + TEXTPADDING);	}
		else if( NSPointInRect(textPoint, AZRectOfQuadInRect(viewBounds, AZQuadTopRight))) { //topRightRect) )	{
			textPoint.y -= (textSize.height + TEXTPADDING);	textPoint.x += TEXTPADDING;							}
		else if( NSPointInRect(textPoint, AZRectOfQuadInRect(viewBounds, AZQuadBotLeft)))	{
			textPoint.y += TEXTPADDING;	textPoint.x -= (textSize.width + TEXTPADDING);							}
		else if(NSPointInRect(textPoint, AZRectOfQuadInRect(viewBounds, AZQuadBotRight)))	{
			textPoint.y += TEXTPADDING;	textPoint.x += TEXTPADDING;													}
		
		// Make sure the point isn't outside the view's bounds
		if( textPoint.x < viewBounds.origin.x)		 textPoint.x 			  = viewBounds.origin.x;	
		if((textPoint.x +   textSize.width) 	> (viewBounds.origin.x 	  + viewBounds.size.width))
			 textPoint.x = viewBounds.origin.x  +  viewBounds.size.width  -   textSize.width;
		if( textPoint.y < viewBounds.origin.y)	    textPoint.y 			  = viewBounds.origin.y;
		if((textPoint.y +   textSize.height)   > (viewBounds.origin.y 	  + viewBounds.size.height))
			 textPoint.y = viewBounds.origin.y  +  viewBounds.size.height -   textSize.height;

		// Finally add the details as a dictionary to our segmentTextsArray.
		// We include here the textAttributes lest we decide later to e.g. color the texts the same color as the segment fill
		[_segmentTextsArray addObject:@{@"textPointX":@(textPoint.x),  @"textPointY":@(textPoint.y),@"text": eachText, @"textAttributes": attrs}];
	}];
	[self setNeedsDisplayInRect:[self visibleRect]];
	return [super needsDisplay];

}
#pragma mark Event Handling
- (int)objectIndexForPoint:(NSPoint)thePoint	{
	for(NSBP *path in self.segmentPathsArray)
		if ([path containsPoint:thePoint]) return [self.segmentPathsArray indexOfObject:path];
	// if control reaches here, no segment contained the point so return -1	
	return -1;
}
- (void)mouseUp:(NSEvent *)theEvent	{
	int index = [self objectIndexForPoint:[self convertPoint:theEvent.locationInWindow fromView:nil]];
	__block NSMutableIndexSet *newSelectionIndexes = self.selectionIndexes.mutableCopy;
	theEvent.modifierFlags & NSCommandKeyMask ?
		// Add or remove the clicked segment
		[newSelectionIndexes containsIndex:index] ? [newSelectionIndexes removeIndex:index]
																: [newSelectionIndexes addIndex:index] 
	: [theEvent modifierFlags] & NSShiftKeyMask  ?
		// Add range to selection
		!newSelectionIndexes.count ? [newSelectionIndexes addIndex:index] : ^{
			NSUInteger origin = index < newSelectionIndexes.lastIndex ? index : newSelectionIndexes.lastIndex;
			NSUInteger length = index < newSelectionIndexes.lastIndex ? newSelectionIndexes.lastIndex - index : index - newSelectionIndexes.lastIndex;
			
			length++;
			[newSelectionIndexes addIndexesInRange:NSMakeRange(origin, length)];
		}() :
	 // the user just clicked without modifier keys so simply select the segment
	^{
		[newSelectionIndexes removeAllIndexes];
		index >= 0 ? [newSelectionIndexes addIndex:index] : nil;
	}();
	[self setSelectionIndexes:newSelectionIndexes];
	
}
@end

//
//- (void)setSegmentNamesArray:(NSArray *)newArray
//{
//	[self willChangeValueForKey:@"segmentNamesArray"];
//	_segmentNamesArray = [newArray copy];
//	[self didChangeValueForKey:@"segmentNamesArray"];
//	
//	[self generateDrawingInformation];
//	[self setNeedsDisplayInRect:[self visibleRect]];
//}
//
//- (void)setSegmentValuesArray:(NSArray *)newArray
//{
//	[self willChangeValueForKey:@"segmentValuesArray"];
//	_segmentValuesArray = [newArray copy];
//	[self didChangeValueForKey:@"segmentValuesArray"];
//	
//	[self generateDrawingInformation];
//	[self setNeedsDisplayInRect:[self visibleRect]];
//}

//- (void)setSelectionIndexes:(NSIndexSet *)newIndexes
//{
//	if ((_selectionIndexes != newIndexes) && (![_selectionIndexes isEqualToIndexSet:newIndexes]))
//	{
//		[self willChangeValueForKey:@"selectionIndexes"];
//		_selectionIndexes = [newIndexes copy];
//		[self didChangeValueForKey:@"selectionIndexes"];
//		
//		[self generateDrawingInformation];
//		[self setNeedsDisplayInRect:[self visibleRect]];
//	}
//}
//- (NSNumber *)rotationAmount	{	return _rotationAmount;}
//
//- (void)setRotationAmount:(NSNumber *)value	{
//
//	if( value  != _rotationAmount )
//	{
//		[self willChangeValueForKey:@"rotationAmount"];
//		_rotationAmount = value;
//		[self didChangeValueForKey:@"rotationAmount"];
//		
////		[self generateDrawingInformation];
////		[self setNeedsDisplayInRect:[self visibleRect]];
//	}
//}
