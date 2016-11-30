//
//  GeoAndSuggetionViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class GeoAndSuggetionViewController: UIViewController ,UISearchBarDelegate,UITableViewDelegate ,UITableViewDataSource ,UISearchResultsUpdating ,QMapViewDelegate,QMSSearchDelegate {

    
    var tabH: CGFloat = 44
    
    var tableView: UITableView!
    
    var countrySearchCtr = UISearchController()
    

    //搜索后的结果集
    var searchArray:[QMSSuggestionPoiData] = [QMSSuggestionPoiData](){
        didSet  {self.tableView.reloadData()}
    }
    
    
    //----地图
    var mapView: QMapView!
    var mapSearcher: QMSSearcher!
    var suggetionResult: QMSSuggestionResult!
    var geoResult: QMSGeoCodeSearchResult!
    
    
    deinit {
        print("???????????")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.view.backgroundColor = UIColor.white
        
        self.mapView = QMapView(frame: CGRect(x: 0, y: 64 + tabH, width: SCREENSIZE.width, height: SCREENSIZE.height - tabH - 64))
        
        self.mapView.zoomLevel = 13
        
        self.mapView.delegate = self
        
        
        
        self.mapView.showsCompass = true //是否显示指南针
        
        self.mapView.showsUserLocation = true //是否显示用户位置, 默认为NO
        self.mapView.hideAccuracyCircle = true //是否隐藏定位精度圈. 默认为NO.
        
        self.mapView.distanceFilter = 1 //设置更新位置的最小变化距离
        
        self.mapView.userTrackingMode = QMUserTrackingModeFollow
        
        self.view.insertSubview(self.mapView, at: 0)
        
        self.mapSearcher = QMSSearcher(delegate: self)
        
        self.loadSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.viewWillAppear()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mapView.viewDidDisappear()
        
        
    }
    
    func loadSearchBar(){
        let rect = CGRect(x: 0, y: 64, width: self.view.frame.width, height: tabH)
        
        self.tableView = UITableView(frame: rect, style: .plain)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.isScrollEnabled = false
        
        
        self.view.addSubview(self.tableView)
        
        
        //配置搜索控制器
        self.countrySearchCtr = ({
            
            let ctr = UISearchController(searchResultsController: nil)
            
            ctr.searchResultsUpdater = self
            
            ctr.hidesNavigationBarDuringPresentation = true
            
            ctr.dimsBackgroundDuringPresentation = false
            
            ctr.searchBar.searchBarStyle = .minimal
            
            ctr.searchBar.sizeToFit()
            
            ctr.searchBar.delegate = self
            ctr.searchBar.placeholder = "请输入地点或地址"
            
            ctr.searchBar.setValue("取消", forKey: "_cancelButtonText")
            
            self.tableView.tableHeaderView = ctr.searchBar
            
            return ctr
        })()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        
        self.tableView.isScrollEnabled = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: tabH)
        
        self.tableView.isScrollEnabled = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let value = searchBar.text!
        
        self.countrySearchCtr.isActive = false
        
        self.tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: tabH)
        
        self.tableView.isScrollEnabled = false
        
        searchBar.text = value
        
        
        self.searchByKeyword(keyword: value)
        
    }
    
    //搜索周边
    
    func searchByKeyword(keyword: String){
        
        let poiSearchOption = QMSPoiSearchOption()
        
        
        poiSearchOption.keyword = keyword
        
        poiSearchOption.setBoundaryByRegionWithCityName(self.city, autoExtend: false)
        
        
        if self.cllocation2D == nil {
            self.cllocation2D = CLLocationCoordinate2D(latitude: 39.975163349020647, longitude: 116.33943066000938)
        }
        
        
        poiSearchOption.setBoundaryByNearbyWithCenter(self.cllocation2D, radius: 10000)
        
        
        
        self.mapSearcher.search(with: poiSearchOption)
        
    }
    
    
    
    
    
    
    
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.searchArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identify)
            
        }
        
        
        if !self.searchArray.isEmpty {
            let title = self.searchArray[indexPath.row].title
            
            let address = self.searchArray[indexPath.row].address
            
            print(address!)
            
            cell?.textLabel?.text = title
            cell?.detailTextLabel?.text = address
        }
        return cell!
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        let value: String = self.searchArray[indexPath.row].title
        
        print(value)

        self.countrySearchCtr.searchBar.text = value

        
    }
    //MARK:UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {

        //实时搜索
        let searchStr = searchController.searchBar.text!
        
        print(searchStr)
        
        let suggetionOption = QMSSuggestionSearchOption()
        
        suggetionOption.keyword = searchStr
        
        suggetionOption.region = self.city
        
        if !searchStr.isEmpty {
            self.mapSearcher.search(with: suggetionOption)
        }
 
    }
    
    
    //MARK:QMapDelegate
    var cllocation2D: CLLocationCoordinate2D!
    var city: String = "北京市"
    
    
    func mapView(_ mapView: QMapView!, didUpdate userLocation: QUserLocation!) {
        
        let location = userLocation.location

        self.cllocation2D = location

        
        self.searchAddressToLoction(cllocation2D: location)
        
    }
    
    //地理位置反编码
    func searchAddressToLoction(cllocation2D: CLLocationCoordinate2D){
        
        let regeocoder = QMSReverseGeoCodeSearchOption()
        
        regeocoder.setLocationWithCenter(cllocation2D)
        
        regeocoder.get_poi = true
        

        self.mapSearcher.search(with: regeocoder)
        
    }
    //MARK:Map Delegate
    func mapView(_ mapView: QMapView!, viewFor overlay: QOverlay!) -> QOverlayView! {
        
        let polyline: QPolyline = overlay as! QPolyline
        
        let polylineView: QPolylineView = QPolylineView(polyline: polyline)
        polylineView.lineWidth = 3
        
        
        polylineView.strokeColor = UIColor(red: 0x55/255.0, green: 0x79/255.0, blue: 0xff/255.0, alpha: 1)
       
 
        
        return polylineView
    }
    
    
    
    
    //逆地理解析(坐标位置描述)结果回调接口
 
    
    func search(with reverseGeoCodeSearchOption: QMSReverseGeoCodeSearchOption!, didReceive reverseGeoCodeSearchResult: QMSReverseGeoCodeSearchResult!) {
        let a = reverseGeoCodeSearchResult.ad_info as QMSReGeoCodeAdInfo
        print(a)
        
        let city: String = a.city
        
        self.city = city
        
        print(city)
        
    }
    
    
    
    
    func mapView(_ mapView: QMapView!, viewFor annotation: QAnnotation!) -> QAnnotationView! {
        let reuseID = "ReuseId"
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? QPinAnnotationView
        
        if view == nil {
            view = QPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        
        view?.canShowCallout = true
        
        view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return view
        
    }
    
    //标注点击
    func mapView(_ mapView: QMapView!, annotationView view: QAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //        QMSBaseResult
        
        let poi: QAnnotation = view.annotation
        
        let a = poi.coordinate
        
        
        let walking = QMSWalkingRouteSearchOption()
        
        walking.setFrom(self.cllocation2D)
        walking.setTo(a)

        
        self.mapSearcher.search(with: walking)

        
    }
    
    
    var routePlanToDetail: QMSRoutePlan!
    
    //MARK:步行路径结果回调
    func search(with walkingRouteSearchOption: QMSWalkingRouteSearchOption!, didRecevieResult walkingRouteSearchResult: QMSWalkingRouteSearchResult!) {

        
        let walkingRoutePlan: QMSRoutePlan = (walkingRouteSearchResult.routes as! [QMSRoutePlan]).first!
        
//        print(walkingRoutePlan)

        //距离
        let text = MyService().humanReadableForDistance(distance: walkingRoutePlan.distance)
        print("text->\(text)")
        
        //时间
        let text1 = MyService().humanReadableForTimeDuration(timeDuration: walkingRoutePlan.duration)
        print("text1->\(text1)")
        
        //方向
        let route = "方向：\(walkingRoutePlan.direction)"
        print("方向:->\(route)")
        
        let steps = walkingRoutePlan.steps as! [QMSRouteStep]

        var instructionArray = [String]()
        for item in steps {
            let instruction: String = item.instruction
            instructionArray.append(instruction)
        }
        print(instructionArray)

        
  
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let count = walkingRoutePlan.polyline.count
        
        var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: count)
        
        
        
        for i in 0..<count {

            
            (walkingRoutePlan.polyline[i] as! NSValue).getValue(&coordinateArray[i])
 
        }
        
        print(coordinateArray)
        
   
        let walkPolyline: QPolyline = QPolyline(coordinates: &coordinateArray, count: UInt(count))
        
     
        
        
        walkPolyline.dash = true
        
        print(walkPolyline)
        
        
        self.mapView.add(walkPolyline)
        
        self.setMapRegionWithCoordinates(points: coordinateArray, count: count)
    }
    
    func setMapRegionWithCoordinates(points: [CLLocationCoordinate2D], count: Int){
        
        var east: CLLocationDegrees = points[0].longitude
        var west = east
        
        var north: CLLocationDegrees = points[0].latitude
        let south = north
        
        
        for i in 1..<count {
            
            if east < points[i].longitude {
                east = points[i].longitude
            }
            
            if west > points[i].longitude {
                west = points[i].longitude
            }
            if north < points[i].latitude {
                north = points[i].latitude
            }
            if north > points[i].latitude {
                north = points[i].latitude
            }
            
        }
        
        let region: QCoordinateRegion = QCoordinateRegionMake(CLLocationCoordinate2D(latitude: (north + south) / 2, longitude: (east + west) / 2), QCoordinateSpanMake(east - west, north - south))
        
        self.mapView.setVisibleMapRect(QMapRectForCoordinateRegion(region), edgePadding: UIEdgeInsetsMake(30, 30, 30, 30), animated: false)
        
    }
    
    
    
    
    
 
    
    
    var poiSearchResult: QMSPoiSearchResult!
    //MARK:QMSSearchDelegate
    
    func search(with searchOption: QMSSearchOption!, didFailWithError error: Error!) {
        print("错误->\(error)")
    }
    

    
    func search(with suggestionSearchOption: QMSSuggestionSearchOption!, didReceive suggestionSearchResult: QMSSuggestionResult!) {
        
        self.suggetionResult = suggestionSearchResult
        
        
        self.searchArray = suggestionSearchResult.dataArray as! [QMSSuggestionPoiData]
        
        print("self.searchArray->\(self.searchArray)")
        
        self.tableView.reloadData()
        
    }
    
    
    func search(with poiSearchOption: QMSPoiSearchOption!, didReceive poiSearchResult: QMSPoiSearchResult!) {
        self.poiSearchResult = poiSearchResult
        
        
        self.setupAnnotations()
    }
    
    
    func setupAnnotations(){
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if self.poiSearchResult != nil{
            
            let pois: [QMSPoiData] = self.poiSearchResult.dataArray as! [QMSPoiData]
            
            print(pois)
            var poiAnnotations = [QPointAnnotation]()
            
            
            
            for item in pois {
                
                let annotation = QPointAnnotation()
                
                let location = item.location
                let title = item.title
                
                annotation.coordinate = location
                annotation.title = title
                
                poiAnnotations.append(annotation)
            }
            
            self.mapView.addAnnotations(poiAnnotations)
            
            
        }
        
        
        
    }

}
