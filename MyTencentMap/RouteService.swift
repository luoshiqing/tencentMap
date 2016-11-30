//
//  RouteService.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/7.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BusPlan { //路线显示的 tabview
    
    var title: String = ""
    var subTitle: String = ""
    var form: String = ""
    
    init() {
        
    }
    
}


class RouteService: NSObject {
    //MARK:处理步行结果
    func dealWalkingRoute(_ walkingRouteResult: QMSWalkingRouteSearchResult) -> (QPolyline?,QCoordinateRegion?,[String:Any]?){
        
        var walkingRoutePlan: QMSRoutePlan!
        
        if walkingRouteResult.routes != nil && walkingRouteResult.routes.count > 0{
            walkingRoutePlan = (walkingRouteResult.routes as! [QMSRoutePlan]).first!
        }else{
            return (nil,nil,nil)
        }

        //距离
        let distance: String = MyService().humanReadableForDistance(distance: walkingRoutePlan.distance)
        
        //时间
        let duration: String = MyService().humanReadableForTimeDuration(timeDuration: walkingRoutePlan.duration)
        //方向
        let route = "方向：\(walkingRoutePlan.direction)"
        print("方向:->\(route)")
        
        let steps = walkingRoutePlan.steps as! [QMSRouteStep]
        
        var instructionArray = [String]() //详细步骤
        for item in steps {
            let instruction: String = item.instruction
            instructionArray.append(instruction)
        }
        
        let valueDic: [String:Any] = ["distance":distance,"duration":duration,"instruction":instructionArray]
        
        let count = walkingRoutePlan.polyline.count
        var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: count)
        for i in 0..<count {
            (walkingRoutePlan.polyline[i] as! NSValue).getValue(&coordinateArray[i])
        }

        let walkPolyline: QPolyline = QPolyline(coordinates: &coordinateArray, count: UInt(count))
        

        
        walkPolyline.dash = true

    
        let region = self.setMapRegionWithCoordinates(coordinateArray, and: count)
        
        return (walkPolyline,region,valueDic)
    }
    
    fileprivate func setMapRegionWithCoordinates(_ points: [CLLocationCoordinate2D],and count: Int) -> QCoordinateRegion{
        
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

        return region
    }
    
    //MARK:公交信息处理
    //公交信息
    func dealBusingRoute(_ busPlan: QMSBusingRoutePlan) -> [QPolyline]? {
        
        
        var busingPolylineArray = [QPolyline]()
        
        
        print("busPlan-->\(busPlan)")

        let steps = busPlan.steps as! [QMSBusingSegmentRoutePlan]
        
        for plan in steps {
            
            let mode: String = plan.mode
            
            
            if mode == "WALKING" {  //步行
                
                let count = plan.polyline.count
                var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: count)
                for i in 0..<count {
                    (plan.polyline[i] as! NSValue).getValue(&coordinateArray[i])
                }
                
                let busPolyline: QPolyline = QPolyline(coordinates: &coordinateArray, count: UInt(count))
                
                busPolyline.dash = true
                
                busingPolylineArray.append(busPolyline)
            }else{

                
                if let lineArray = plan.lines as? [QMSBusingRouteTransitLine] {
                    
                    if let line = lineArray.first {
                        
                        let lineCount = line.polyline.count
                        
                        var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: lineCount)
                        
                        
                        for i in 0..<lineCount {
                            (line.polyline[i] as! NSValue).getValue(&coordinateArray[i])
                        }
                        
                        let busPolyline: QPolyline = QPolyline(coordinates: &coordinateArray, count: UInt(lineCount))
                        busPolyline.dash = false
                        
                        busingPolylineArray.append(busPolyline)
                        
                        
                    }else{
                        return nil
                    }

                }else{
                    
                    return nil
                    
                }
   
                
            }
            
        }

        return busingPolylineArray
   
    }
    
    
    
    
    
    
    //MARK:自驾信息处理
    func dealDrivingRoute(_ drivingRouteResult: QMSDrivingRouteSearchResult) ->(QPolyline,[String:Any]){
        
        let drivingRoutePlan = (drivingRouteResult.routes as! [QMSRoutePlan]).first!
        
        //距离
        let distance: String = MyService().humanReadableForDistance(distance: drivingRoutePlan.distance)
        
        //时间
        let duration: String = MyService().humanReadableForTimeDuration(timeDuration: drivingRoutePlan.duration)
        //方向
        let route = "方向：\(drivingRoutePlan.direction)"
        print("方向:->\(route)")
        
        let steps = drivingRoutePlan.steps as! [QMSRouteStep]
        
        var instructionArray = [String]() //详细步骤
        for item in steps {
            let instruction: String = item.instruction
            instructionArray.append(instruction)
        }
        
        let valueDic: [String:Any] = ["distance":distance,"duration":duration,"instruction":instructionArray]
        

        
        let count = drivingRoutePlan.polyline.count
        var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: count)
        for i in 0..<count {
            (drivingRoutePlan.polyline[i] as! NSValue).getValue(&coordinateArray[i])
        }
        
        let drivPolyline: QPolyline = QPolyline(coordinates: &coordinateArray, count: UInt(count))
        
        drivPolyline.dash = false
        
        return (drivPolyline,valueDic)
   
    }

    
    
    
    
    //MARK:公交线路方案
    func getBusPlans(_ oneRoute: QMSBusingRoutePlan) -> BusPlan {
        
        let busPlan = BusPlan()
        
        let duration: CGFloat = oneRoute.duration //时间
        let lineTime = MyService().humanReadableForTimeDuration(timeDuration: duration)
//        let dounds: String = oneRoute.bounds
//        
//        let distance: CGFloat = oneRoute.distance //距离
        let stepsArray = oneRoute.steps as! [QMSBusingSegmentRoutePlan]
        var lineTitle = "" //标题
        var transit_station_count: Int = 0 //交通需要的经过的站点
        var waklDistance: CGFloat = 0 //步行需要走的路程
        var firstOn = "" //起始地点
        var firstDestination = "" //起始点方向
        for i in 0..<stepsArray.count {
            
            let plan: QMSBusingSegmentRoutePlan = stepsArray[i]

            let mode: String = plan.mode
            
            if mode == "WALKING" { //步行
                //步行需要 距离
                let distance: CGFloat = plan.distance //步行距离
                waklDistance += distance
                
            }else if mode == "TRANSIT"{ //交通 TRANSIT
                //交通需要 多少站,起始坐车点
                if let line = plan.lines.first as? QMSBusingRouteTransitLine {
                    
                    let geton: QMSBusStation = line.geton //起始点
                    if firstOn.isEmpty {
                        firstOn = geton.title + "站"
                    }
                    
                    let destination: QMSStationEntrance = line.destination //方向
                    if firstDestination.isEmpty {
                        firstDestination = destination.title
                    }
                    
                    let title = line.title //标题
                    let station_count: Int = line.station_count //站数
                    
                    transit_station_count += station_count
                    
                    if lineTitle.isEmpty {
                        if let tit = title {
                            lineTitle += tit
                        }
                    }else{
                        if let tit = title {
                            lineTitle += "->\(tit)"
                        }
                    }
                }
            }
            //副标题需要显示的
            //距离转换
            let walk = MyService().humanReadableForDistance(distance: waklDistance)
            let subText = lineTime + " | " + "\(transit_station_count)站" + " | " + "步行\(walk)"
            let form = firstOn + " 上车 " + "（\(firstDestination)方向）"
            
            busPlan.title = lineTitle
            busPlan.subTitle = subText
            busPlan.form = form
        }
        return busPlan
    }
    
    
    
    
    
    
}
