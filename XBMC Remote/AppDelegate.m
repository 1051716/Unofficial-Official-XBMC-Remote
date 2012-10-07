//
//  AppDelegate.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 23/3/12.
//  Copyright (c) 2012 joethefox inc. All rights reserved.
//

#import "AppDelegate.h"
#import "mainMenu.h"
#import "MasterViewController.h"
#import "ViewControllerIPad.h"
#import "SDImageCache.h"
#import "GlobalData.h"
#import <arpa/inet.h>
#import "CustomNavigationController.h"


@implementation AppDelegate

NSMutableArray *mainMenuItems;

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize windowController = _windowController;
@synthesize dataFilePath;
@synthesize arrayServerList;
@synthesize fileManager;
@synthesize documentsDir;
@synthesize serverOnLine;
@synthesize serverVersion;
@synthesize obj;
@synthesize playlistArtistAlbums;
@synthesize playlistMovies;
@synthesize playlistTvShows;

+ (AppDelegate *) instance {
	return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark init

- (id) init {
	if ((self = [super init])) {
        self.fileManager = [NSFileManager defaultManager];
        NSArray *pathslocal = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        self.documentsDir = [pathslocal objectAtIndex:0];	
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"serverList_saved.dat"];
        [self setDataFilePath:path];
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        if([fileManager1 fileExistsAtPath:dataFilePath]) {
            NSMutableArray *tempArray;
            tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath];
            [self setArrayServerList:tempArray];
        } else {
            arrayServerList = [[NSMutableArray alloc] init];
        }
    }
	return self;
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL clearCache=[[userDefaults objectForKey:@"clearcache_preference"] boolValue];
    if (clearCache==YES){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }    
	[userDefaults removeObjectForKey:@"clearcache_preference"];
    
    UIApplication *xbmcRemote = [UIApplication sharedApplication];
    if ([[userDefaults objectForKey:@"lockscreen_preference"] boolValue]==YES){
        xbmcRemote.idleTimerDisabled = YES;
    }
    else {
        xbmcRemote.idleTimerDisabled = NO;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    int thumbWidth;
    int tvshowHeight;
    NSString *filemodeRowHeight= @"35";
    NSString *filemodeThumbWidth= @"35";
    obj=[GlobalData getInstance];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        thumbWidth = 320;
        tvshowHeight = 61;        
    } 
    else {
        thumbWidth = 477;
        tvshowHeight = 91;
    }

    [self.window makeKeyAndVisible];
    
    mainMenuItems = [NSMutableArray arrayWithCapacity:1];
    mainMenu *item1 = [[mainMenu alloc] init];
    mainMenu *item2 = [[mainMenu alloc] init];
    mainMenu *item3 = [[mainMenu alloc] init];
    mainMenu *item4 = [[mainMenu alloc] init];
    mainMenu *item5 = [[mainMenu alloc] init];
    mainMenu *item6 = [[mainMenu alloc] init];
    
    item1.subItem = [[mainMenu alloc] init];
    item1.subItem.subItem = [[mainMenu alloc] init];

    item2.subItem = [[mainMenu alloc] init];
    item2.subItem.subItem = [[mainMenu alloc] init];

    item3.subItem = [[mainMenu alloc] init];
    item3.subItem.subItem = [[mainMenu alloc] init];

    item4.subItem = [[mainMenu alloc] init];
    item4.subItem.subItem = [[mainMenu alloc] init];

#pragma mark - Music
    item1.mainLabel = @"Music";
    item1.upperLabel = @"Listen to";
    item1.icon = @"icon_home_music.png";
    item1.family = 1;
    item1.enableSection=YES;
    item1.mainButtons=[NSArray arrayWithObjects:@"st_album", @"st_artist", @"st_genre", @"st_filemode", @"st_album_recently", @"st_songs_recently", @"st_song", @"st_song", @"st_song", @"st_song", @"st_song", @"st_song",  nil];//, @"st_album_recently", @"st_songs_recently"
    
    item1.mainMethod=[NSMutableArray arrayWithObjects:
                      
                      [NSArray arrayWithObjects:
                       @"AudioLibrary.GetAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method",
                       nil],
                      
                      [NSArray arrayWithObjects:@"AudioLibrary.GetArtists", @"method",
                       @"AudioLibrary.GetArtistDetails", @"extra_info_method",
                       nil],
                      
                      [NSArray arrayWithObjects:@"AudioLibrary.GetGenres", @"method", nil],
                      
                      [NSArray arrayWithObjects:@"Files.GetSources", @"method", nil],
                      
                      [NSArray arrayWithObjects:
                       @"AudioLibrary.GetRecentlyAddedAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method",
                       nil],
                      
                      [NSArray arrayWithObjects:@"AudioLibrary.GetRecentlyAddedSongs", @"method", nil],
                      
                      [NSArray arrayWithObjects:
                       @"AudioLibrary.GetAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method",
                       nil],
                      
                      [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],

                      [NSArray arrayWithObjects:@"AudioLibrary.GetRecentlyPlayedAlbums", @"method", nil],

                      [NSArray arrayWithObjects:@"AudioLibrary.GetRecentlyPlayedSongs", @"method", nil],
                      
                      [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                      
                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],

                      nil];
    item1.mainParameters=[NSArray arrayWithObjects:
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  nil], @"properties",
                            nil],  @"parameters", @"Albums", @"label", @"Album", @"wikitype",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart",
                             nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects: @"thumbnail", @"genre", nil], @"properties",
                            nil], @"parameters", @"Artists", @"label", @"nocover_artist.png", @"defaultThumb", @"Artist", @"wikitype", [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects: @"thumbnail", @"genre", @"instrument", @"style", @"mood", @"born", @"formed", @"description", @"died", @"disbanded", @"yearsactive", @"fanart",
                             nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                       
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects: @"thumbnail", nil], @"properties",
                            nil], @"parameters", @"Genres", @"label", @"nocover_genre.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"music", @"media",
                            nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  nil], @"properties",
                            nil],  @"parameters", @"Added albums", @"label", @"Album", @"wikitype", @"Recently added albums", @"morelabel",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart",
                             nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
