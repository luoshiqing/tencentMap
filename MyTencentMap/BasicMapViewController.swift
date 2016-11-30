//
//  BasicMapViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BasicMapViewController: UIViewController {

    var mapView: QMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Basic Map"
        self.view.backgroundColor = UIColor.white
        
        self.mapView = QMapView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64))
        
        self.view.addSubview(self.mapView)
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.viewWillAppear()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mapView.viewDidDisappear()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
