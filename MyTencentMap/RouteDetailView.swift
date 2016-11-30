//
//  RouteDetailView.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/8.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class RouteDetailView: UIView {

    fileprivate var busPlan: BusPlan!
    fileprivate var myFrame: CGRect!
    
    fileprivate var titleLabel: UILabel?
    fileprivate var subTitleLabel: UILabel?
    
    fileprivate let toLeftW: CGFloat = 5.0
    fileprivate let toUpH: CGFloat = 8.0
    
    
    init(frame: CGRect,busPlan: BusPlan) {
        super.init(frame: frame)
        
        self.myFrame = frame
        self.busPlan = busPlan
        
        self.backgroundColor = UIColor.white
 
        
        self.loadSomeView()
        
        self.setValue(busPlan)
        
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadSomeView(){
    
        let titH: CGFloat = 18.0
        titleLabel = UILabel(frame: CGRect(x: toLeftW, y: toUpH, width: myFrame.width - 2 * toLeftW, height: titH))
        
        titleLabel?.backgroundColor = UIColor.white
        
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(titleLabel!)
        
        //距离
        let rect = CGRect(x: toLeftW, y: toUpH * 2 + titH, width: myFrame.width - 2 * toLeftW, height: titH)
        subTitleLabel = UILabel(frame: rect)
    
        subTitleLabel?.backgroundColor = UIColor.white
        
        subTitleLabel?.textColor = UIColor(red: 92/255.0, green: 94/255.0, blue: 102/255.0, alpha: 1)
        
        subTitleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        self.addSubview(subTitleLabel!)
        
    }
    
    func setValue(_ busPlan: BusPlan){

        self.titleLabel?.text = busPlan.title
        self.subTitleLabel?.text = busPlan.subTitle
    }
    
    
    
    

}