//                            [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithInt:0], @"start",
//                             [NSNumber numberWithInt:99], @"end",
//                             nil], @"limits",
                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                            nil], @"parameters", @"Added songs", @"label", @"Recently added songs", @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"descending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"playcount", @"method",
                             nil],@"sort",
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:0], @"start",
                             [NSNumber numberWithInt:100], @"end",
                             nil], @"limits",
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  @"playcount", nil], @"properties",
                            nil],  @"parameters", @"Top 100 Albums", @"label", @"Album", @"wikitype", @"Top 100 Albums", @"morelabel",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart",
                             nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"descending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"playcount", @"method",
                             nil],@"sort",
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:0], @"start",
                             [NSNumber numberWithInt:100], @"end",
                             nil], @"limits",
                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                            nil], @"parameters", @"Top 100 Songs", @"label", @"Top 100 Songs", @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  nil], @"properties",//@"genre", @"description", @"albumlabel", @"fanart",
                            nil], @"parameters", @"Played albums", @"label", @"Album", @"wikitype", @"Recently played albums", @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil], @"sort",
//                            [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithInt:0], @"start",
//                             [NSNumber numberWithInt:99], @"end",
//                             nil], @"limits",
                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                            nil], @"parameters", @"Played songs", @"label", @"Recently played songs", @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                            nil], @"parameters", @"All songs", @"label", @"All songs", @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"music", @"media",
                            @"addons://sources/audio", @"directory",
                            [NSArray arrayWithObjects:@"thumbnail", @"file", nil], @"properties",
                            nil], @"parameters", @"Music Addons", @"label", @"Music Addons", @"morelabel", @"nocover_filemode.png", @"defaultThumb", @"53", @"rowHeight", @"53", @"thumbWidth", nil],
                          nil];
    
    item1.mainFields=[NSArray arrayWithObjects:
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"albums",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"fanart", @"row4",
                       @"rating",@"row5",
                       @"albumid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"albumid",@"row8",
                       @"albumid", @"row9",
                       @"artist", @"row10",
                       @"genre",@"row11",
                       @"description",@"row12",
                       @"albumlabel",@"row13",
                       @"albumdetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"artists",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"yearsactive", @"row3",
                       @"genre", @"row4",
                       @"disbanded",@"row5",
                       @"artistid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"artistid",@"row8",
                       @"artistid", @"row9",
                       @"formed", @"row10",
                       @"artistid",@"row11",
                       @"description",@"row12",
                       @"instrument",@"row13",
                       @"style", @"row14",
                       @"mood", @"row15",
                       @"born", @"row16",
                       @"formed", @"row17",
                       @"died", @"row18",
                       @"artistdetails",@"itemid_extra_info",
//@"", @"", @"", @"", @"", , @"", @"", , @"", @"", @"",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"genres",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"genreid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"genreid",@"row8",
                       @"genreid", @"row9",
                       nil],
  
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"sources",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"albums",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"fanart", @"row4",
                       @"rating",@"row5",
                       @"albumid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"albumid",@"row8",
                       @"albumid", @"row9",
                       @"artist", @"row10",
                       @"genre",@"row11",
                       @"description",@"row12",
                       @"albumlabel",@"row13",
                       @"albumdetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"songs",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"duration", @"row4",
                       @"rating",@"row5",
                       @"songid",@"row6",
                       @"track",@"row7",
                       @"songid",@"row8",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"songid", @"row9",
                       @"file", @"row10",
                       @"artist", @"row11",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"albums",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"fanart", @"row4",
                       @"rating",@"row5",
                       @"albumid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"albumid",@"row8",
                       @"albumid", @"row9",
                       @"artist", @"row10",
                       @"genre",@"row11",
                       @"description",@"row12",
                       @"albumlabel",@"row13",
                       @"playcount",@"row14",
                       @"albumdetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"songs",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"duration", @"row4",
                       @"rating",@"row5",
                       @"songid",@"row6",
                       @"track",@"row7",
                       @"songid",@"row8",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"songid", @"row9",
                       @"file", @"row10",
                       @"artist", @"row11",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"albums",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"fanart", @"row4",
                       @"rating",@"row5",
                       @"albumid",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"albumid",@"row8",
                       @"albumid", @"row9",
                       @"artist", @"row10",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"songs",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"duration", @"row4",
                       @"rating",@"row5",
                       @"songid",@"row6",
                       @"track",@"row7",
                       @"songid",@"row8",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"songid", @"row9",
                       @"file", @"row10",
                       @"artist", @"row11",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"songs",@"itemid",
                       @"label", @"row1",
                       @"artist", @"row2",
                       @"year", @"row3",
                       @"duration", @"row4",
                       @"rating",@"row5",
                       @"songid",@"row6",
                       @"track",@"row7",
                       @"songid",@"row8",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"songid", @"row9",
                       @"file", @"row10",
                       @"artist", @"row11",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"files",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      nil];
    item1.rowHeight=53;
    item1.thumbWidth=53;
    item1.defaultThumb=@"nocover_music.png";
    
    item1.sheetActions=[NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play",  @"Album Details", @"Search Wikipedia", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play",  @"Artist Details", @"Search Wikipedia", @"Search last.fm charts", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                        [NSArray arrayWithObjects:nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Album Details", @"Search Wikipedia", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play",  @"Album Details", @"Search Wikipedia", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Album Details", @"Search Wikipedia", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                        [NSArray arrayWithObjects: nil],
                        nil];//@"View Details",

    item1.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                              
                              [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                              
                              [NSArray arrayWithObjects:
                               @"AudioLibrary.GetAlbums", @"method",
                               @"AudioLibrary.GetAlbumDetails", @"extra_info_method",
                               nil],
                              
                              [NSArray arrayWithObjects:
                               @"AudioLibrary.GetAlbums", @"method",
                               @"AudioLibrary.GetAlbumDetails", @"extra_info_method",
                               nil],
                              
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              
                              [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                              
                              [NSArray arrayWithObjects:nil],

                              [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              
                              nil]; 
    item1.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"track", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"year", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  nil], @"properties",
                                    nil],  @"parameters", @"Albums", @"label", @"Album", @"wikitype",
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart",
                                     nil], @"properties",
                                    nil], @"extra_info_parameters",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"year", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist",  nil], @"properties",
                                    nil],  @"parameters", @"Albums", @"label", @"Album", @"wikitype",
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSArray arrayWithObjects:@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart",
                                     nil], @"properties",
                                    nil], @"extra_info_parameters",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"label", @"method",
                                     nil],@"sort",
                                    @"music", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"track", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  [NSArray arrayWithObjects:nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"track", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  [NSArray arrayWithObjects:nil],

                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"track", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  [NSArray arrayWithObjects:nil],
                                  
                                  [NSArray arrayWithObjects:nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"none", @"method",
                                     nil],@"sort",
                                    [NSArray arrayWithObjects:@"thumbnail", nil], @"file_properties",
                                    @"music", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", @"35", @"rowHeight", @"35", @"thumbWidth", nil],
                                  
                                  nil];
    item1.subItem.mainFields=[NSArray arrayWithObjects:
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"songs",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"duration", @"row4",
                               @"rating",@"row5",
                               @"songid",@"row6",
                               @"track",@"row7",
                               @"albumid",@"row8",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"songid", @"row9",
                               @"file", @"row10",
                               @"artist", @"row11",
                               nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"albums",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"fanart", @"row4",
                               @"rating",@"row5",
                               @"albumid",@"row6",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"albumid",@"row8",
                               @"albumid", @"row9",
                               @"artist", @"row10",
                               @"genre",@"row11",
                               @"description",@"row12",
                               @"albumlabel",@"row13",
                               @"albumdetails",@"itemid_extra_info",
                               nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"albums",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"fanart", @"row4",
                               @"rating",@"row5",
                               @"albumid",@"row6",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"albumid",@"row8",
                               @"albumid", @"row9",
                               @"artist", @"row10",
                               @"genre",@"row11",
                               @"description",@"row12",
                               @"albumlabel",@"row13",
                               @"albumdetails",@"itemid_extra_info",
                               nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"songs",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"duration", @"row4",
                               @"rating",@"row5",
                               @"songid",@"row6",
                               @"track",@"row7",
                               @"albumid",@"row8",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"songid", @"row9",
                               @"file", @"row10",
                               @"artist", @"row11",
                               nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"songs",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"duration", @"row4",
                               @"rating",@"row5",
                               @"songid",@"row6",
                               @"track",@"row7",
                               @"albumid",@"row8",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"songid", @"row9",
                               @"file", @"row10",
                               @"artist", @"row11",
                               nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"songs",@"itemid",
                               @"label", @"row1",
                               @"artist", @"row2",
                               @"year", @"row3",
                               @"duration", @"row4",
                               @"rating",@"row5",
                               @"songid",@"row6",
                               @"track",@"row7",
                               @"albumid",@"row8",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"songid", @"row9",
                               @"file", @"row10",
                               @"artist", @"row11",
                               nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSArray arrayWithObjects:nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:0], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              
                              nil];
    item1.subItem.enableSection=NO;
    item1.subItem.rowHeight=53;
    item1.subItem.thumbWidth=53;
    item1.subItem.defaultThumb=@"nocover_music.png";
    item1.subItem.sheetActions=[NSArray arrayWithObjects:
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil], //@"Stream to iPhone",
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", @"Album Details", @"Search Wikipedia", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", @"Album Details", @"Search Wikipedia", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],

                                nil];//, @"Stream to iPhone"
    item1.subItem.originYearDuration=248;
    item1.subItem.widthLabel=252;
    item1.subItem.showRuntime=[NSArray arrayWithObjects:
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:NO], 
                               [NSNumber numberWithBool:NO], 
                               [NSNumber numberWithBool:YES], 
                               [NSNumber numberWithBool:YES], 
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:YES], 
                               [NSNumber numberWithBool:YES],
                               [NSNumber numberWithBool:YES],
                               nil];
    
    item1.subItem.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                                      
                                      [NSArray arrayWithObjects:@"AudioLibrary.GetSongs", @"method", nil],
                                      
                                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                      nil];
    
    item1.subItem.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSMutableArray arrayWithObjects:
                                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"ascending",@"order",
                                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                             @"track", @"method",
                                             nil],@"sort",
                                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                            nil], @"parameters", @"Songs", @"label", nil], 
                                          
                                          [NSMutableArray arrayWithObjects:
                                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"ascending",@"order",
                                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                             @"track", @"method",
                                             nil],@"sort",
                                            [NSArray arrayWithObjects:@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file", nil], @"properties",
                                            nil], @"parameters", @"Songs", @"label", nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],

                                          nil];
    item1.subItem.subItem.mainFields=[NSArray arrayWithObjects:
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSDictionary  dictionaryWithObjectsAndKeys:
                                       @"songs",@"itemid",
                                       @"label", @"row1",
                                       @"artist", @"row2",
                                       @"year", @"row3",
                                       @"duration", @"row4",
                                       @"rating",@"row5",
                                       @"songid",@"row6",
                                       @"track",@"row7",
                                       @"albumid",@"row8",
                                       [NSNumber numberWithInt:0], @"playlistid",
                                       @"songid", @"row9",
                                       @"file", @"row10",
                                       @"artist", @"row11",
                                       nil],
                                      
                                      [NSDictionary  dictionaryWithObjectsAndKeys:
                                       @"songs",@"itemid",
                                       @"label", @"row1",
                                       @"artist", @"row2",
                                       @"year", @"row3",
                                       @"duration", @"row4",
                                       @"rating",@"row5",
                                       @"songid",@"row6",
                                       @"track",@"row7",
                                       @"albumid",@"row8",
                                       [NSNumber numberWithInt:0], @"playlistid",
                                       @"songid", @"row9",
                                       @"file", @"row10",
                                       @"artist", @"row11",
                                       nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      [NSArray arrayWithObjects:nil],
                                      
                                      nil];
    item1.subItem.subItem.rowHeight=53;
    item1.subItem.subItem.thumbWidth=53;
    item1.subItem.subItem.defaultThumb=@"nocover_music.png";
    item1.subItem.subItem.sheetActions=[NSArray arrayWithObjects:
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],//@"Stream to iPhone",
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        nil];
    item1.subItem.subItem.showRuntime=[NSArray arrayWithObjects:
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       [NSNumber numberWithBool:YES],
                                       nil];
