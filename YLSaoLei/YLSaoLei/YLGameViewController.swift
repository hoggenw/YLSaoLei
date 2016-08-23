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
    let stepLabel = UILabel()
    let timeLabel = UILabel()
    let timer = NSTimer()
    
    var step :Int? {
        didSet {
            stepLabel.text = NSString.localizedStringWithFormat("步数：%04d", step!) as String
        }
    }
    var time :Int? {
        didSet {
            timeLabel.text = String.localizedStringWithFormat("耗时：%04d", time!) as String
        }
    }
    

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
        
        let timeImageView = UIImageView()
        timeImageView.image = UIImage(named:"game_clock")
        self.view.addSubview(timeImageView);
        timeImageView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.width.height.equalTo(40)
            make.centerX.equalTo(self.view.snp_centerX)
            
        }
        
        stepLabel.textColor = UIColor.whiteColor()
        stepLabel.font = UIFont.systemFontOfSize(16)
        stepLabel.textAlignment = .Center
        self.view.addSubview(stepLabel)
        stepLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(timeImageView.snp_left).offset(-20);
            make.centerY.equalTo(timeImageView.snp_centerY)
        }
        
        step = 0
        
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.systemFontOfSize(16)
        timeLabel.textAlignment = .Center
        self.view.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.left.equalTo(timeImageView.snp_right).offset(20);
            make.centerY.equalTo(timeImageView.snp_centerY)
        }
        time = 0
        
        
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
