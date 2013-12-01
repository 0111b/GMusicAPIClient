//
//  PlaylistViewController.m
//  GMusicDemoiOS
//
//  Created by Alexandr Goncharov on 12/1/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "PlaylistViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <GMusicAPIClient.h>

@interface PlaylistViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *songListTable;
@property (weak, nonatomic) IBOutlet UILabel *currentTrackLabel;

@property (nonatomic, strong) NSArray *songList;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation PlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentTrackLabel.text = nil;
    
    self.player = [[AVPlayer alloc] init];
    self.player.allowsExternalPlayback = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshTouched:(id)sender {
    [[GMWebClient sharedInstance] allSongsWithCompletion:^(GMResult *result) {
        NSLog(@"get all %d count %d",result.status, [result.data count]);
        if ([result isValid]) {
            self.songList = result.data;
            [self.songListTable reloadData];
        }
    }];
}

- (void)playURL:(NSURL *)url {
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    [self.player play];
    NSLog(@"player status %d",self.player.status);
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    GMTrackInfo *track = self.songList[indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@ - %@",track.artist, track.title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)",track.year,track.album,track.genre];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath  animated:YES];
    GMTrackInfo *track = self.songList[indexPath.row];
    [[GMWebClient sharedInstance] streamURLForTrack:track
                                         completion:^(GMResult *result) {
                                             NSLog(@"stream %d data %@",result.status, result.data);
                                             if ([result isValid]) {
                                                 [self playURL:result.data];
                                                 self.currentTrackLabel.text = [NSString stringWithFormat:@"%@ - %@",track.artist,track.title];
                                             }
                                         }];
}

@end
