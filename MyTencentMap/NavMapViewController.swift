//
//  NavMapViewController.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/3.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class NavMapViewController: UIViewController {

    deinit {
        print("哈哈哈哈哈哈哈哈哈，噢噢噢噢哦哦哦")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "导航"
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
 
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange]
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
