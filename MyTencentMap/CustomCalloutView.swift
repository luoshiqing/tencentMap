//
//  CustomCalloutView.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/3.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class CustomCalloutView: UIView {

    let kArrowHeight: CGFloat = 10
    
    let kPortraitMargin: CGFloat = 5
    let kPortraitWidth: CGFloat = 50
    let kPortraitHeight: CGFloat = 70
    
    let kTitleWidth: CGFloat = 120
    let kTitleHeight: CGFloat = 20
    
    let kBtnWidth: CGFloat = 50
    let kBtnHeight: CGFloat = 30
    
    
    
    var imageView: UIImageView!
    var btn: UIButton!
    var labelTitle: UILabel!
    var labelSubtitle: UILabel!
    var stackView: UIStackView!
    
  
    
    func setTitle(_ title: String){
        self.labelTitle.text = title
    }
    func setSubTitle(_ subtitle: String){
        self.labelSubtitle.text = subtitle
    }
    func setImage(_ image: UIImage){
        self.imageView.image = image
    }
    func setBtnTitle(_ text: String? ,for state: UIControlState){
        
        if text == nil {
            return
        }
        
        self.btn.setTitle(text!, for: state)
    }
    func btnAddTarget(_ target: Any,action: Selector, for controlEvents: UIControlEvents){
        if self.btn != nil {
            self.btn.addTarget(target, action: action, for: controlEvents)
        }
    }
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        self.initSubView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func initSubView(){
        
        imageView = UIImageView(frame: CGRect(x: kPortraitMargin, y: kPortraitMargin, width: kPortraitWidth, height: kPortraitHeight))
        
        self.addSubview(imageView)
        
        stackView = UIStackView(frame: CGRect(x: kPortraitMargin * 2 + kPortraitWidth, y: kPortraitMargin, width: kTitleWidth + kPortraitMargin * 2, height: kPortraitHeight + kPortraitMargin))
        
        
        stackView.axis = UILayoutConstraintAxis.vertical
        
        stackView.alignment = UIStackViewAlignment.leading
        
        self.addSubview(stackView)
        
        //添加title
        labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: kTitleWidth, height: kTitleHeight))
        stackView.addArrangedSubview(labelTitle)
        
        //添加subtitle
        labelSubtitle = UILabel(frame: CGRect(x: 0, y: 0, width: kTitleWidth, height: kTitleHeight))
        stackView.addArrangedSubview(labelSubtitle)
        
        //添加button
        btn = UIButton(type: UIButtonType.contactAdd)
        btn.frame = CGRect(x: 0, y: 0, width: kBtnWidth, height: kBtnHeight)
        
        btn.backgroundColor = UIColor.red
        
        stackView.addArrangedSubview(btn)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
