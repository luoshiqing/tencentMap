//
//  RouteSearchOptionViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/7.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class RouteSearchOptionViewController: UIViewController , QMapViewDelegate, QMSSearchDelegate{

    
 
    
    deinit {
        print("RouteSearchOptionViewController------->释放")
    }
    
    //路线规划类型
    enum RouteStype{
        case walking
        case driving
        case busing
    }
    
    
    fileprivate var form2D: CLLocationCoordinate2D! //起始坐标
    fileprivate var to2D: CLLocationCoordinate2D!   //终点坐标
    
    //标题
    fileprivate let planNameArray = ["步行","自驾","公交"]
    fileprivate var planBtnArray = [UIButton]()
    
    //搜索
    var mapSearcher: QMSSearcher!
    var mapView: QMapView!
    
    fileprivate var routeDetailView: RouteDetailView?
    fileprivate let routeDetailViewH: CGFloat = 60
    
    
    //GEO 339
    init(form: CLLocationCoordinate2D,to address2D: CLLocationCoordinate2D){
        super.init(nibName: nil, bundle: nil)
        
        self.form2D = form
        self.to2D = address2D
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "路线规划"
        self.view.backgroundColor = UIColor.white
        
        //初始化搜索服务
        self.mapSearcher = QMSSearcher(delegate: self)
        
        let rect = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height - 64 - routeDetailViewH)
        self.mapView = QMapView(frame: rect)
        self.mapView.delegate = self
        
        mapView.zoomLevel = 13
        
        mapView.showsUserLocation = true
        mapView.distanceFilter = 1
        mapView.userTrackingMode = QMUserTrackingModeNone
        
        self.view.insertSubview(self.mapView, at: 0)
        
        self.loadTitleViewNav()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.viewWillAppear()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mapView.viewDidDisappear()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupSearchOptions(.walking)
    }
    
    //MARK:定制导航栏
    func loadTitleViewNav(){
        
        let h: CGFloat = 40
        let titW: CGFloat = 140
        
        let titView = UIView(frame: CGRect(x: 0, y: 0, width: titW, height: h))
        
        titView.backgroundColor = UIColor.clear
        
        self.navigationItem.titleView = titView
        
        let w: CGFloat = titW / CGFloat(self.planNameArray.count)
        
        
        for i in 0..<self.planNameArray.count {
            
            let x: CGFloat = CGFloat(i) * w
            
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: w, height: h))
            
            btn.setTitle(self.planNameArray[i], for: UIControlState())
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            if i == 0 {
                btn.setTitleColor(UIColor.blue, for: UIControlState())
            }else{
                btn.setTitleColor(UIColor.white, for: UIControlState())
            }
 
            btn.tag = i
            btn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
            
            
            titView.addSubview(btn)
            
            self.planBtnArray.append(btn)
        }
 

    }
    
    fileprivate var isSecInt = 0 //记录选择的路线类型
    
    func someBtnAct(send: UIButton){
        //设置选中的颜色
        let tag = send.tag
        
        if tag == self.isSecInt {
            print("重复选择，不作处理")
        }else{
            
            self.isSecInt = tag
            
            for index in 0..<self.planBtnArray.count {
                
                let btn = self.planBtnArray[index]
                
                if tag == index {
                    btn.setTitleColor(UIColor.blue, for: UIControlState())
                    
                }else{
                    btn.setTitleColor(UIColor.white, for: UIControlState())
                }
            }
            //处理点击事件
            switch tag {
            case 0:
                print("步行")
                self.busRoutListView?.removeToLeft()
                self.setupSearchOptions(.walking)
            case 1:
                print("自驾")
                self.busRoutListView?.removeToLeft()
                self.setupSearchOptions(.driving)
                
            case 2:
                print("公交")
                self.setupSearchOptions(.busing)
                //加载在搜索路线回调之后加载
            default:
                break
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
    
        
    }

    func setupSearchOptions(_ type: RouteStype) {
        
        switch type {
        case .walking:
            
            let walkOpt = QMSWalkingRouteSearchOption()
            
            walkOpt.setFrom(self.form2D)
            walkOpt.setTo(self.to2D)
            
            self.mapSearcher.search(with: walkOpt)
            
        case .driving:
            
            let drivOpt = QMSDrivingRouteSearchOption()
            drivOpt.setFrom(self.form2D)
            drivOpt.setTo(self.to2D)
            
            drivOpt.setPolicyWith(QMSDrivingRoutePolicyType.leastDistance)
            self.mapSearcher.search(with: drivOpt)
        case .busing:
            let busOpt = QMSBusingRouteSearchOption()
            busOpt.setFrom(self.form2D)
            busOpt.setTo(self.to2D)
            
            self.mapSearcher.search(with: busOpt)
        }
 
    }
    //MARK:Search代理
    //步行结果回调
    func search(with walkingRouteSearchOption: QMSWalkingRouteSearchOption!, didRecevieResult walkingRouteSearchResult: QMSWalkingRouteSearchResult!) {
        
        print("步行结果回调-> \(walkingRouteSearchResult)")
        self.dealWalkingRoute(walkingRouteSearchResult)
    }
    
    //自驾回调
    func search(with drivingRouteSearchOption: QMSDrivingRouteSearchOption!, didRecevieResult drivingRouteSearchResult: QMSDrivingRouteSearchResult!) {
        
        print("自驾结果回调-> \(drivingRouteSearchResult)")
        
        self.dealDrivingRoute(drivingRouteSearchResult)
    }
    //公交回调
    func search(with busingRouteSearchOption: QMSBusingRouteSearchOption!, didRecevieResult busingRouteSearchResult: QMSBusingRouteSearchResult!) {
        
        print("公交结果回调-> \(busingRouteSearchResult)")
        
        self.dealBusingRoute(busingRouteSearchResult)
        
        
        
    }
    
    
    
    
    
    
    
    //MARK:Map代理
    func mapView(_ mapView: QMapView!, viewFor overlay: QOverlay!) -> QOverlayView! {
        
        let polyline: QPolyline = overlay as! QPolyline
        
        let polylineView: QPolylineView = QPolylineView(polyline: polyline)
        polylineView.lineWidth = 2
        
        if polyline.dash {

            polylineView.strokeColor = UIColor.red
           
            
            
        }else{
            
            polylineView.strokeColor = UIColor.blue
            
            
        }

        
        return polylineView
        
    }
    
    
    //MARK:处理路线信息
    //步行信息
    func dealWalkingRoute(_ walkingRouteResult: QMSWalkingRouteSearchResult){
        
        let (walkPolyline,region,valueDic) = RouteService().dealWalkingRoute(walkingRouteResult)
        
        if let walkp = walkPolyline {
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(walkp)
        }
        
        if let reg = region {
            self.mapView.setVisibleMapRect(QMapRectForCoordinateRegion(reg), edgePadding: UIEdgeInsetsMake(30, 30, 30, 30), animated: false)
        }
        
        if let vdic = valueDic {
            
            let distance = vdic["distance"] as! String
            let duration = vdic["duration"] as! String
            
            let title = distance + " | " + duration
            let subTitle = (vdic["instruction"] as! [String]).first!
            
            let busPlan = BusPlan()
            
            busPlan.title = title
            busPlan.subTitle = subTitle
            
            self.loadRouteDetailView(busPlan)
        }else{
            
            let busPlan = BusPlan()
            
            busPlan.title = "暂无步行路线推荐"
            busPlan.subTitle = "请切换其他途径"
            
            self.loadRouteDetailView(busPlan)
  
        }
  
    }
    //自驾信息
    func dealDrivingRoute(_ drivingRouteResult: QMSDrivingRouteSearchResult){
        let (drivPolyline,valueDic) = RouteService().dealDrivingRoute(drivingRouteResult)
        
        print(valueDic)
        
        
        self.mapView.removeOverlays(self.mapView.overlays)
        
        self.mapView.add(drivPolyline)
        
        
        let distance = valueDic["distance"] as! String
        let duration = valueDic["duration"] as! String
        
        let title = distance + " | " + duration
        let subTitle = (valueDic["instruction"] as! [String]).first!
        
        let busPlan = BusPlan()
        
        busPlan.title = title
        busPlan.subTitle = subTitle
        
        self.loadRouteDetailView(busPlan)
        
        
    }
    
    
    var busRoutListView: BusRouteListView?
    //公交信息
    func dealBusingRoute(_ busingRouteResult: QMSBusingRouteSearchResult){
        
        let rect = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height - 64)
        self.busRoutListView = BusRouteListView(frame: rect, busingRoute: busingRouteResult, hander: self.SelectBusRouteHandler)
        
        self.view.addSubview(self.busRoutListView!)
        
        
    }
    
    //MARK:公交路线选择回调
    func SelectBusRouteHandler(_ oneRoute: QMSBusingRoutePlan)->Void{
        print("路线选择回调")
        
        let busQPolylineArray: [QPolyline]? =  RouteService().dealBusingRoute(oneRoute)
        
        if let busArray = busQPolylineArray {
            
            self.mapView.removeOverlays(self.mapView.overlays)
            
            for busline in busArray {
                
                self.mapView.add(busline)
                
            }
            
            let busPlan = RouteService().getBusPlans(oneRoute)
            self.loadRouteDetailView(busPlan)
        }else{
            
            let busPlan = BusPlan()
            busPlan.title = "暂无公交路线"
            busPlan.subTitle = "请选择其他路线"
            busPlan.form = ""
            
            self.loadRouteDetailView(busPlan)
            
        }
        
        
        
   
    }
    
    
    func loadRouteDetailView(_ busPlan: BusPlan){
        
        if self.routeDetailView == nil {
            
            let rect = CGRect(x: 0, y: SCREENSIZE.height - 64 - routeDetailViewH, width: SCREENSIZE.width, height: routeDetailViewH)
            
            routeDetailView = RouteDetailView(frame: rect, busPlan: busPlan)
            
            self.view.addSubview(routeDetailView!)
        }else{
            
            self.routeDetailView?.setValue(busPlan)
  
        }
        
        
        
        
        
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
