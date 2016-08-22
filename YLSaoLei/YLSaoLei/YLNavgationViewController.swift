//
//  YLNavgationViewController.swift
//  YLSaoLei
//
//  Created by 王留根 on 16/8/18.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit

class YLNavgationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(named: "transparent"), forBarMetrics: .Default)
        self.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationBar.shadowImage = UIImage(named: "transparent")
   // 当导航控制器管理的子控制器自定义了leftBarButtonItem，则子控制器左边缘右滑失效。解决方案一
        self.interactivePopGestureRecognizer?.delegate = self;
        self.interactivePopGestureRecognizer?.enabled  = true;    // default is Yes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YLNavgationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        var shouldBegin:Bool = true
        if viewControllers.count == 0 {
            shouldBegin = false
        }
        return shouldBegin
    }
    
}
































