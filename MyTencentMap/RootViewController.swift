//
//  RootViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class RootViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    fileprivate var myTabView: UITableView?
    
    fileprivate let demosArray: [[String:String]] = [["title":"Basic Map","description":"基本地图"],
                                                     ["title":"Map Type","description":"底图-交通"],
                                                     ["title":"Geo Suggetion","description":"云-检索",],
                                                     ["title":"Nav","description":"导航"],
                                                     ["title":"Annotation","description":"自定义标注"]]
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Root"
        self.view.backgroundColor = UIColor.white
        
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: SCREENSIZE.height - 64), style: .plain)
        
        self.myTabView?.delegate = self
        self.myTabView?.dataSource = self
        
        self.view.addSubview(self.myTabView!)
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demosArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        cell?.accessoryType = .disclosureIndicator
        
        let dic = self.demosArray[indexPath.row]
        
        cell?.textLabel?.text = dic["title"]
        cell?.detailTextLabel?.text = dic["description"]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        
        switch indexPath.row {
        case 0:
            let ctr = BasicMapViewController()
            self.navigationController?.pushViewController(ctr, animated: true)
        case 1:
            let ctr = MapTypeViewController()
            self.navigationController?.pushViewController(ctr, animated: true)
        case 2:
            let ctr = GeoAndSuggetionViewController()
            self.navigationController?.pushViewController(ctr, animated: true)
        case 3:
            let ctr = NavMapViewController()
            self.navigationController?.pushViewController(ctr, animated: true)
        case 4:
            let ctr = AnnotaionViewController()
            self.navigationController?.pushViewController(ctr, animated: true)
        default:
            break
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
