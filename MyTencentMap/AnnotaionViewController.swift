//
//  AnnotaionViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/3.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class AnnotaionViewController: UIViewController ,UISearchBarDelegate ,QMapViewDelegate ,QMSSearchDelegate ,UITableViewDelegate,UITableViewDataSource{

    deinit {
        print("AnnotaionViewController------>释放")
    }
    
    var mapView: QMapView! //地图
    
    var mapSearcher: QMSSearcher! //搜索
    
    var annotations = [QPointAnnotation]()
    
    var myTabView: UITableView!
    
    var myProvince = "北京市" //省
    var myCity = "北京市" //市
    var myDistrict = "海淀区" //区
    
    var myAnnotation = QPointAnnotation()
    
    var SLECTDATA: AnyObject!
    
    var myPoiSearchData = [QMSPoiData]() //周边搜索结果
    var mapDetailView: MapDetailView? //详细视图
    
    //搜索bar
    var searchBar: UISearchBar!
    var searchBgView: UIView!
    
    
    var myLocation2D: CLLocationCoordinate2D!
    
    //搜索后的结果集
    var searchArray = [QMSSuggestionPoiData](){
        didSet  {
            if self.myTabView != nil {
                self.myTabView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "标注"
        self.view.backgroundColor = UIColor.yellow
        
        self.loadMapView()
        
        self.loadSearchBar()
        
        
        
    }
    //MARK:tabView
    func loadMyTabView(){
        if myTabView == nil {
            
            myTabView = UITableView(frame: CGRect(x: 0, y: 44, width: SCREENSIZE.width, height: SCREENSIZE.height - 64 - 44), style: .plain)
            
            myTabView.delegate = self
            myTabView.dataSource = self
            
            self.view.addSubview(myTabView)
            
        }else{
            myTabView.isHidden = false
        }
        
        
        
        
    }
    
    
    //MARK:mapView
    func loadMapView(){
        let rect = CGRect(x: 0, y: 44, width: SCREENSIZE.width, height: SCREENSIZE.height - 64 - 44)
        mapView = QMapView(frame: rect)
        
        mapView.zoomLevel = 13
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true //是否显示用户位置, 默认为NO
        mapView.hideAccuracyCircle = false //是否隐藏定位精度圈. 默认为NO.
        mapView.distanceFilter = 1
        
        mapView.userTrackingMode = QMUserTrackingModeNone
        
        
        self.view.insertSubview(mapView, at: 0)
        

        //搜索
        self.mapSearcher = QMSSearcher(delegate: self)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mapView.viewDidDisappear()
        
    }
    
    //MARK:表格UITableViewDelegate
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
    
    fileprivate var isTabViewSlect = false //搜索的方式
    
    fileprivate var secPoiData: QMSSuggestionPoiData!
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.searchBar.resignFirstResponder()
        self.myTabView.isHidden = true
        self.searchBar.showsCancelButton = false
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations.removeAll()
        
        let qmsSuggestionPoiData = self.searchArray[indexPath.row]
        
        self.secPoiData = qmsSuggestionPoiData
        
        self.SLECTDATA = qmsSuggestionPoiData as AnyObject!

        let title: String = qmsSuggestionPoiData.title
 
        let location = qmsSuggestionPoiData.location
        
        let address: String = qmsSuggestionPoiData.address
        //添加我的位置
        self.annotations.append(self.myAnnotation)
        
        let annotation = QPointAnnotation()
  
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = address

        self.annotations.append(annotation)

        self.mapView.addAnnotations(self.annotations)
        
        self.mapView.centerCoordinate = location
        
    }
    
    //MARK:地理位置反编码
    func searchAddressToLoction(cllocation2D: CLLocationCoordinate2D){
        
        let regeocoder = QMSReverseGeoCodeSearchOption()
        regeocoder.setLocationWithCenter(cllocation2D)
        regeocoder.get_poi = true
        self.mapSearcher.search(with: regeocoder)
        
    }
    //MARK:逆地理解析(坐标位置描述)结果回调接口
    func search(with reverseGeoCodeSearchOption: QMSReverseGeoCodeSearchOption!, didReceive reverseGeoCodeSearchResult: QMSReverseGeoCodeSearchResult!) {
        let a = reverseGeoCodeSearchResult.ad_info as QMSReGeoCodeAdInfo
        
        print(a)
        
        let city: String = a.city
        self.myCity = city
        
        self.myProvince = a.province
        
        self.myDistrict = a.district
        
        print(self.myCity,self.myProvince,self.myDistrict)
        
    }
    
    
    
    
    //MARK:QMapDelegate
    func mapView(_ mapView: QMapView!, didUpdate userLocation: QUserLocation!) {
        self.myLocation2D = userLocation.location
        

        
//        self.mapView.centerCoordinate = self.myLocation2D
        
        print(self.myLocation2D)
        
        myAnnotation.coordinate = self.myLocation2D
        myAnnotation.title = "我的位置"
        
        self.annotations.append(myAnnotation)
        
        self.mapView.addAnnotations(self.annotations)
        
        self.searchAddressToLoction(cllocation2D: self.myLocation2D)
    }
    
    
    
    
    func mapView(_ mapView: QMapView!, didSelect view: QAnnotationView!) {
        
        
        
        let q: CLLocationCoordinate2D = view.annotation.coordinate

        print(q)
        print("点击了标注")

        
        if self.mapDetailView == nil {
            
            if self.SLECTDATA != nil{
                
                let h: CGFloat = 135
                
                let rect = CGRect(x: 0, y: SCREENSIZE.height - h - 64, width: SCREENSIZE.width, height: h)
                self.mapDetailView = MapDetailView(frame: rect, myCllocation2D: self.myLocation2D, poiSearchData: self.SLECTDATA, target: self)
                
                self.view.addSubview(self.mapDetailView!)
            }

        }else{
            self.mapDetailView?.setData(self.myLocation2D, poiSearchData: self.SLECTDATA)
        }
    
        
        
    }
    
    //标注详细
    func mapView(_ mapView: QMapView!, viewFor annotation: QAnnotation!) -> QAnnotationView! {

        let annotationViewIdentifier = "pointvView"
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? QPinAnnotationView
        
        if view == nil {
            view = QPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
        }
        
        view?.canShowCallout = true
        
//        view?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        
        return view
        
        
        
        /*
        if let tmpAnnotation = annotation as? QPointAnnotation {
            
            let annotationViewIdentifier = "pointvView"
            
            let customAnnotationViewItentifier = "custView"
            
            if tmpAnnotation != self.annotations[0] {
                
 
                
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? QPinAnnotationView
                
                if view == nil {
                    view = QPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
                }
                
                view?.canShowCallout = true
                
                view?.rightCalloutAccessoryView = UIButton(type: .infoLight)
                
                return view

                
            }else{
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewItentifier)
                
                if annotationView == nil {
                    annotationView = QAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewItentifier)
                    
                    let img = Bundle.main.path(forResource: "tencent", ofType: "png")
                    
                    annotationView?.image = UIImage(contentsOfFile: img!)
                    
                    annotationView?.canShowCallout = true
                    
                }
                
                return annotationView
                
            }
            
        }else{
            return nil
        }
        */
  
 
    }
    
    
    func CalloutBtnAct(){
        print(".....")
    }
    
    
    

    //MARK:searchBar
    func loadSearchBar(){
        
        searchBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: 44))
        searchBgView.backgroundColor = UIColor.white
        
        self.view.addSubview(searchBgView)
        
    
        
        let toLeft: CGFloat = 50
        
        self.searchBar = UISearchBar(frame: CGRect(x: toLeft, y: 0, width: SCREENSIZE.width - toLeft * 2, height: 44))
        
        self.searchBar.placeholder = "search start"
        
        self.searchBar.searchBarStyle = .minimal
        
        self.searchBar.barTintColor = UIColor.red
        
        self.searchBar.isTranslucent = true
        
        self.searchBar.delegate = self

        self.searchBar.setValue("取消", forKey: "_cancelButtonText")
        
        self.view.addSubview(self.searchBar)
        
    }
    
    //MARK:searchDelegat
    //开始编辑
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        
        if self.myLocation2D != nil{
            
            self.mapView.centerCoordinate = self.myLocation2D
        }
        
        self.loadMyTabView()
        
    }
    //取消
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
        searchBar.resignFirstResponder()
        
        searchBar.text = nil
        
        self.myTabView.isHidden = true
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("编辑结束")
        
        searchBar.showsCancelButton = false
        
        self.myTabView.isHidden = true
        
        return true
    }
    
    //搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("搜索->\(searchBar.text!)")
        
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    
        
        self.searchByKeyword(keyword: searchBar.text!, isTabViewSec: false)
    }
    
    //搜索周边
    
    func searchByKeyword(keyword: String,isTabViewSec: Bool){
        
        self.isTabViewSlect = isTabViewSec
        
        let poiSearchOption = QMSPoiSearchOption()
        
        
        poiSearchOption.keyword = keyword

        poiSearchOption.page_size = 100
        
        
        poiSearchOption.setBoundaryByRegionWithCityName(self.myCity, autoExtend: false)
        
  
        if self.myLocation2D == nil {
            self.myLocation2D = CLLocationCoordinate2D(latitude: 39.975163349020647, longitude: 116.33943066000938)
        }
        
        
        poiSearchOption.setBoundaryByNearbyWithCenter(self.myLocation2D, radius: 3000)
        
        
        self.mapSearcher.search(with: poiSearchOption)
        
    }
    
    
    
    
    
    
    //MARK:实时云检索 输入框内容改变触发事件
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("输入框内容改变触发事件->\(searchText)")
        
        let suggetionOption = QMSSuggestionSearchOption()
        
        suggetionOption.keyword = searchText
        
        suggetionOption.region = self.myCity
        if !searchText.isEmpty {
            self.mapSearcher.search(with: suggetionOption)
        }
        
        
    }
    
    
    //MARK:QMSSearchDelegate
    func search(with searchOption: QMSSearchOption!, didFailWithError error: Error!) {
        print("错误->\(error)")
    }
    
    
    //云检索回调
    func search(with suggestionSearchOption: QMSSuggestionSearchOption!, didReceive suggestionSearchResult: QMSSuggestionResult!) {

        self.searchArray = suggestionSearchResult.dataArray as! [QMSSuggestionPoiData]
        
        print("self.searchArray->\(self.searchArray)")
        
    }
    
    
    func search(with poiSearchOption: QMSPoiSearchOption!, didReceive poiSearchResult: QMSPoiSearchResult!) {
        
        
        self.setupAnnotations(poiSearchResult)
    }
    //MARK:周边搜索回调结果
    func setupAnnotations(_ poiSearchResult: QMSPoiSearchResult){
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations.removeAll()
        
        
        let pois: [QMSPoiData] = poiSearchResult.dataArray as! [QMSPoiData]
        
        print("结果：->\(pois)")
        
        self.myPoiSearchData = pois
        
        self.SLECTDATA = pois as AnyObject!
        
        
        let poiSearchVC = PoiSearchResultViewController(location2D: self.myLocation2D, qmsPoiData: pois, poiSelectClourse: self.poiSelectResultClourse)
        
        self.navigationController?.pushViewController(poiSearchVC, animated: true)
 
 
    }
    //MARK: 回调---->
    func poiSelectResultClourse(_ poiData: QMSPoiData)->Void{
        print("回调---->\(poiData)")
        
        self.SLECTDATA = poiData
        
        
        let title: String = poiData.title
        
        let location = poiData.location
        
        let address: String = poiData.address
        //添加我的位置
        self.annotations.append(self.myAnnotation)
        
        let annotation = QPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = address
        
        self.annotations.append(annotation)
        
        self.mapView.addAnnotations(self.annotations)
        
        self.mapView.centerCoordinate = location
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
