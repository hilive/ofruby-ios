#include "SelectViewController.h"

#include "EditViewController.h"
#include "FCFileManager.h"
#include "ScriptApp.h"
#include "ScriptController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // NavButton
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(tapAddButton)];
    self.navigationItem.rightBarButtonItem = addButton;

    // TableView
    mDataSource = [self updateDataSourceFromFiles];
}

- (void)tapAddButton
{
    UIAlertView* alert = [[UIAlertView alloc] init];
    alert.title = @"New File";
    //alert.message = @"Enter file name.";
    alert.delegate = self;
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.cancelButtonIndex = 0;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSString* text = [[alertView textFieldAtIndex:0] text];

        // Remove a directory path and Add the ".rb" extension.
        text = [[[text lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@".rb"];

        //  File name is illegal
        if ([text isEqualToString:@".rb"]) {
            UIAlertView* alert = [[UIAlertView alloc] init];
            alert.title = @"Invalid file name";
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            return;
        }

        // Create path
        NSString* path = [FCFileManager pathForDocumentsDirectoryWithPath:text];

        // Alert if file already exists
        if ([FCFileManager existsItemAtPath:path]) {
            UIAlertView* alert = [[UIAlertView alloc] init];
            alert.title = @"Already exists";
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            return;
        }

        // Create a new file
        [FCFileManager createFileAtPath:path
                            withContent:@"def setup\n"
                                         "end\n"
                                         "\n"
                                         "def update\n"
                                         "end\n"
                                         "\n"
                                         "def draw\n"
                                         "  # set_color 204, 52, 45\n"
                                         "  rect 120, 220, 80, 40\n"
                                         "end\n"
            ];

        // Update data source
        mDataSource = [self updateDataSourceFromFiles];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [mDataSource objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* tableCellName = [mDataSource objectAtIndex:indexPath.row];
    NSString* path = [FCFileManager pathForDocumentsDirectoryWithPath:tableCellName];
    EditViewController* viewController = [[EditViewController alloc] initWithFileName:path];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSMutableArray *) updateDataSourceFromFiles
{
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects: nil];

    NSString* path = [FCFileManager pathForDocumentsDirectory];
    NSArray*  files = [FCFileManager listFilesInDirectoryAtPath:path];

    for (NSString* str in files) {
        [array addObject:[str lastPathComponent]];
    }

    return array;
}

@end
