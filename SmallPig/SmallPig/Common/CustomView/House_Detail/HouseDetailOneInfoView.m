//
//  HouseDetailOneInfoView.m
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailOneInfoView.h"



@interface HouseDetailOneInfoView()<BMKMapViewDelegate>
{
    UILabel *detailLabel;
    BMKMapView *_mapView;
}
@property (nonatomic, strong) NSString *title;
@end

@implementation HouseDetailOneInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame viewType:(InfoViewType)type viewTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.title = title;
        [self createUIWithType:type];
    }
    return self;
}

- (void)createUIWithType:(InfoViewType)type
{
    [self addLabels];
    if (type == InfoViewTypeMap)
    {
        [self addMapView];
    }
}

- (void)addLabels
{
    UILabel *titleLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:self.title textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
    [self addSubview:titleLabel];
    
    float start_y = titleLabel.frame.origin.y + titleLabel.frame.size.height + SPACE_Y;
    detailLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, start_y, self.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:@"" textColor:HOUSE_DETAIL_TEXT_COLOR textFont:FONT(14.0)];
    [self addSubview:detailLabel];
}

- (void)addMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(SPACE_X, detailLabel.frame.origin.y + detailLabel.frame.size.height + SPACE_Y, self.frame.size.width - 2 * SPACE_X, MAPVIEW_HEIGHT)];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 15.0;
    _mapView.showsUserLocation = NO;
    [self addSubview:_mapView];
}


#pragma mark 设置数据
- (void)setDataWithDetailText:(NSString *)detailText
{
    detailLabel.text = detailText;
    [self resetFrame];
}

- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate  locationText:(NSString *)location
{
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = location;
    [_mapView addAnnotation:point];
    
    [_mapView setCenterCoordinate:coordinate animated:YES];
}


- (void)resetFrame
{
    float height = [CommonTool labelHeightWithTextLabel:detailLabel textFont:detailLabel.font];
    CGRect frame = detailLabel.frame;
    frame.size.height = height;
    detailLabel.frame = frame;
    
    CGRect selfFrame = self.frame;
    if (_mapView)
    {
        _mapView.frame = CGRectMake(SPACE_X, detailLabel.frame.origin.y + detailLabel.frame.size.height + SPACE_Y, self.frame.size.width - 2 * SPACE_X, MAPVIEW_HEIGHT);
        
        selfFrame.size.height = SPACE_Y * 3 + height + SPACE_Y + MAPVIEW_HEIGHT + LABEL_HEIGHT;
    }
    else
    {
        selfFrame.size.height = SPACE_Y * 3 + height + LABEL_HEIGHT;
    }
    self.frame = selfFrame;
}

#pragma mark mapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *pointView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"point"];
        if (!pointView)
        {
            pointView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"point"];
        }
        pointView.animatesDrop = NO;
        pointView.image = [UIImage imageNamed:@"pin.png"];
        pointView.canShowCallout = YES;
        return pointView;
    }
    return nil;
}



- (void)dealloc
{
    if (_mapView)
    {
        _mapView.delegate = nil;
        _mapView = nil;
    }
}

@end
