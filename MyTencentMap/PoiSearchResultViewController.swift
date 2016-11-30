//
//  PoiSearchResultViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/4.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class PoiSearchResultViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{


    typealias poiSelectResultClourse = (_ poiData: QMSPoiData)->Void
    
    var poiSelectClourse: poiSelectResultClourse?
    
    
    deinit {
        print("PoiSearchResultViewController------>释放")
    }
    
    fileprivate var qmsPoiData = [QMSPoiData]()
    fileprivate var myLocation2D: CLLocationCoordinate2D!
    
    init(location2D: CLLocationCoordinate2D, qmsPoiData: [QMSPoiData],poiSelectClourse: @escaping poiSelectResultClourse){
        super.init(nibName: nil, bundle: nil)
        
        self.myLocation2D = location2D
        self.qmsPoiData = qmsPoiData
        
        self.poiSelectClourse = poiSelectClourse
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var myTabView: UITableView!
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "搜索结果"
        self.view.backgroundColor = UIColor.white
        
        let rect = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height - 64)
        myTabView = UITableView(frame: rect, style: .plain)
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        self.view.addSubview(myTabView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //MARK:Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.qmsPoiData.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "PoiSearchCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? PoiSearchTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("PoiSearchTableViewCell", owner: self, options: nil )?.last as? PoiSearchTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        if !self.qmsPoiData.isEmpty {
            
            let val = self.qmsPoiData[indexPath.row]
            
            
            let title: String = val.title
            let address: String = val.address
            let location: CLLocationCoordinate2D = val.location
            
            cell?.titleLabel.text = title
            cell?.subTitleLabel.text = address
            
            let distance = MyService().getBetweenMapPointsDistance(self.myLocation2D, to: location)
            
            cell?.distanceLabel.text = distance
            
        }
        
 
        
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let val = self.qmsPoiData[indexPath.row]
        
        self.poiSelectClourse?(val)
        
        self.navigationController!.popViewController(animated: true)
    }

    
    

}
