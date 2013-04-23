//
//  MyPieChartView.h
//  CustomNSView
//
//  Created by Tim Isted on 27/11/2008.
//  Copyright Tim Isted © 2008. All rights reserved.
//
//  If this is useful to you, please let me know.
//  All acknowledgements encouraged and gratefully received!
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import <Cocoa/Cocoa.h>


@interface MyPieChartView : NSView 
{
	NSArray *_segmentNamesArray;
	NSArray *_segmentValuesArray;
	
	NSMutableArray *_segmentPathsArray;
	NSMutableArray *_segmentTextsArray;
	
	NSIndexSet *_selectionIndexes;
	
	float _rotationAmount;
}

- (NSArray *)segmentNamesArray;
- (void)setSegmentNamesArray:(NSArray *)newArray;

- (NSArray *)segmentValuesArray;
- (void)setSegmentValuesArray:(NSArray *)newArray;

- (NSArray *)segmentPathsArray;
- (NSArray *)segmentTextsArray;
- (void)generateDrawingInformation;

- (NSColor *)randomColor;
- (NSColor *)colorForIndex:(unsigned)index;

- (NSIndexSet *)selectionIndexes;
- (void)setSelectionIndexes:(NSIndexSet *)newIndexes;

- (int)objectIndexForPoint:(NSPoint)thePoint;

- (void)setRotationAmount:(NSNumber *)value;
- (NSNumber *)rotationAmount;

@end