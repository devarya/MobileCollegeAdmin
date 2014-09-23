//
//  MCADBIntraction.h
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCADBIntraction : NSObject
@property (nonatomic,retain) NSString *databaseName;
+ (id)databaseInteractionManager;

#pragma mark - TASK_QUERY

-(void)insertTaskList:(NSMutableArray*)arr_taskList;
-(void)updateTaskList:(NSMutableArray*)arr_taskList;
-(void)deleteTaskList:(id)sender;
-(void)deleteTask:(NSMutableArray*)arr_task;
-(NSMutableArray*)retrieveTaskList:(id)sender;
-(NSMutableArray*)retrieveHighPriorityTaskList:(id)sender;
-(NSMutableArray*)retrieveRegularPriorityTaskList:(id)sender;
-(NSMutableArray*)retrieveTask:(id)sender;
-(NSMutableArray*)retrieveSelectedTask:(id)sender;

#pragma mark - STUDENT_QUERY

-(void)insertStudList:(NSMutableArray*)arr_studList;
-(NSMutableArray*)retrieveStudList:(id)sender;
-(void)deleteStudList:(id)sender;

#pragma mark - NOTES_QUERY

-(void)insertNotesCatList:(NSMutableArray*)arr_notesCatList;
-(NSMutableArray*)retrieveNotesCatList:(id)sender;
-(void)deleteNotesCatList:(id)sender;

#pragma mark - RESOURCE_QUERY
-(void)insertResourceCatList:(NSMutableArray*)arr_resourceList;
-(NSMutableArray*)retrieveResourceCatList:(id)sender;

@end