#pragma mark - Movies
    item2.mainLabel = @"Movies";
    item2.upperLabel = @"Watch your";
    item2.icon = @"icon_home_movie.png";
    item2.family = 1;
    item2.enableSection=YES;
    item2.mainButtons=[NSArray arrayWithObjects:@"st_movie", @"st_concert", @"st_movie_recently", @"st_filemode", @"st_song", nil];//

    item2.mainMethod=[NSMutableArray arrayWithObjects:
                      [NSArray arrayWithObjects:
                       @"VideoLibrary.GetMovies", @"method", 
                       @"VideoLibrary.GetMovieDetails", @"extra_info_method", 
                       nil],
                      
                      [NSArray arrayWithObjects:@"VideoLibrary.GetMusicVideos", @"method", nil],
                      
                      [NSArray arrayWithObjects:
                       @"VideoLibrary.GetRecentlyAddedMovies", @"method", 
                       @"VideoLibrary.GetMovieDetails", @"extra_info_method", 
                       nil],
                      
                      [NSArray arrayWithObjects:@"Files.GetSources", @"method", nil],
                      
                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                      
                      nil];
    
    item2.mainParameters=[NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", nil], @"properties",
                            nil], @"parameters", @"Movies", @"label", @"Movie", @"wikitype", 
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil], //@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime" //-> should be not retrieved again
                          
                          [NSMutableArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"playcount", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"file", @"fanart", @"resume", nil], @"properties",
                            nil], @"parameters", @"Music Videos", @"label", @"Movie", @"wikitype", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", nil], @"properties",
                            nil], @"parameters", @"Added Movies", @"label", @"Movie", @"wikitype", 
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"video", @"media",
                            nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"video", @"media",
                            @"addons://sources/video", @"directory",
                            [NSArray arrayWithObjects:@"thumbnail", nil], @"properties",
                            nil], @"parameters", @"Video Addons", @"label", @"Video Addons", @"morelabel", @"nocover_filemode.png", @"defaultThumb", @"53", @"rowHeight", @"53", @"thumbWidth", nil],
                          
                          nil];
    
    item2.mainFields=[NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"movies",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"movieid",@"row6",
                       [NSNumber numberWithInt:1], @"playlistid",
                       @"movieid",@"row8",
                       @"movieid", @"row9",
                       @"playcount",@"row10",
                       @"studio",@"row11",
                       @"plot",@"row12",
                       @"mpaa",@"row13",
                       @"votes",@"row14",
                       @"votes",@"row15",
                       @"cast",@"row16",
                       @"fanart",@"row7",
                       @"director",@"row17",
                       @"resume", @"row18",
                       @"moviedetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"musicvideos",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"musicvideoid",@"row6",
                       [NSNumber numberWithInt:1], @"playlistid",
                       @"musicvideoid",@"row8",
                       @"musicvideoid", @"row9",
                       @"director",@"row10",
                       @"studio",@"row11",
                       @"plot",@"row12",
                       @"playcount",@"row13",
                       @"resume",@"row14",
                       @"votes",@"row15",
                       @"cast",@"row16",
                       @"file",@"row17",
                       @"fanart",@"row7",
                       nil],
                      
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"movies",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"movieid",@"row6",
                       [NSNumber numberWithInt:1], @"playlistid",
                       @"movieid",@"row8",
                       @"movieid", @"row9",
                       @"playcount",@"row10",
                       @"studio",@"row11",
                       @"plot",@"row12",
                       @"mpaa",@"row13",
                       @"votes",@"row14",
                       @"votes",@"row15",
                       @"cast",@"row16",
                       @"fanart",@"row7",
                       @"director",@"row17",
                       @"resume", @"row18",
                       @"moviedetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"sources",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:1], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"files",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      nil];
    item2.rowHeight=76;
    item2.thumbWidth=53;
    item2.defaultThumb=@"nocover_movies.png";
    item2.sheetActions=[NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Movie Details", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Music Video Details", nil],
                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Movie Details", nil],
                        [NSArray arrayWithObjects: nil],
                        [NSArray arrayWithObjects: nil],
                        nil];
