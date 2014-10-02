//
//  MCADBIntraction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADBIntraction.h"

MCADBIntraction *databaseManager = nil;
@implementation MCADBIntraction
@synthesize databaseName;
+ (id)databaseInteractionManager
{
    @synchronized(self)
    {
        if (databaseManager == nil)
        {
            databaseManager = [[self alloc] init];
        }
    }
    return databaseManager;
}
- (id)init
{
    if (self = [super init])
    {
        dBCollgeAdmin  = [[FMDatabase alloc] initWithPath:[self getDatabasePathFromName:@"MobileCollegeAdmin"]];
    }
    return self;
}
- (NSString *) getDatabasePathFromName:(NSString *)dbName
{
	return [self getDatabaseFolderPath:dbName];
}

-(NSString *) getDatabaseFolderPath : (NSString *)dbName
{
	databaseName = [dbName stringByAppendingString:@".sqlite"];
	NSString *databasePath = [[self getDocumentsDirectoryPath] stringByAppendingPathComponent:databaseName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:databasePath]) return databasePath;
	else
    {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
	return databasePath;
}

- (NSString *) getDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

#pragma mark - TASK_QUERY

-(void)insertTaskList:(NSMutableArray *)arr_taskList
{
    for (int i=0; i<arr_taskList.count;i++)
    {        
        MCATaskDetailDHolder *taskDHoler=[arr_taskList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"insert into tbl_tasklist(taskId,userId,taskNameEng,taskDetailEng,taskNameSp,taskDetailSp,taskPriority,taskStartDate,taskStatus,createdAt,createdBy,updatedAt,grade,status,network,nowDate,taskSnoozeDate) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",taskDHoler.str_taskId,taskDHoler.str_userId,taskDHoler.str_taskNameEng,taskDHoler.str_taskDetailEng,taskDHoler.str_taskNameSp,taskDHoler.str_taskDetailSp,taskDHoler.str_taskPriority,taskDHoler.str_taskStartDate,taskDHoler.str_taskStatus,taskDHoler.str_createdAt,taskDHoler.str_createdBy,taskDHoler.str_updatedAt,taskDHoler.str_grade,taskDHoler.str_status,taskDHoler.str_network,taskDHoler.str_nowDate,taskDHoler.str_taskStartDate];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully inserted");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}

-(NSMutableArray*)retrieveTaskList:(id)sender{
    
    NSMutableArray *arr_dbTaskList=[[NSMutableArray alloc]init];
    NSString *query;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
      query  = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskNameEng != \'%@\' order by taskStartDate",@""];
    }else{
        
       query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskNameSp != \'%@\' order by taskStartDate",@""];
    }
   
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTaskList addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTaskList;
}
-(NSMutableArray*)retrieveHighPriorityTaskList:(id)sender{
    
    NSMutableArray *arr_dbTaskList=[[NSMutableArray alloc]init];
    NSString *query;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
        query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskPriority = \'%@\' and taskNameEng != \'%@\' order by taskStartDate ",@"h",@""];
    }else{
        
        query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskPriority = \'%@\' and taskNameSp != \'%@\' order by taskStartDate ",@"h",@""];

    }
    
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTaskList addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTaskList;
}
-(NSMutableArray*)retrieveRegularPriorityTaskList:(id)sender{
    
    NSMutableArray *arr_dbTaskList=[[NSMutableArray alloc]init];
    NSString *query;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
        query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskPriority = \'%@\' and taskNameEng != \'%@\' order by taskStartDate ",@"r",@""];
    }else{
        
        query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskPriority = \'%@\' and taskNameSp != \'%@\' order by taskStartDate ",@"r",@""];
        
    }

    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTaskList addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTaskList;
}
-(NSMutableArray*)retrieveTask:(id)sender{
    
    NSMutableArray *arr_dbTask=[[NSMutableArray alloc]init];
    
    NSString *query= [NSString stringWithFormat:@"Select * from tbl_tasklist where network = \'%@\' order by taskStartDate",sender];
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTask addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTask;
}
-(NSMutableArray*)retrieveSelectedTask:(id)sender{
    
    NSMutableArray *arr_dbTask=[[NSMutableArray alloc]init];
    NSString *query;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
       query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskStartDate = \'%@\' and taskStatus = \'%@\' and taskNameEng != \'%@\'",sender,@"o",@""];
    }else{
        
       query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskStartDate = \'%@\' and taskStatus = \'%@\' and taskNameSp != \'%@\'",sender,@"o",@""];;
        
    }
    
//    NSString *query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskStartDate = \'%@\' and taskStatus = \'%@\' and taskNameEng != \'%@\'",sender,@"o",@""];
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder = [MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTask addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTask;
}

