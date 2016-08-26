//
//  YLGameViewController.swift
//  YLSaoLei
//
//  Created by 王留根 on 16/8/22.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit


public enum ButtonStatus:Int {
    case NotTap = 1
    case AlreadyTap = 2
}

class YLGameViewController: UIViewController {
    
    let titleLabel = UILabel()
    let stepLabel = UILabel()
    let timeLabel = UILabel()
    let bomeLabel = UILabel()
    var boomArray = [Int]()
    var timer = NSTimer()
    let gameBackView = UIView()
    
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
    
    var leftBome :Int? {
        didSet {
            
            // bomeLabel.text = String.localizedStringWithFormat("老婆加油！还有%d颗地雷没被发现", leftBome!) as String
            bomeLabel.attributedText = leftBomeChanged(leftBome!)
        }
    }
    

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    //主流程
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
        //创建游戏界面
        setupGameView()
        
        //bak_line2_text
        leftBome = 10
        let hintImageView = UIImageView()
        hintImageView.image = UIImage(named: "bak_line2_text")
        self.view.addSubview(hintImageView)
        hintImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.gameBackView.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(25)
            make.right.equalTo(self.view.snp_right).offset(-25)
            make.height.equalTo(45)
        }
        let bomeImageView = UIImageView()
        bomeImageView.image = UIImage(named: "bomb_revealed")
        hintImageView.addSubview(bomeImageView)
        bomeImageView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(hintImageView)
            make.left.equalTo(hintImageView.snp_left).offset(10)
            make.width.equalTo(45)
        }
        
        bomeLabel.textColor = UIColor.whiteColor()
        bomeLabel.textAlignment = .Left
        bomeLabel.adjustsFontSizeToFitWidth = true
        hintImageView.addSubview(bomeLabel)
        bomeLabel.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(hintImageView)
            make.left.equalTo(bomeImageView.snp_right).offset(2)
            make.right.equalTo(hintImageView.snp_right).offset(-10)
        }
        
        let refreshButton = UIButton()
        refreshButton.setImage(UIImage(named: "btn_dailog_reset"), forState: .Normal)
        let btnWidth = (MAIN_WIDTH-100)/5
        refreshButton.addTarget(self, action: #selector(refreshButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(refreshButton)
        refreshButton.snp_makeConstraints { (make) in
            make.top.equalTo(hintImageView.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(40+btnWidth)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnWidth)
        }
        
        let signButton = UIButton()
        signButton.setBackgroundImage(UIImage(named:"game_mine_flag" ), forState: .Normal)
        signButton.addTarget(self, action: #selector(signButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(signButton)
        signButton.snp_makeConstraints { (make) in
            make.top.equalTo(hintImageView.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(60+3*btnWidth)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnWidth)
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
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timeGo), userInfo: nil, repeats: true)
//        timer.fire()
        NSRunLoop.currentRunLoop().addTimer(timer, forMode:NSDefaultRunLoopMode)
    }
    
    //刷新
    func refreshButtonAction(){
        self.step = 0
        self.time = 0
        
        setupGameView()
    }
    //标记
    func signButtonAction(){
        
        
    }
    
    //创建游戏界面
    func setupGameView(){
        let btnWidth:CGFloat = (MAIN_WIDTH - 20 - 7*2)/10
        gameBackView.backgroundColor = UIColor.clearColor()
        self.view .addSubview(gameBackView)
        gameBackView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(110)
            make.left.right.equalTo(self.view).offset(10)
            make.height.equalTo(MAIN_WIDTH-20)
        }
        
        //获取10位随机数组
        
        
        for index in 0 ..< LEVEL_ONE {
            
            for indexY in 0..<LEVEL_ONE {
                
                let button = YLButton()
                
                button.buttonStatue = 0
                button.tag = 10*index+indexY+200;
            
                button.setBackgroundImage(UIImage(named: "game_mine_default"), forState: .Normal)
                self.gameBackView.addSubview(button)
                let height = CGFloat(index)*(btnWidth+2)
                button.snp_makeConstraints(closure: { (make) in
                     make.top.equalTo(self.gameBackView.snp_top).offset(height)
                     make.height.width.equalTo(btnWidth)
                     make.left.equalTo(CGFloat(indexY)*(btnWidth+2))
                })
                
            }
            
        }
        
        
    
        
    }
    
    func leftBomeChanged(leftBome:Int) -> NSMutableAttributedString {
        
        let text = "老婆加油！还有\(leftBome)颗地雷没被发现"
        let highlightText = "\(leftBome)"
        
       // let hightlightTextRange = text.rangeOfString(highlightText as String) as! NSRange
        let attributeStr = NSMutableAttributedString.init(string: text as String)
        let greencolor = UIColor.init(red: 72/255.0, green: 143/255.0, blue: 19/255.0, alpha: 1)
        attributeStr.addAttribute(NSBackgroundColorAttributeName, value: greencolor, range: NSMakeRange(7, highlightText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        
        return attributeStr

        
    }
    
    func timeGo(){
        time = time! + 1
        
        if time > 9999 {
            time = 9999
            timer.invalidate()
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