//    item2.showInfo = YES;
    item2.showInfo = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil];
    item2.watchModes = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:@"all", @"unwatched", @"watched", nil], @"modes", 
                         [NSArray arrayWithObjects:@"", @"icon_not_watched", @"icon_watched", nil], @"icons", 
                         nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:@"all", @"unwatched", @"watched", nil], @"modes", 
                         [NSArray arrayWithObjects:@"", @"icon_not_watched", @"icon_watched", nil], @"icons", 
                         nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:@"all", @"unwatched", @"watched", nil], @"modes",
                         [NSArray arrayWithObjects:@"", @"icon_not_watched", @"icon_watched", nil], @"icons", 
                         nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:nil], @"modes", 
                         [NSArray arrayWithObjects:nil], @"icons", 
                         nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:nil], @"modes",
                         [NSArray arrayWithObjects:nil], @"icons",
                         nil],
                        nil];
    
    item2.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                              [NSArray arrayWithObjects: nil],
                              [NSArray arrayWithObjects: nil],
                              [NSArray arrayWithObjects: nil],
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              nil]; 
    item2.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                  [NSArray arrayWithObjects: nil],
                                  [NSArray arrayWithObjects: nil],  
                                  [NSArray arrayWithObjects: nil],                                
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"label", @"method",
                                     nil],@"sort",
                                    @"video", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"none", @"method",
                                     nil],@"sort",
                                    @"video", @"media",
                                    [NSArray arrayWithObjects:@"thumbnail", nil], @"file_properties",
                                    nil], @"parameters", @"Video Addons", @"label", @"nocover_filemode.png", @"defaultThumb", @"35", @"rowHeight", @"35", @"thumbWidth", nil],
                                  nil];
    item2.subItem.mainFields=[NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjectsAndKeys: nil],
                              [NSDictionary dictionaryWithObjectsAndKeys: nil],
                              [NSDictionary dictionaryWithObjectsAndKeys: nil],
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:1], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:1], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              nil];
    item2.subItem.enableSection = NO;
    item2.subItem.rowHeight = 76;
    item2.subItem.thumbWidth = 53;
    item2.subItem.defaultThumb = @"nocover_filemode.png";
    item2.subItem.sheetActions = [NSArray arrayWithObjects:
                                [NSArray arrayWithObjects: nil],
                                [NSArray arrayWithObjects: nil],
                                [NSArray arrayWithObjects: nil],
                                [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                nil];
    item2.subItem.widthLabel = 252;
    
    item2.subItem.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                                        [NSArray arrayWithObjects: nil],
                                        [NSArray arrayWithObjects: nil],
                                        [NSArray arrayWithObjects: nil],
                                        [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                        [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                        nil];
    item2.subItem.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                            [NSArray arrayWithObjects: nil],
                                            [NSArray arrayWithObjects: nil],
                                            [NSArray arrayWithObjects: nil],
                                            [NSArray arrayWithObjects: nil],
                                            [NSMutableArray arrayWithObjects:@"35", @"rowHeight", @"35", @"thumbWidth", nil],
                                            nil];
    item2.subItem.subItem.mainFields = [NSArray arrayWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys: nil],
                                        [NSDictionary dictionaryWithObjectsAndKeys: nil],
                                        [NSDictionary dictionaryWithObjectsAndKeys: nil],
                                        [NSDictionary dictionaryWithObjectsAndKeys: nil],
                                        [NSDictionary dictionaryWithObjectsAndKeys: nil],
                                      nil];
    item2.subItem.subItem.enableSection = NO;
    item2.subItem.subItem.rowHeight = 76;
    item2.subItem.subItem.thumbWidth = 53;
    item2.subItem.subItem.defaultThumb = @"nocover_filemode.png";
    item2.subItem.subItem.sheetActions = [NSArray arrayWithObjects:
                                          [NSArray arrayWithObjects: nil],
                                          [NSArray arrayWithObjects: nil],
                                          [NSArray arrayWithObjects: nil],
                                          [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                          [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                          nil];
    item2.subItem.subItem.widthLabel = 252;

#pragma mark - TV Shows
    item3.mainLabel = @"TV Shows";
    item3.upperLabel = @"Watch your";
    item3.icon = @"icon_home_tv.png";
    item3.family = 1;
    item3.enableSection=YES;
    item3.mainButtons=[NSArray arrayWithObjects:@"st_tv", @"st_tv_recently", @"st_filemode", nil];//, @"st_actor", @"st_genre"

    item3.mainMethod=[NSMutableArray arrayWithObjects:
                      [NSArray arrayWithObjects:
                       @"VideoLibrary.GetTVShows", @"method", 
                       @"VideoLibrary.GetTVShowDetails", @"extra_info_method",
                       nil],
                      
                      [NSArray arrayWithObjects:@"VideoLibrary.GetRecentlyAddedEpisodes", @"method", nil],

                      [NSArray arrayWithObjects:@"Files.GetSources", @"method", nil],

                      nil];
    item3.mainParameters=[NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio", nil], @"properties",
                            nil], @"parameters", @"TV Shows", @"label", @"TV Show", @"wikitype",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio", @"plot", @"mpaa", @"votes", @"cast", @"premiered", @"episode", @"fanart", nil], @"properties",
                            nil], @"extra_info_parameters",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"none", @"method",
                             nil],@"sort",
                            [NSArray arrayWithObjects:@"episode", @"thumbnail", @"firstaired", @"runtime", @"plot", @"director", @"writer", @"rating", @"showtitle", @"season", @"cast", @"file", @"fanart", @"playcount", @"resume", nil], @"properties",
                            nil], @"parameters", @"Added Episodes", @"label", @"53", @"rowHeight", @"95", @"thumbWidth", nil],
                                                    
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"video", @"media",
                            nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          nil];
    item3.mainFields=[NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"tvshows",@"itemid",
                       @"label", @"row1",
                       @"genre", @"row2",
                       @"blank", @"row3",
                       @"studio", @"row4",
                       @"rating",@"row5",
                       @"tvshowid",@"row6",
                       [NSNumber numberWithInt:2], @"playlistid",
                       @"tvshowid",@"row8",
                       @"playcount",@"row9",
                       @"mpaa",@"row10",
                       @"votes",@"row11",
                       @"cast",@"row12",
                       @"premiered",@"row13",
                       @"episode",@"row14",
                       @"fanart",@"row7",
                       @"plot",@"row15",
                       @"studio",@"row16",
                       @"tvshowdetails",@"itemid_extra_info",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"episodes",@"itemid",
                       @"label", @"row1",
                       @"showtitle", @"row2",
                       @"firstaired", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"episodeid",@"row6",
                       @"season",@"row7",
                       @"episodeid",@"row8",
                       [NSNumber numberWithInt:1], @"playlistid",
                       @"episodeid", @"row9",
                       @"plot", @"row10",
                       @"director", @"row11",
                       @"writer", @"row12",
                       @"resume", @"row13",
                       @"showtitle", @"row14",
                       @"season",@"row15",
                       @"cast",@"row16",
                       @"firstaired",@"row17",
                       @"playcount",@"row18",
                       @"fanart",@"row7",
                       nil],
                                            
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"sources",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      nil];
    item3.rowHeight=tvshowHeight;
    item3.thumbWidth=thumbWidth;
    item3.defaultThumb=@"nocover_tvshows.png";
    item3.originLabel=60;
    item3.sheetActions=[NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"TV Show Details", nil],
                        [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", @"Episode Details", nil],
                        [NSArray arrayWithObjects:nil],
                        nil];
    
    item3.showInfo = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], nil];
    item3.watchModes = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:@"all", @"unwatched", @"watched", nil], @"modes", 
                         [NSArray arrayWithObjects:@"", @"icon_not_watched", @"icon_watched", nil], @"icons", 
                         nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:@"all", @"unwatched", @"watched", nil], @"modes", 
                         [NSArray arrayWithObjects:@"", @"icon_not_watched", @"icon_watched", nil], @"icons", 
                         nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:nil], @"modes", 
                         [NSArray arrayWithObjects:nil], @"icons", 
                         nil],
                        nil];
    
    item3.subItem.disableFilterParameter = YES;
    item3.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                              [NSArray arrayWithObjects:@"VideoLibrary.GetSeasons", @"method", nil],
                              [NSArray arrayWithObjects:nil],
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              nil]; 
    item3.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"label", @"method",
                                     nil],@"sort",
                                    
                                    [NSArray arrayWithObjects:@"season", @"thumbnail", @"tvshowid", @"playcount", @"episode", nil], @"properties",
                                    nil], @"parameters", @"Seasons", @"label",
                                   nil],
                                  
                                  [NSArray arrayWithObjects:nil],
                                                                    
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"label", @"method",
                                     nil],@"sort",
                                    @"video", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  nil];
    item3.subItem.mainFields=[NSArray arrayWithObjects:
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"seasons",@"itemid",
                               @"label", @"row1",
                               @"blank", @"row2",
                               @"blank", @"row3",
                               @"blank", @"row4",
                               @"blank",@"row5",
                               @"tvshowid",@"row6",
                               @"episode",@"row7",
                               @"season",@"row8",
                               [NSNumber numberWithInt:1], @"playlistid",
                               @"tvshowid", @"row9",
                               @"playcount", @"row10",
                               @"season",@"row15",
                               nil],
                              
                              [NSArray arrayWithObjects:nil],
                                                            
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:1], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              nil];
    item3.subItem.enableSection=NO;
    item3.subItem.rowHeight=114;
    item3.subItem.thumbWidth=79;
    item3.subItem.defaultThumb=@"nocover_tvshows_episode.png";
    item3.subItem.sheetActions=[NSArray arrayWithObjects:
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                [NSArray arrayWithObjects:nil],
                                [NSArray arrayWithObjects:@"Queue after current",  @"Queue", @"Play", nil],
                                nil];//, @"Stream to iPhone"

    item3.subItem.widthLabel=252;

