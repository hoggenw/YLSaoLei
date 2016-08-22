//
//  YLGameViewController.swift
//  YLSaoLei
//
//  Created by 王留根 on 16/8/22.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit

class YLGameViewController: UIViewController {
    
    let titleLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupView() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named:"main_back.jpg")
        self.view .addSubview(backgroundImageView);
        backgroundImageView.userInteractionEnabled = true
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        titleLabel.textColor = UIColor.yellowColor()
        titleLabel.text = "关卡：1"
        titleLabel.textAlignment = .Center
        self.view .addSubview(titleLabel);
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(30)
            make.width.equalTo(120)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
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
