//
//  MapDetailView.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/3.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class MapDetailView: UIView {

    deinit {
        print("MapDetailView---->释放")
    }
    
//    QMSSuggestionPoiData ,QMSPoiData
    fileprivate var poiData: AnyObject! //数据
    fileprivate var mylocation2D: CLLocationCoordinate2D! //我的坐标
    
    fileprivate var superCtr: UIViewController!
    
    fileprivate let toLeft: CGFloat = 10        //左边距
    
    fileprivate let toUP: CGFloat = 15          //上边距
    
    fileprivate var myFrame: CGRect!            //frame
    
    fileprivate var titleLabel: UILabel!        //标题
    fileprivate var subuTitleLabel: UILabel!    //副标题
    
    fileprivate var distanceLabel: UILabel!     //距离
    
    
    fileprivate var closeBtn: UIButton!         //关闭按钮
    
    fileprivate var to2D: CLLocationCoordinate2D! //目的地坐标
    
    let titleArray = ["附近","路线","收藏"]
    
    init(frame: CGRect, myCllocation2D: CLLocationCoordinate2D, poiSearchData: AnyObject,target: UIViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.poiData = poiSearchData
        self.myFrame = frame
        self.mylocation2D = myCllocation2D
        self.superCtr = target
        
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        //加载UI
        self.loadSomeUI()
        
        //赋值
        self.assignmentSomeView(self.mylocation2D, poiData: self.poiData)
        
        //出场动画
        self.frame = CGRect(x: 0, y: SCREENSIZE.height - 64, width: self.myFrame.width, height: self.myFrame.height)
        self.rising()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK:加载UI
    fileprivate func loadSomeUI(){
        
        //标题
        let titleH: CGFloat = 30 //标题高度
        titleLabel = UILabel(frame: CGRect(x: toLeft, y: toUP, width: myFrame.width - toLeft - 100, height: titleH))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(titleLabel)
        
        //距离label宽度
        let distanceW: CGFloat = 50
        
        //副标题
        subuTitleLabel = UILabel(frame: CGRect(x: toLeft, y: toUP + titleH + 10, width: myFrame.width - toLeft * 2 - distanceW, height: titleH))
        subuTitleLabel.backgroundColor = UIColor.clear
        subuTitleLabel.textColor = UIColor.gray
        subuTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subuTitleLabel.numberOfLines = 0
        self.addSubview(subuTitleLabel)
        
        //距离
        distanceLabel = UILabel(frame: CGRect(x: myFrame.width - distanceW - 5, y: toUP + titleH + 10, width: distanceW, height: titleH))
        distanceLabel.textColor = UIColor.gray
        distanceLabel.backgroundColor = UIColor.clear
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 11)
        distanceLabel.textAlignment = .right
        self.addSubview(distanceLabel)
        
        //关闭按钮
        let closeH: CGFloat = 30
        closeBtn = UIButton(frame: CGRect(x: myFrame.width - closeH - 10, y: toUP - 5, width: closeH, height: closeH))
        closeBtn.backgroundColor = UIColor.red
        closeBtn.setTitle("x", for: UIControlState())
        closeBtn.layer.cornerRadius = closeH / 2.0
        closeBtn.tag = 100
        closeBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        self.addSubview(closeBtn)
        
        //按钮
        
        
        let btnH: CGFloat = 30
        let btnY: CGFloat = self.myFrame.height - btnH - 10
        
        let secColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        for i in 0..<titleArray.count {
            
            //每个按钮之间距离跟 边距为 8
            let distance: CGFloat = 8
            //每个按钮的宽度
            let btnW: CGFloat = (self.myFrame.width - (distance * CGFloat(titleArray.count + 1))) / CGFloat(titleArray.count)
            
            let x: CGFloat = CGFloat(i + 1) * distance + CGFloat(i) * btnW
            
            let btn = UIButton(frame: CGRect(x: x, y: btnY, width: btnW, height: btnH))

            btn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: UIControlState())
            btn.setBackgroundImage(UIImage().createImagFromColor(secColor), for: .highlighted)
            
            btn.setTitle(titleArray[i], for: UIControlState())
            
            btn.setTitleColor(secColor, for: UIControlState())
            btn.setTitleColor(UIColor.white, for: .highlighted)

            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.layer.borderColor = secColor.cgColor
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 3
            btn.layer.masksToBounds = true
            
            btn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
            btn.tag = i
            
            self.addSubview(btn)
    
        }
        
        
        
        
        
        
    }
    
    fileprivate func assignmentSomeView(_ myCllocation2D: CLLocationCoordinate2D, poiData: AnyObject) {
        //QMSSuggestionPoiData ,QMSPoiData
        
        self.mylocation2D = myCllocation2D
        
        if let suggestionData = poiData as? QMSSuggestionPoiData {
            
            let title: String = suggestionData.title
            let subuTitle: String = suggestionData.address
            let cllocation2D: CLLocationCoordinate2D = suggestionData.location
            
            self.to2D = cllocation2D //设置目的地
            
            self.titleLabel.text = title
            self.subuTitleLabel.text = subuTitle
            
            let distance = MyService().getBetweenMapPointsDistance(self.mylocation2D, to: cllocation2D)
            self.distanceLabel.text = distance
            
        }else if let tmpPoiData = poiData as? QMSPoiData{
            
            let title: String = tmpPoiData.title
            let subuTitle: String = tmpPoiData.address
            let cllocation2D: CLLocationCoordinate2D = tmpPoiData.location
            
            self.to2D = cllocation2D //设置目的地
            
            self.titleLabel.text = title
            self.subuTitleLabel.text = subuTitle
            
            let distance = MyService().getBetweenMapPointsDistance(self.mylocation2D, to: cllocation2D)
            self.distanceLabel.text = distance
            
        }else{
            print("暂支持 QMSSuggestionPoiData ,QMSPoiData 两种格式")
        }
        
        
        
    }
    
    
    
    
    //MARK:开放的设置接口
    public func setData(_ location: CLLocationCoordinate2D, poiSearchData: AnyObject){
        self.poiData = poiSearchData
        
        self.mylocation2D = location
        
        self.assignmentSomeView(self.mylocation2D, poiData: self.poiData)
        
        self.rising()
        print(self.poiData)
    }
    
    
    
    //MARK:按钮点击事件
    @objc fileprivate func someBtnAct(send: UIButton){
        switch send.tag {
        case 100: //取消
            self.falling()
        case 0:
            print(self.titleArray[0])
        case 1:
            print(self.titleArray[1])
            
            if self.to2D != nil {
                let routeVC = RouteSearchOptionViewController(form: self.mylocation2D, to: self.to2D)
                self.superCtr.navigationController?.pushViewController(routeVC, animated: false)
            }
        case 2:
            print(self.titleArray[2])
        default:
            break
        }
    }
    
    //MARK:下降动画
    fileprivate func falling(){

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.frame = CGRect(x: 0, y: SCREENSIZE.height - 64, width: self.myFrame.width, height: self.myFrame.height)
            
        }, completion: nil)
    }
    //MARK:上升动画
    fileprivate func rising(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.frame = CGRect(x: 0, y: SCREENSIZE.height - 64 - self.myFrame.height, width: self.myFrame.width, height: self.myFrame.height)
            
        }, completion: nil)
    }
    
    
    
    
    

}





