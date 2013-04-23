//
//  MyDocument.m
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

#import "MyDocument.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        // initialization code
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
	[super windowControllerDidLoadNib:windowController];
	
	[pieChartView bind:@"segmentNamesArray" toObject:segmentsArrayController withKeyPath:@"arrangedObjects.name" options:nil];
	[pieChartView bind:@"segmentValuesArray" toObject:segmentsArrayController withKeyPath:@"arrangedObjects.amount" options:nil];
	[pieChartView bind:@"selectionIndexes" toObject:segmentsArrayController withKeyPath:@"selectionIndexes" options:nil];
	[segmentsArrayController bind:@"selectionIndexes" toObject:pieChartView withKeyPath:@"selectionIndexes" options:nil];
	[sliderRotationControl bind:@"value" toObject:pieChartView withKeyPath:@"rotationAmount" options:nil];
}

@end
