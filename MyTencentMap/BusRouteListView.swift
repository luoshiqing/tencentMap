//
//  BusRouteListView.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/8.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BusRouteListView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    typealias SelectBusRouteHandler = (_ oneRoute: QMSBusingRoutePlan)->Void
    
    var busRouteHander: SelectBusRouteHandler?
    
    
    fileprivate var myTabView: UITableView?
    
    fileprivate var busingRoute: QMSBusingRouteSearchResult!
    
    fileprivate var myFrame: CGRect!
    
    fileprivate var routesArray = [QMSBusingRoutePlan]()
    
    init(frame: CGRect, busingRoute: QMSBusingRouteSearchResult, hander: @escaping SelectBusRouteHandler) {
        super.init(frame: frame)
        
        self.myFrame = frame
        self.busingRoute = busingRoute
        
        self.busRouteHander = hander
        
        self.backgroundColor = UIColor.yellow
        
        
        if let s = busingRoute.routes as? [QMSBusingRoutePlan]{
            self.routesArray = s
        }
        
        
        self.entranceAnimation() //入场动画
       
        
        self.loadMyTabView() //加载视图
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //移除,动画,接口
    func removeToLeft(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.frame = CGRect(x: SCREENSIZE.width, y: self.myFrame.origin.y, width: self.myFrame.width, height: self.myFrame.height)
            
        }, completion: nil)

    }

    //MARK:入场动画
    fileprivate func entranceAnimation(){
        self.frame = CGRect(x: SCREENSIZE.width, y: frame.origin.y, width: frame.width, height: frame.height)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.frame = self.myFrame
            
        }, completion: nil)
    }
    
    func loadMyTabView(){
        
        let rect = CGRect(x: 0, y: 0, width: self.myFrame.width, height: self.myFrame.height)
        self.myTabView = UITableView(frame: rect, style: .plain)
        
        self.myTabView?.backgroundColor = UIColor.white
        
        self.myTabView?.delegate = self
        self.myTabView?.dataSource = self
        
        self.myTabView?.tableFooterView = UIView()
        
//        self.myTabView?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        self.addSubview(self.myTabView!)
    }
    
    
    //MARK:Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.self.routesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "BusRouteCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? BusRouteTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("BusRouteTableViewCell", owner: self, options: nil )?.last as? BusRouteTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        

        
        if !self.routesArray.isEmpty {
            

            let oneRoute: QMSBusingRoutePlan = self.routesArray[indexPath.row]
            
            let busPlan = RouteService().getBusPlans(oneRoute)
            
            cell?.titleLabel.text = busPlan.title
            cell?.subTitleLabel.text = busPlan.subTitle
            cell?.formLabel.text = busPlan.form

        }
        
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //回调
        let oneRoute: QMSBusingRoutePlan = self.routesArray[indexPath.row]
        
        
        self.busRouteHander?(oneRoute)
        
        self.removeToLeft()
    }
    
 
    
    
    
    

}