//    item3.subItem.sheetActions=[NSArray arrayWithObjects:@"Queue", @"Play", nil];
    item3.subItem.subItem.disableFilterParameter = YES;
    item3.subItem.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                                      [NSArray arrayWithObjects:
                                       @"VideoLibrary.GetEpisodes", @"method",
                                       @"VideoLibrary.GetEpisodeDetails", @"extra_info_method",
                                       nil],
                                      [NSArray arrayWithObjects:nil],
                                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                      
                                      nil]; 
    item3.subItem.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                          [NSMutableArray arrayWithObjects:
                                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"ascending",@"order",
                                             @"episode", @"method",
                                             nil],@"sort",
                                            [NSArray arrayWithObjects:@"episode", @"thumbnail", @"firstaired", @"showtitle", @"playcount", nil], @"properties",
                                            nil], @"parameters", @"Episodes", @"label",
                                           [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSArray arrayWithObjects:@"episode", @"thumbnail", @"firstaired", @"runtime", @"plot", @"director", @"writer", @"rating", @"showtitle", @"season", @"cast", @"file", @"fanart", @"resume", nil], @"properties",nil], @"extra_info_parameters",
                                           nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          nil];
    item3.subItem.subItem.mainFields=[NSArray arrayWithObjects:
                                      [NSDictionary  dictionaryWithObjectsAndKeys:
                                       @"episodes",@"itemid",
                                       @"label", @"row1",
                                       @"showtitle", @"row2",
                                       @"firstaired", @"row3",
                                       @"runtime", @"row4",
                                       @"rating",@"row5",
                                       @"episodeid",@"row6",
                                       @"playcount",@"row7",
                                       @"episodeid",@"row8",
                                       [NSNumber numberWithInt:1], @"playlistid",
                                       @"episodeid", @"row9",
                                       @"plot", @"row10",
                                       @"director", @"row11",
                                       @"writer", @"row12",
                                       @"firstaired", @"row13",
                                       @"showtitle", @"row14",
                                       @"season",@"row15",
                                       @"cast",@"row16",
                                       @"file",@"row17",
                                       @"resume",@"row18",
                                       @"episodedetails",@"itemid_extra_info",
                                       nil],
                                      
                                      [NSArray arrayWithObjects:nil],

                                      [NSArray arrayWithObjects:nil],
                                      
                                      nil];
    item3.subItem.subItem.enableSection=NO;
    item3.subItem.subItem.rowHeight=53;
    item3.subItem.subItem.thumbWidth=95;
    item3.subItem.subItem.defaultThumb=@"nocover_tvshows_episode.png";
    item3.subItem.subItem.sheetActions=[NSArray arrayWithObjects:
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", @"Episode Details", nil],
                                        [NSArray arrayWithObjects:nil],
                                        [NSArray arrayWithObjects:@"Queue after current", @"Queue", @"Play", nil],
                                        nil];
    item3.subItem.subItem.originYearDuration=248;
    item3.subItem.subItem.widthLabel=208;
    item3.subItem.subItem.showRuntime=[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    item3.subItem.subItem.noConvertTime=YES;
    item3.subItem.subItem.showInfo = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil];

