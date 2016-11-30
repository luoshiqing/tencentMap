//
//  MapTypeViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class MapTypeViewController: UIViewController ,QMapViewDelegate , QMSSearchDelegate,UITextFieldDelegate{

    fileprivate var mapView: QMapView!
    
    var mapSearcher: QMSSearcher!
    
    var poiSearchResult: QMSPoiSearchResult!
    
    fileprivate var satellite: UIButton!
    fileprivate var traffic: UIButton!
    
    fileprivate var searchFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map Type"
        self.view.backgroundColor = UIColor.white
        
        self.loadMapView()
        self.loadDown()
        
    }
    
    func loadMapView(){
        
        
        self.mapSearcher = QMSSearcher(delegate: self)
        
        
        self.mapView = QMapView(frame: CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height - 64))
        
        self.mapView.zoomLevel = 13
        
        self.mapView.delegate = self
        
        self.mapView.showsCompass = true //是否显示指南针
        
        
        self.mapView.showsUserLocation = true //是否显示用户位置, 默认为NO
        self.mapView.hideAccuracyCircle = true //是否隐藏定位精度圈. 默认为NO.
        
        self.mapView.distanceFilter = 1 //设置更新位置的最小变化距离
        
        self.mapView.userTrackingMode = QMUserTrackingModeFollow
        
        //        self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 39.920269, longitude: 116.390533)
        
        self.view.addSubview(self.mapView)
        
    }
    
    func loadDown(){
        
        let bgView = UIView(frame: CGRect(x: 0, y: SCREENSIZE.height - 44 - 64, width: SCREENSIZE.width, height: 44))
        bgView.backgroundColor = UIColor.yellow
        
        self.view.addSubview(bgView)
        
        self.satellite = UIButton(frame: CGRect(x: 30, y: (44 - 30) / 2, width: 70, height: 30))
        self.satellite.backgroundColor = UIColor.gray
        
        self.satellite.setTitle("卫星底图", for: UIControlState())
        self.satellite.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.satellite.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        self.satellite.tag = 1
        
        self.satellite.layer.cornerRadius = 4
        self.satellite.layer.masksToBounds = true
        
        bgView.addSubview(self.satellite)
        
        
        self.traffic = UIButton(frame: CGRect(x: SCREENSIZE.width - 30 - 70, y: (44 - 30) / 2, width: 70, height: 30))
        self.traffic.backgroundColor = UIColor.gray
        
        self.traffic.setTitle("实时交通", for: UIControlState())
        self.traffic.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.traffic.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        self.traffic.tag = 2
        
        self.traffic.layer.cornerRadius = 4
        self.traffic.layer.masksToBounds = true
        
        bgView.addSubview(self.traffic)
        
        self.searchFiled = UITextField(frame: CGRect(x: (SCREENSIZE.width - 120) / 2, y: (44 - 30) / 2, width: 120, height: 30))
        //        self.searchFiled.backgroundColor = UIColor.red
        self.searchFiled.borderStyle = .roundedRect
        self.searchFiled.delegate = self
        bgView.addSubview(self.searchFiled)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        print(textField.text!)
        
        self.searchByKeyword(keyword: textField.text!)
        
        return true
    }
    
    
    func searchByKeyword(keyword: String){
        
        let poiSearchOption = QMSPoiSearchOption()
        
        
        poiSearchOption.keyword = keyword
        
        //        poiSearchOption.setBoundaryByRegionWithCityName("北京", autoExtend: false)
        
        
        if self.cllocation2D == nil {
            self.cllocation2D = CLLocationCoordinate2D(latitude: 39.908491, longitude: 116.374328)
        }
        
        
        poiSearchOption.setBoundaryByNearbyWithCenter(self.cllocation2D, radius: 10000)
        
        
        
        self.mapSearcher.search(with: poiSearchOption)
        
    }
    
    
    
    fileprivate var isTraffic = false  //默认关闭实时交通
    fileprivate var isSatellite = false //默认关闭卫星地图
    
    
    func someBtnAct(send: UIButton){
        switch send.tag {
        case 1:
            print("卫星")
            if self.isSatellite {
                self.isSatellite = false
                self.satellite.backgroundColor = .gray
                print("切换至普通地图")
                self.mapView.mapType = QMapTypeStandard
            }else{
                self.isSatellite = true
                print("将开启卫星地图")
                self.satellite.backgroundColor = .red
                self.mapView.mapType = QMapTypeSatellite
            }
            
            
        case 2:
            print("交通")
            if self.isTraffic {
                self.isTraffic = false
                self.traffic.backgroundColor = .gray
                print("将关闭实时交通")
                self.mapView.showTraffic = false
            }else{
                self.isTraffic = true
                self.traffic.backgroundColor = .red
                print("将开启实时交通")
                self.mapView.showTraffic = true
            }
            
        default:
            break
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.viewWillAppear()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mapView.viewDidDisappear()
        
        self.mapView.delegate = nil
        self.mapSearcher.delegate = nil
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    //MARK:QMapDelegate
    var cllocation2D: CLLocationCoordinate2D!
    
    func mapView(_ mapView: QMapView!, didUpdate userLocation: QUserLocation!) {
        
        
        let location = userLocation.location
        
        self.cllocation2D = location
        
        let longitude = location.longitude //经度
        
        let latitude = location.latitude //纬度
        
        print(location,longitude,latitude)
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
    func mapView(_ mapView: QMapView!, annotationView view: QAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //        QMSBaseResult
//        
//        let poi = view.annotation
//        
//        
//        
//        let poiDetailVC = PoiDetailViewController(result: poi!)
//        
//        self.navigationController?.pushViewController(poiDetailVC, animated: true)
//        
        
        
    }
    
    //MARK:QMSSearchDelegate
    
    func search(with searchOption: QMSSearchOption!, didFailWithError error: Error!) {
        print("错误->\(error)")
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
