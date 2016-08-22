//
//  YLMainViewController.swift
//  YLSaoLei
//
//  Created by 王留根 on 16/8/18.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit
import SnapKit




class YLMainViewController: UIViewController {

    let titleImageView = UIImageView()
    let startGameBtn = UIButton()
    let choiceGameBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" MAIN_HEIGHT:\( MAIN_HEIGHT),MAIN_WIDTH\(MAIN_WIDTH)")
        setupView();

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear: MAIN_HEIGHT:\( MAIN_HEIGHT),MAIN_WIDTH\(MAIN_WIDTH)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
         print(" MAIN_HEIGHT:\( MAIN_HEIGHT),MAIN_WIDTH\(MAIN_WIDTH)")
        switch toInterfaceOrientation {
        case .Portrait:
            titleImageView.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.view.snp_top).offset(MAIN_HEIGHT/3);
                make.width.equalTo(180)

            })
            startGameBtn.snp_updateConstraints(closure: { (make) in
                make.centerY.equalTo(self.view.snp_centerY)
                make.centerX.equalTo(self.view.snp_centerX)
                make.width.equalTo(140)
                make.height.equalTo(40)
            })
            choiceGameBtn.snp_updateConstraints(closure: { (make) in
                make.width.equalTo(140)
            })
        default:
            titleImageView.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.view.snp_top).offset(MAIN_HEIGHT/7);
                make.width.equalTo(240)
            })
            startGameBtn.snp_updateConstraints(closure: { (make) in
                make.centerX.equalTo(self.view.snp_centerX)
                make.top.equalTo(titleImageView.snp_bottom).offset(50)
                make.width.equalTo(200)
                make.height.equalTo(40)
            })
            choiceGameBtn.snp_updateConstraints(closure: { (make) in
                make.width.equalTo(200)
            })
        }
    }
    

    func setupView() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named:"main_back.jpg")
        self.view .addSubview(backgroundImageView);
        backgroundImageView.userInteractionEnabled = true
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        
        titleImageView.image = UIImage(named: "main_title")
        self.view.addSubview(titleImageView);
        titleImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX);
            make.width.equalTo(180)
            make.height.equalTo(100)
            make.top.equalTo(self.view.snp_top).offset(MAIN_HEIGHT/3);
        }
        
        startGameBtn.setBackgroundImage(UIImage(named:"btn_main_select" ), forState: .Normal)
        startGameBtn.setTitle("开始游戏", forState: .Normal)
        startGameBtn.setTitleColor(UIColor.greenColor(), forState: .Normal)
        self.view .addSubview(startGameBtn)
        startGameBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp_centerY)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(140)
            make.height.equalTo(40)
            
        }
        startGameBtn.addTarget(self, action: #selector(startBtnAction), forControlEvents: .TouchUpInside)
        
        choiceGameBtn.setBackgroundImage(UIImage(named:"btn_main_select" ), forState: .Normal)
        choiceGameBtn.setTitle("选择关卡", forState: .Normal)
        choiceGameBtn.setTitleColor(UIColor.greenColor(), forState: .Normal)
        self.view .addSubview(choiceGameBtn)
        choiceGameBtn.snp_makeConstraints { (make) in
            make.top.equalTo(startGameBtn.snp_bottom).offset(50)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(140)
            make.height.equalTo(40)
            
        }
        choiceGameBtn.addTarget(self, action: #selector(choiceGameBtnAction), forControlEvents: .TouchUpInside)
    }
    
    
    func startBtnAction(){
        print("开始游戏")
    }
    
    func choiceGameBtnAction() {
        print("选择关卡")
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