#pragma mark - Pictures
    item4.mainLabel = @"Pictures";
    item4.upperLabel = @"Browse your";
    item4.icon = @"icon_home_picture.png";
    item4.family = 1;
    item4.enableSection=YES;
    item4.mainButtons=[NSArray arrayWithObjects:@"st_filemode", @"st_filemode", nil];//, @"st_actor", @"st_genre"
    
    item4.mainMethod=[NSMutableArray arrayWithObjects:
                      
                      [NSArray arrayWithObjects:@"Files.GetSources", @"method", nil],
                      
                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                      
                      nil];
    
    item4.mainParameters=[NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"pictures", @"media",
                            nil], @"parameters", @"Pictures", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"ascending",@"order",
                             [NSNumber numberWithBool:FALSE],@"ignorearticle",
                             @"label", @"method",
                             nil],@"sort",
                            @"pictures", @"media",
                            @"addons://sources/image", @"directory",
                            [NSArray arrayWithObjects:@"thumbnail", nil], @"properties",
                            nil], @"parameters", @"Pictures Addons", @"label", @"Pictures Addons", @"morelabel", @"nocover_filemode.png", @"defaultThumb", @"53", @"rowHeight", @"53", @"thumbWidth", nil],
                          
                          nil];
    item4.mainFields=[NSArray arrayWithObjects:
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"sources",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:2], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      [NSDictionary  dictionaryWithObjectsAndKeys:
                       @"files",@"itemid",
                       @"label", @"row1",
                       @"year", @"row2",
                       @"year", @"row3",
                       @"runtime", @"row4",
                       @"rating",@"row5",
                       @"file",@"row6",
                       [NSNumber numberWithInt:0], @"playlistid",
                       @"file",@"row8",
                       @"file", @"row9",
                       nil],
                      
                      nil];
    
    item4.thumbWidth=53;
    item4.defaultThumb=@"jewel_dvd.table.png";
    
    item4.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                              
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              
                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              
                              nil];
    
    item4.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"label", @"method",
                                     nil],@"sort",
                                    @"pictures", @"media",
                                    [NSArray arrayWithObjects:@"thumbnail", nil], @"file_properties",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ascending",@"order",
                                     [NSNumber numberWithBool:FALSE],@"ignorearticle",
                                     @"none", @"method",
                                     nil],@"sort",
                                    @"video", @"media",
                                    [NSArray arrayWithObjects:@"thumbnail", nil], @"file_properties",
                                    nil], @"parameters", @"Video Addons", @"label", @"nocover_filemode.png", @"defaultThumb", @"35", @"rowHeight", @"35", @"thumbWidth", nil],
                                  
                                  nil];
    item4.subItem.mainFields=[NSArray arrayWithObjects:
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:2], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
                              
                              [NSDictionary  dictionaryWithObjectsAndKeys:
                               @"files",@"itemid",
                               @"label", @"row1",
                               @"filetype", @"row2",
                               @"filetype", @"row3",
                               @"filetype", @"row4",
                               @"filetype",@"row5",
                               @"file",@"row6",
                               [NSNumber numberWithInt:1], @"playlistid",
                               @"file",@"row8",
                               @"file", @"row9",
                               @"filetype", @"row10",
                               @"type", @"row11",
                               nil],
            
                              nil];
    
    item4.subItem.enableSection=NO;
    item4.subItem.rowHeight=76;
    item4.subItem.thumbWidth=53;
    item4.subItem.defaultThumb=@"nocover_tvshows_episode.png";
    
    
    item4.subItem.subItem.mainMethod=[NSMutableArray arrayWithObjects:
                                      
                                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                      
                                      [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                                      
                                      nil];
    
    item4.subItem.subItem.mainParameters=[NSMutableArray arrayWithObjects:
                                                                                    
                                          [NSArray arrayWithObjects:nil],
                                          
                                          [NSArray arrayWithObjects:nil],
                                          
                                          nil];
    
    item4.subItem.subItem.mainFields=[NSArray arrayWithObjects:
                                      
                                      [NSArray arrayWithObjects:nil],

                                      [NSArray arrayWithObjects:nil],
                                      
                                      nil];
        
#pragma mark - Now Playing
    item5.mainLabel = @"Now playing";
    item5.upperLabel = @"See what's";
    item5.icon = @"icon_home_playing.png";
    item5.family = 2;

#pragma mark - Remote Control
    item6.mainLabel = @"Remote Control";
    item6.upperLabel = @"Use as";
    item6.icon = @"icon_home_remote.png";
    item6.family = 3;

    playlistArtistAlbums = [item1 copy];
    playlistArtistAlbums.subItem.disableNowPlaying = TRUE;
    playlistArtistAlbums.subItem.subItem.disableNowPlaying = TRUE;
    
    playlistMovies = [item2 copy];
    playlistMovies.subItem.disableNowPlaying = TRUE;
    playlistMovies.subItem.subItem.disableNowPlaying = TRUE;

    playlistTvShows = [item3 copy];
    playlistTvShows.subItem.disableNowPlaying = TRUE;
    playlistTvShows.subItem.subItem.disableNowPlaying = TRUE;
    
    MasterViewController *masterViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [mainMenuItems addObject:item1];
        [mainMenuItems addObject:item2];
        [mainMenuItems addObject:item3];
        [mainMenuItems addObject:item4];
        [mainMenuItems addObject:item5];
        [mainMenuItems addObject:item6];
        masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        self.navigationController = [[CustomNavigationController alloc] initWithRootViewController:masterViewController];
        masterViewController.mainMenu =mainMenuItems;
        self.window.rootViewController = self.navigationController;
    } else {
        [mainMenuItems addObject:item1];
        [mainMenuItems addObject:item2];
        [mainMenuItems addObject:item3];
        [mainMenuItems addObject:item4];
        [mainMenuItems addObject:item6];
        self.windowController = [[ViewControllerIPad alloc] initWithNibName:@"ViewControllerIPad" bundle:nil];
        self.windowController.mainMenu = mainMenuItems;
        self.window.rootViewController = self.windowController;
    }
    return YES;
}

