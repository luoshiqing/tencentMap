//
//  MyService.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/2.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class MyService: NSObject {

    /*!
     *  @brief  格式化距离
     *
     *  @param distance 距离,单位是米
     *  @return 格式化字符串
     *  @detial
     *  (1) 567  ---> 567米
     *  (2) 1567 ---> 1.5公里
     *  (3) 2000 ---> 2公里
     */
    func humanReadableForDistance(distance: CGFloat)-> String{
        
        var humanReadable:String = ""

        
        if distance < 1000 {
            humanReadable = "\(Int(distance))米"
        }else{
            
            let zeroStr = ".0"
            
            humanReadable = String(format:"%.1f",(distance / 1000.0))
            
            let zeroEnd = humanReadable.hasSuffix(zeroStr)
            
            if zeroEnd {
                humanReadable = (humanReadable as NSString).substring(with: NSRange(location: 0, length: humanReadable.characters.count - zeroStr.characters.count))
            }
            
            humanReadable += "公里"
            
        }
        
        return humanReadable
        
    }
    
    /*!
     *  @brief  格式化时间
     *
     *  @param timeDuration 时间,单位是分钟
     *  @return 格式化字符串
     *  @detial
     *  (1) 10  ---> 10分钟
     *  (2) 120 ---> 2小时
     *  (3) 124 ---> 2小时4分钟
     */
    func humanReadableForTimeDuration(timeDuration: CGFloat) ->String{
        
        
        var humanReadable:String = ""
        
        if timeDuration < 60 {
            humanReadable = "\(Int(timeDuration))分钟"
        }else{
            
            humanReadable = "\(Int(timeDuration) / 60)小时"
            
            let remainder = fmod(timeDuration, 60.0)
            
            if remainder != 0 {
                let remainderHumanReadable = self.humanReadableForTimeDuration(timeDuration: remainder)
                
                humanReadable += remainderHumanReadable
            }

        }
 
        return humanReadable
    }
    
    
    //计算两点之间的距离
    func getBetweenMapPointsDistance(_ from: CLLocationCoordinate2D,to: CLLocationCoordinate2D) -> String{
        
        let fromPoint: QMapPoint = QMapPointForCoordinate(from)
        
        let toPoint: QMapPoint = QMapPointForCoordinate(to)
        let distance: Double = QMetersBetweenMapPoints(fromPoint, toPoint)
        let result = self.humanReadableForDistance(distance: CGFloat(distance))
        return result
        
    }
    
    
    
    
    
    
}



var isabc: Bool = false

extension QPolyline {
    
    var dash: Bool {
        
        get{
            let value = objc_getAssociatedObject(self, &isabc) as? Bool
            
            if let a = value {
                return a
            }else{
                return false
            }
        }
        
        set(a){
            objc_setAssociatedObject(self, &isabc, a, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    
    }
  
}

extension UIImage {
    //颜色转图片
    func createImagFromColor(_ color: UIColor)->UIImage{
        
        let size = CGSize(width: 1, height: 1)
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        context?.fill(rect)
        
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return theImage!
        
    }
}


