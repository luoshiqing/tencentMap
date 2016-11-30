//
//  CustomAnnotationView.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/3.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class CustomAnnotationView: QAnnotationView {
    
    let calloutWidth: CGFloat = 200.0
    let calloutHeight: CGFloat = 90.0
    
    
    var imageCallout: UIImage!
    var btnTitle: String!
    
    var btnTarget: Any!
    
    var btnState: UIControlState!
    var btnControlEvents: UIControlEvents!
    
    var btnAction: Selector!
    
    var customCalloutView: CustomCalloutView!
    
    func setCalloutImage(_ image: UIImage){
        self.imageCallout = image
    }
    func setCalloutBtnTitle(title: String, for state: UIControlState){
        
        self.btnTitle = title
    }
    func addCalloutBtnTarget(_ target: Any, action: Selector, for events: UIControlEvents){
        
        btnTarget = target
        btnAction = action
        btnControlEvents = events
    }
    
    
    
    
    
    func setSelected(selected: Bool){
        self.setSelected(selected: selected, animated: false)
    }
    func setSelected(selected: Bool,animated: Bool){
        
        if self.isSelected == selected {
            return
        }
        
        if selected {
            
            if self.customCalloutView == nil {
                self.customCalloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: calloutWidth, height: calloutHeight))
                
                
                
                
                self.customCalloutView.center = CGPoint(x: self.bounds.width / 2, y: -(self.customCalloutView.bounds.height / 2))
                
                self.customCalloutView.setTitle(self.annotation.title!())
                self.customCalloutView.setSubTitle(self.annotation.subtitle!())
                self.customCalloutView.setImage(self.imageCallout)
                
                self.customCalloutView.setBtnTitle(self.btnTitle, for: self.btnState)
                self.customCalloutView.btnAddTarget(self.btnTarget, action: self.btnAction, for: self.btnControlEvents)
                
            }

            self.addSubview(self.customCalloutView)

            
        }else{
            self.customCalloutView.removeFromSuperview()
        }
        
        super.setSelected(selected, animated: animated)
        
    }
    
    func pointInside(_ point: CGPoint,with event: UIEvent) -> Bool{
        
        var inside = super.point(inside: point, with: event)
        
        if !inside {
            /* Callout existed. */
            if self.isSelected && (self.customCalloutView.superview != nil) {
                let pointInCallout = self.convert(point, to: self.customCalloutView)
                
                inside = self.customCalloutView.bounds.contains(pointInCallout)
            }
  
        }
        
        return inside
    }
    

    
}