-(void)wake:(NSString *)macAddress{
    Wake_on_LAN("255.255.255.255", [macAddress UTF8String]);
}

int Wake_on_LAN(char *ip_broadcast,const char *wake_mac){
	int i,sockfd,an=1;
	char *x;
	char mac[102];
	char macpart[2];
	char test[103];
	
	struct sockaddr_in serverAddress;
	
	if ( (sockfd = socket( AF_INET, SOCK_DGRAM,17)) < 0 ) {
		return 1;
	}
	
	setsockopt(sockfd,SOL_SOCKET,SO_BROADCAST,&an,sizeof(an));
	
	bzero( &serverAddress, sizeof(serverAddress) );
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons( 9 );
	
	inet_pton( AF_INET, ip_broadcast, &serverAddress.sin_addr );
	
	for (i=0;i<6;i++) mac[i]=255;
	for (i=1;i<17;i++) {
		macpart[0]=wake_mac[0];
		macpart[1]=wake_mac[1];
		mac[6*i]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[3];
		macpart[1]=wake_mac[4];
		mac[6*i+1]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[6];
		macpart[1]=wake_mac[7];
		mac[6*i+2]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[9];
		macpart[1]=wake_mac[10];
		mac[6*i+3]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[12];
		macpart[1]=wake_mac[13];
		mac[6*i+4]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[15];
		macpart[1]=wake_mac[16];
		mac[6*i+5]=strtol(macpart,&x,16);
	}
	for (i=0;i<103;i++) test[i]=mac[i];
	test[102]=0;
	
	sendto(sockfd,&mac,102,0,(struct sockaddr *)&serverAddress,sizeof(serverAddress));
	close(sockfd);
	
	return 0;
}


- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];

    UIApplication *xbmcRemote = [UIApplication sharedApplication];
    if ([[userDefaults objectForKey:@"lockscreen_preference"] boolValue]==YES ){
        xbmcRemote.idleTimerDisabled = YES;
    }
    else {
        xbmcRemote.idleTimerDisabled = NO;

    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationWillEnterForegroundNotification" object: nil]; 
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(event.type == UIEventSubtypeMotionShake){
        [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationShakeNotification" object: nil]; 
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)saveServerList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) { 
        NSString  *dicPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"serverList_saved.dat"];
        [NSKeyedArchiver archiveRootObject:arrayServerList toFile:dicPath];
    }
}
@end
