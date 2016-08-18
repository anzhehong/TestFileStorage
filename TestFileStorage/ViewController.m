//
//  ViewController.m
//  TestFileStorage
//
//  Created by An, Fowafolo on 16/8/15.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testPath];
//    [self testPlistFile];
//    [self testPreference];
//    [self testWriteNSKeyedArchiver];
//    [self testReadNSKeyedArchiver];
//    [self initSQLiteDB];
//    [self SQLiteInsert];
//    [self readFromSQLiteWithCondition:@"of"];
    
//    [self initCoreData];
//    [self addCar];
//    [self findCar];
//    [self updateCar];
//    [self deleteCar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Different Paths
 *
 */
- (void)testPath {
    NSString *mainBundle = [[NSBundle mainBundle] bundlePath];
    NSLog(@"%@", mainBundle);
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@", documentPath);
    
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@", libraryPath);
    
    NSString *preferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@", preferencePath);
    
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"%@", tempPath);
}

/**
 *  Test PLIST File
 */
- (void)testPlistFile {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"123.plist"];
    
    NSDictionary *dict = @{@"first": @"Mike", @"second": @"Bob"};

    NSArray *array = @[@"123", @"456", @"789"];
    [array writeToFile:fileName atomically:YES];
    [dict writeToFile:fileName atomically:YES];

    
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:fileName];
    NSLog(@"%@", resultArr);
    
    NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSLog(@"%@", resultDic);
}

/**
 *  Test Preferences
 */
- (void)testPreference {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:YES forKey: @"isTurnedOn"];
    [userDefaults setInteger:121 forKey:@"testInt"];
    [userDefaults setObject:@"Fowafolo" forKey:@"God's Name"];
    
    [userDefaults synchronize];
    
    NSString *objectResult = [userDefaults objectForKey:@"God's Name"];
    BOOL boolResult = [userDefaults boolForKey:@"isTurnedOn"];
    NSInteger intResult = [userDefaults integerForKey:@"testInt"];
    NSLog(@"%@, %d, %ld", objectResult, boolResult, intResult);
}

/**
 *  Test NSKeyedArchiver
 */
- (void)testWriteNSKeyedArchiver {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"person.data"];
    Person *person = [[Person alloc]init];
    person.avator = [UIImage imageNamed:@"avator"];
    person.name = @"Fowafolo";
    person.age = 22;
    
    [NSKeyedArchiver archiveRootObject:person toFile:file];
}

- (void)testReadNSKeyedArchiver {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"person.data"];
    
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (person) {
        NSLog(@"%@, %@, %ld", person.name, person.avator, (long)person.age);
    }
}

/**
 *  Test SQLite3
 */
static sqlite3 *_db;

- (void)initSQLiteDB {
    //1. set the file name
    NSString *fileName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"person.db"];
    
    //2. open the database
    const char *cfilename = fileName.UTF8String;
    // 1.打开数据库（如果数据库文件不存在，sqlite3_open函数会自动创建数据库文件）
    int result = sqlite3_open(cfilename, &_db);
    if (result == SQLITE_OK) { // 打开成功
        NSLog(@"成功打开数据库");
        
        // 2.创表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);";
        char *erroMsg = NULL;
        result = sqlite3_exec(_db, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败--%s", erroMsg);
        }
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (void)SQLiteInsert {
    Person * person = [[Person alloc]init];
    person.name = @"Fowafolo";
    person.age = 20;
    person.avator = [UIImage imageNamed:@"avator"];
    
    //1. set sql
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person(name, age) VALUES ('%@', %ld)", person.name, (long)person.age];
    
    //2. execute sql
    char *errorMsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (errorMsg) {
        NSLog(@"插入数据失败--%s", errorMsg);
    } else {
        NSLog(@"成功插入数据");
    }
}

- (void)readAllFromSQLite {
    
}

- (void)readFromSQLiteWithCondition: (NSString*)condition {
    NSMutableArray *persons = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT id, name, age FROM t_person WHERE name like '%%%@%%' ORDER BY age ASC;", condition];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) { // SQL语句没有问题
        NSLog(@"查询语句没有问题");
        
        // 创建数组
        persons = [NSMutableArray array];
        
        // 每调一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 找到一条记录
            // 取出数据
            
            // 取出第0列字段的值（int类型的值）
            int ID = sqlite3_column_int(stmt, 0);
            
            // 取出第1列字段的值（tex类型的值）
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            
            // 取出第2列字段的值（int类型的值）
            int age = sqlite3_column_int(stmt, 2);
            
            // 创建JPPerson对象
            Person *p = [[Person alloc] init];
            
            p.name = [NSString stringWithUTF8String:(const char *)name];
            p.age = age;
            [persons addObject:p];
        }
        NSLog(@"%@", persons);
    } else {
        NSLog(@"查询语句有问题");
    }
}

/**
 *  Test Core Data
 */

- (void)initCoreData {
    //1.初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    //2.添加持久化存储
    //2.1模型文件 描述表结构的文件 也就是(Company.xcdatamodeld)这个文件
    #warning 补充 ,如bundles传nil 会从主bundle加载所有的模型文件,把里面表结构都放在一个数据库文件
    NSManagedObjectModel *carModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //2.2持久化存储调用器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:carModel];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //数据库的完整文件路径
    NSString *sqlitePath = [doc stringByAppendingString:@"car.sqlite"];
    
    //保存一个sqite文件的话,必要知道表结构和sqlite的文件路径
    //2.3 告诉coredate数据存储在一个sqlite文件
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    context.persistentStoreCoordinator = store;
    _context = context;
}

- (void)addCar {
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:_context];
    car.name = @"奔驰";
    car.price = @(200000);
    car.createdDate = [NSDate date];
    
    //保存
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@", error);
    }else {
        NSLog(@"成功保存一条数据");
    }
}

- (void)findCar {
    //查找数据
    //1.创建请求对象,指定要查找的表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    
    //2.时间排序
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES]; //升序
    request.sortDescriptors = @[dateSort];
    
    //3.过滤条件
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@", @"宝马"];
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name LIKE[c] '*宝*'"]; //注:[c]不区分大小写 , [d]不区分发音符号即没有重音符号 , [cd]既不区分大小写，也不区分发音符号。
//    NSString *attributeValue = @"宝";
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", attributeValue];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like[c] %@", @"*宝*"];
    

    request.predicate = pre;
    
    //分页查询
//    request.fetchOffset = 5;
//    request.fetchLimit = 5;
    
    //4.执行请求
    NSError *error = nil;
    NSArray *allCars =  [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    for (Car *car in allCars) {
        NSLog(@"%@ , %@, %@", car.name, car.price, car.createdDate);
    }
}

- (void)updateCar {
    //查找数据
    //1.创建请求对象,指定要查找的表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    
    NSString *attributeValue = @"宝";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", attributeValue];
    request.predicate = pre;
    
    //2.执行
    NSArray *allBMW = [_context executeFetchRequest:request error:nil];
    NSLog(@"%@", allBMW);
    for (Car *car in allBMW) {
        car.name = @"大宝马";
    }
    
    //3.保存
    [_context save:nil];
}

- (void)deleteCar {
    //查找数据
    //1.创建请求对象,指定要查找的表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    NSString *attributeValue = @"奔";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", attributeValue];
    request.predicate = pre;
    
    //2.执行
    NSArray *allBenz = [_context executeFetchRequest:request error:nil];
    for (Car *car in allBenz) {
        [_context deleteObject:car];
    }
}

@end