-(NSMutableArray*)retrieveTodayTask:(id)sender{
    
    NSMutableArray *arr_dbTask=[[NSMutableArray alloc]init];
    
    NSString *query= [NSString stringWithFormat:@"Select * from tbl_tasklist where taskSnoozeDate = \'%@\' and taskStatus = \'%@\'",sender,@"o"];
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder = [MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskSnoozeDate = [resultSet stringForColumn:@"taskSnoozeDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTask addObject:taskDHolder];
        }
        
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTask;
}
-(NSMutableArray*)retrieveSyncTaskList:(id)sender{
    
    NSMutableArray *arr_dbTaskList=[[NSMutableArray alloc]init];
    NSString *query;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
        query  = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskNameEng != \'%@\' and taskStatus = \'%@\' order by taskStartDate",@"",@"o"];
    }else{
        
        query = [NSString stringWithFormat:@"Select * from tbl_tasklist where taskNameSp != \'%@\'  and taskStatus = \'%@\' order by taskStartDate",@"",@"o"];
    }
    
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskNameEng = [resultSet stringForColumn:@"taskNameEng"];
            taskDHolder.str_taskDetailEng = [resultSet stringForColumn:@"taskDetailEng"];
            taskDHolder.str_taskNameSp = [resultSet stringForColumn:@"taskNameSp"];
            taskDHolder.str_taskDetailSp = [resultSet stringForColumn:@"taskDetailSp"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            taskDHolder.str_network = [resultSet stringForColumn:@"network"];
            
            [arr_dbTaskList addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTaskList;
    
}

-(void)updateTaskList:(NSMutableArray *)arr_taskList{
 
    for (int i=0; i<arr_taskList.count;i++)
    {
        MCATaskDetailDHolder *taskDHoler=[arr_taskList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"UPDATE tbl_tasklist SET taskId=\'%@\',userId =\'%@\',taskNameEng=\'%@\',taskDetailEng=\'%@\',taskNameSp=\'%@\',taskDetailSp=\'%@\',taskPriority=\'%@\',taskStartDate=\'%@\',taskStatus=\'%@\',createdAt=\'%@\',createdBy=\'%@\',updatedAt=\'%@\',grade=\'%@\',status=\'%@\',network=\'%@\',nowDate=\'%@\' where userId=\'%@\' and taskId=\'%@\'",taskDHoler.str_taskId,taskDHoler.str_userId,taskDHoler.str_taskNameEng,taskDHoler.str_taskDetailEng,taskDHoler.str_taskNameSp,taskDHoler.str_taskDetailSp,taskDHoler.str_taskPriority,taskDHoler.str_taskStartDate,taskDHoler.str_taskStatus,taskDHoler.str_createdAt,taskDHoler.str_createdBy,taskDHoler.str_updatedAt,taskDHoler.str_grade,taskDHoler.str_status,taskDHoler.str_network,taskDHoler.str_nowDate,taskDHoler.str_userId,taskDHoler.str_taskId];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully updated");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}
-(void)updateTaskSnoozeDate:(NSMutableArray*)arr_taskList{
    
    for (int i=0; i<arr_taskList.count;i++)
    {
        MCATaskDetailDHolder *taskDHoler=[arr_taskList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"UPDATE tbl_tasklist SET taskId=\'%@\',userId =\'%@\',taskNameEng=\'%@\',taskDetailEng=\'%@\',taskNameSp=\'%@\',taskDetailSp=\'%@\',taskPriority=\'%@\',taskStartDate=\'%@\',taskStatus=\'%@\',createdAt=\'%@\',createdBy=\'%@\',updatedAt=\'%@\',grade=\'%@\',status=\'%@\',network=\'%@\',nowDate=\'%@\',taskSnoozeDate=\'%@\' where userId=\'%@\' and taskId=\'%@\'",taskDHoler.str_taskId,taskDHoler.str_userId,taskDHoler.str_taskNameEng,taskDHoler.str_taskDetailEng,taskDHoler.str_taskNameSp,taskDHoler.str_taskDetailSp,taskDHoler.str_taskPriority,taskDHoler.str_taskStartDate,taskDHoler.str_taskStatus,taskDHoler.str_createdAt,taskDHoler.str_createdBy,taskDHoler.str_updatedAt,taskDHoler.str_grade,taskDHoler.str_status,taskDHoler.str_network,taskDHoler.str_nowDate,taskDHoler.str_taskSnoozeDate,taskDHoler.str_userId,taskDHoler.str_taskId];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully updated");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }

    
}
-(void)deleteTaskList:(id)sender{

    NSString *query=[NSString stringWithFormat:@"delete from tbl_tasklist"];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}
-(void)deleteTask:(NSMutableArray*)arr_task{
   
   for (int i=0; i<arr_task.count;i++)
   {
    MCATaskDetailDHolder *taskDHoler=[arr_task objectAtIndex:i];
    
    NSString *query=[NSString stringWithFormat:@"delete from tbl_tasklist where userId=\'%@\' and taskId=\'%@\'",taskDHoler.str_userId,taskDHoler.str_taskId];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
  }
}

#pragma mark - STUDENT QUERY

-(void)insertStudList:(NSMutableArray*)arr_studList{
    
    for (int i=0; i<arr_studList.count;i++)
    {
        MCASignUpDHolder *studDHoler = [arr_studList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"insert into tbl_studentlist(userId,userType,userName,signinId,language,zipcode,grade,family,notifyByPush,notifyByEmail) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",studDHoler.str_userId,studDHoler.str_userType,studDHoler.str_userName,studDHoler.str_signinId,studDHoler.str_lang,studDHoler.str_zipCode,studDHoler.str_grade,studDHoler.str_family,studDHoler.str_notifyByPush,studDHoler.str_notifyByMail];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully inserted");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}
-(NSMutableArray*)retrieveStudList:(id)sender{
    
    NSMutableArray *arr_dbStudList=[[NSMutableArray alloc]init];
    NSString *query=@"Select * from tbl_studentlist";
    
    @try
    {
        [dBCollgeAdmin open];
        
        FMResultSet *resultSet = [dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCASignUpDHolder *studDHolder=[MCASignUpDHolder new];
            studDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            studDHolder.str_userType = [resultSet stringForColumn:@"userType"];
            studDHolder.str_userName = [resultSet stringForColumn:@"userName"];
            studDHolder.str_signinId = [resultSet stringForColumn:@"signinId"];
            studDHolder.str_lang = [resultSet stringForColumn:@"language"];
            studDHolder.str_zipCode = [resultSet stringForColumn:@"zipcode"];
            studDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            studDHolder.str_family = [resultSet stringForColumn:@"family"];
            studDHolder.str_notifyByPush = [resultSet stringForColumn:@"notifyByPush"];
            studDHolder.str_notifyByMail = [resultSet stringForColumn:@"notifyByEmail"];
            
            [arr_dbStudList addObject:studDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbStudList;
}
-(void)deleteStudList:(id)sender{
    
    NSString *query=[NSString stringWithFormat:@"delete from tbl_studentlist"];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}

#pragma mark - NOTES_CATEGORY QUERY

-(void)insertNotesCatList:(NSMutableArray*)arr_notesCatList{
    
    for (int i=0; i<arr_notesCatList.count;i++)
    {
        MCANotesCatDHolder *notesDHolder=[arr_notesCatList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"insert into tbl_notesCatList(notesCatId,notesCatImage,notesCatName) values(\"%@\",\"%@\",\"%@\")",notesDHolder.str_notesCatId,notesDHolder.str_notesCatImage,notesDHolder.str_notesCatName];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully inserted");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}
-(NSMutableArray*)retrieveNotesCatList:(id)sender{
    
    NSMutableArray *arr_dbNotesCatList = [[NSMutableArray alloc]init];
    NSString *query = @"Select * from tbl_notesCatList";
    
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCANotesCatDHolder *notesDHolder=[MCANotesCatDHolder new];
            notesDHolder.str_notesCatId = [resultSet stringForColumn:@"notesCatId"];
            notesDHolder.str_notesCatImage = [resultSet stringForColumn:@"notesCatImage"];
            notesDHolder.str_notesCatName = [resultSet stringForColumn:@"notesCatName"];
            
            [arr_dbNotesCatList addObject:notesDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbNotesCatList;
}
-(void)deleteNotesCatList:(id)sender{
    
    NSString *query=[NSString stringWithFormat:@"delete from tbl_notesCatList"];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}

#pragma mark - RESOURCE_CATEGORY QUERY
-(void)insertResourceCatList:(NSMutableArray*)arr_resourceList{
    
    for (int i=0; i<arr_resourceList.count;i++)
    {
        MCAResourcesCatDHolder *reDHolder = [arr_resourceList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"insert into tbl_resource(reCatId,reCatImage,reCatName) values(\"%@\",\"%@\",\"%@\")",reDHolder.str_resourcesCatId, reDHolder.str_resourcesCatImage, reDHolder.str_resourcesCatName];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully inserted");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}
-(NSMutableArray*)retrieveResourceCatList:(id)sender{
    
    NSMutableArray *arr_dbResourceCatList = [[NSMutableArray alloc]init];
    NSString *query = @"Select * from tbl_resource";
    
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCAResourcesCatDHolder *reDHolder = [MCAResourcesCatDHolder new];
            reDHolder.str_resourcesCatId = [resultSet stringForColumn:@"reCatId"];
            reDHolder.str_resourcesCatImage = [resultSet stringForColumn:@"reCatImage"];
            reDHolder.str_resourcesCatName = [resultSet stringForColumn:@"reCatName"];
            [arr_dbResourceCatList addObject:reDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbResourceCatList;
}

@end
