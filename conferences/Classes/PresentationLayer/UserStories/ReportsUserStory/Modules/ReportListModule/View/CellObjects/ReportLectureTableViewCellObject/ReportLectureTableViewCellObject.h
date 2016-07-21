// Copyright (c) 2015 RAMBLER&Co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Nimbus/NimbusModels.h>

/**
 @author Zinovyev Konstantin
 
 Объект, представляющий LecturePlainObject для отображения.
 По этому объекту создается ReportLectureTableViewCell
 */
@class LecturePlainObject;

@interface ReportLectureTableViewCellObject : NSObject <NICellObject>

@property (strong, nonatomic, readonly) NSString *date;
@property (strong, nonatomic, readonly) NSAttributedString *lectureTitle;
@property (strong, nonatomic, readonly) UIImage *lectureImage;
@property (strong, nonatomic, readonly) LecturePlainObject *lecture;
@property (strong, nonatomic, readonly) NSString *speakerName;

+ (instancetype)objectWithLecture:(LecturePlainObject *)lecture selectedText:(NSString *)selectedText;

@end
