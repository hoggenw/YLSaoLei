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
    var ifSign = false
    var upArray = [YLButton]()
    var downArray = [YLButton]()
    var leftArray = [YLButton]()
    var rightArray = [YLButton]()
    
    var leftCount:Int? {
        didSet {
            if successJudge() {
                let alertContr = UIAlertController(title: "胜利！胜利！", message: "老婆真是太厉害了！", preferredStyle: .Alert)
                let cancelButton = UIAlertAction(title: "本宫知道了", style: .Cancel, handler: nil)
                let playAgainButton = UIAlertAction(title: "再来一把", style: .Default, handler: { (UIAlertAction) in
                    self.refreshButtonAction()
                })
                alertContr.addAction(cancelButton)
                alertContr.addAction(playAgainButton)
                self.presentViewController(alertContr, animated: true, completion: nil)
            }
        }
    }
    
    
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
            if successJudge() {
                let alertContr = UIAlertController(title: "胜利！胜利！", message: "老婆真是太厉害了！", preferredStyle: .Alert)
                let cancelButton = UIAlertAction(title: "本宫知道了", style: .Cancel, handler: nil)
                let playAgainButton = UIAlertAction(title: "再来一把", style: .Default, handler: { (UIAlertAction) in
                    self.refreshButtonAction()
                })
                alertContr.addAction(cancelButton)
                alertContr.addAction(playAgainButton)
                self.presentViewController(alertContr, animated: true, completion: nil)
            }
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
        setupGameView(false)
        
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
    
    //MARK:/*刷新**/
    func refreshButtonAction(){
        self.step = 0
        self.time = 0
        self.leftBome = LEVEL
        setupGameView(true)
    }
    //标记
    func signButtonAction(){
        
        ifSign = !ifSign
        
        
    }
    
    //创建游戏界面
    func setupGameView(ifRefresh:Bool){
        let btnWidth:CGFloat = (MAIN_WIDTH - 20 - 7*2)/10
        gameBackView.backgroundColor = UIColor.clearColor()
        self.view .addSubview(gameBackView)
        gameBackView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(110)
            make.left.right.equalTo(self.view).offset(10)
            make.height.equalTo(MAIN_WIDTH-20)
        }
        
       
        
        if ifRefresh == false {
            for index in 0 ..< LEVEL {
                
                for indexY in 0..<LEVEL {
                    
                    let button = YLButton()
                    
                    button.buttonStatue = 0
                    
                    button.ifMine = false
                    
                    button.showNumber = 0
                    
                    button.buttonIfSign = false
                    
                    button.tag = 10*index+indexY+200;
                    
                    // print("\(button.tag)\n")
                    
                    button.setBackgroundImage(UIImage(named: "game_mine_default"), forState: .Normal)
                    button.addTarget(self, action: #selector(buttonAction(_:)), forControlEvents: .TouchUpInside)
                    self.gameBackView.addSubview(button)
                    let height = CGFloat(index)*(btnWidth+2)
                    button.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(self.gameBackView.snp_top).offset(height)
                        make.height.width.equalTo(btnWidth)
                        make.left.equalTo(CGFloat(indexY)*(btnWidth+2))
                    })
                    
                }
                
            }
            
        }else {
            for index in 0 ..< LEVEL {
                
                for indexY in 0..<LEVEL {
                    
                    let button = self.gameBackView.viewWithTag(Int((10*index+indexY+200) as NSNumber)) as! YLButton
                    
                    
                    button.buttonStatue = 0
                    
                    button.ifMine = false
                    
                    button.buttonIfSign = false
                    
                    button.showNumber = 0

                    button.setImage(UIImage(named: ""), forState: .Normal)
                    
                    button.setBackgroundImage(UIImage(named: "game_mine_default"), forState: .Normal)

                    
                }
                
            }
        }

        let randomNumbers = randomNumber();
        
        print("randomNumbers.count=\(randomNumbers.count)")
        
        
        for index in randomNumbers {
            let button = self.gameBackView.viewWithTag(Int(index as! NSNumber)) as! YLButton
            button.ifMine = true;
            
        }

        
        //获取周边地雷数量
        
        for index in 0..<100 {
            
            let nowButton = self.gameBackView.viewWithTag(index+200) as! YLButton
            
            if nowButton.ifMine == true {
                continue
            }
            //中间2个
            let midLeft = index % 10 - 1
            if midLeft >= 0 {
                let button = self.gameBackView.viewWithTag(Int(index+200-1 as NSNumber)) as! YLButton
                if button.ifMine == true {
                    nowButton.showNumber? += 1
                    
                }
                
            }
            
            if (index+1)%10 != 0 {
                let button = self.gameBackView.viewWithTag(Int(index+200+1 as NSNumber)) as! YLButton
                if button.ifMine == true {
                    nowButton.showNumber? += 1
                    
                }
            }
            
            
            //上边3个
            let upMid = index-10;
            
            if upMid >= 0 {
                
                let button = self.gameBackView.viewWithTag(Int(upMid+200 as NSNumber)) as! YLButton
                if button.ifMine == true {
                    nowButton.showNumber? += 1
                    
                }
                
                if upMid%10-1 >= 0 {
                    let button = self.gameBackView.viewWithTag(Int(upMid+200-1 as NSNumber)) as! YLButton
                    if button.ifMine == true {
                        nowButton.showNumber? += 1
                        
                    }
                }
                
                if (upMid+1) % 10 != 0 {
                    
                    let button = self.gameBackView.viewWithTag(Int(upMid+200+1 as NSNumber)) as! YLButton
                    if button.ifMine == true {
                        nowButton.showNumber? += 1
                        
                    }
                }
                
                
            }
            
            //下边三个
            let downMid = index+10;
            
            if downMid <= 99 {
                
                let button = self.gameBackView.viewWithTag(Int(downMid+200 as NSNumber)) as! YLButton
                if button.ifMine == true {
                    nowButton.showNumber? += 1
                    
                }
                
                if downMid%10-1 >= 0 {
                    let button = self.gameBackView.viewWithTag(Int(downMid+200-1 as NSNumber)) as! YLButton
                    if button.ifMine == true {
                        nowButton.showNumber? += 1
                        
                    }
                }
                
                if (downMid+1) % 10 != 0 {
                    
                    let button = self.gameBackView.viewWithTag(Int(downMid+200+1 as NSNumber)) as! YLButton
                    if button.ifMine == true {
                        nowButton.showNumber? += 1
                        
                    }
                }
                
                
            }
            
            
            
            
            
        }
        
        
        
        
    }
    //200-299的10个不重复的随机数
    func randomNumber() -> NSArray {
        var randomNumbers = [Int]()
        
        while randomNumbers.count < 10 {
            let number = arc4random()%100 + 200
            var addBool = true
            
            for index in randomNumbers {
                if index == Int(number) {
                    addBool = false
                }
            }
            
            if addBool == true {
                randomNumbers.append(Int(number))
            }
            
            
        }
        
        return randomNumbers
        
    }
    
    //MARK:点击按钮
    func buttonAction(sender:YLButton){


        
        
        if ifSign {
            if sender.buttonStatue == 0  {
                
                if self.leftBome >= 0 {
                    if sender.buttonIfSign == true {
                        self.leftBome = leftBome!+1;
                        sender.buttonIfSign = false
                        sender.setImage(UIImage(named: ""), forState: .Normal)
                    }else {
                        if self.leftBome>0 {
                            
                            self.leftBome = self.leftBome!-1
                            sender.buttonIfSign = true
                            sender.setImage(UIImage(named: "game_mine_flag"), forState: .Normal)
                        }

                    }
                }
  

                return
            }
        }
        if sender.buttonIfSign == true {
            return
        }

        
        
        if sender.ifMine == true {
            let alertContr = UIAlertController(title: "踩到炸弹了", message: "没关系的，老婆加油！", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "悄悄离开", style: .Cancel, handler:  { (UIAlertAction) in
                self.navigationController?.popViewControllerAnimated(true)
            })
            let playAgainButton = UIAlertAction(title: "再来一把", style: .Default, handler: { (UIAlertAction) in
                self.refreshButtonAction()
            })
            alertContr.addAction(cancelButton)
            alertContr.addAction(playAgainButton)
            self.presentViewController(alertContr, animated: true, completion: nil)
        }
        
        if sender.buttonIfSign == false {
            if sender.buttonStatue == 0 {
                self.step = self.step! + 1;
            }
            
            buttonDeal(sender)
     
            
            //如果是空白
            if sender.showNumber == 0 && sender.ifMine == false {
                
                aroundButtonDeal(sender)
            }
            
            var leftMines = [YLButton]();
            
            leftMines.removeAll()
            for index in 0..<100 {
                let nowButton = self.gameBackView.viewWithTag(index+200) as! YLButton
                if nowButton.buttonStatue == 0 {
                    leftMines.append(nowButton);
                }
               // print("leftMines.count=\(leftMines.count)")
                if leftMines.count>=11 {
                    break;
                }
            }
            self.leftCount = leftMines.count
        }
        

        
    }
    //MARK:空白点击递归判断
    /**空白点击递归判断*/
    func aroundButtonDeal(sender:YLButton) {
        //中间2个
        let midLeft = sender.tag % 10 - 1
        if midLeft >= 0 {
            let button = self.gameBackView.viewWithTag(Int(sender.tag-1 as NSNumber)) as! YLButton
            if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
               buttonDeal(button)
                if button.showNumber == 0 {
                    aroundButtonDeal(button)
                }
                
            }
            
        }
        
        if (sender.tag+1)%10 != 0 {
            let button = self.gameBackView.viewWithTag(Int(sender.tag+1 as NSNumber)) as! YLButton
            if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                buttonDeal(button)
                if button.showNumber == 0 {
                    aroundButtonDeal(button)
                }
                
            }
        }

        //上边3个
        let upMid = Int(sender.tag)-200-10;
        
        if upMid >= 0 {
            
            let button = self.gameBackView.viewWithTag(Int(sender.tag-10 as NSNumber)) as! YLButton
            if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                buttonDeal(button)
                if button.showNumber == 0 {
                    aroundButtonDeal(button)
                }
                
            }
            
            if upMid%10-1 >= 0 {
                let button = self.gameBackView.viewWithTag(Int(sender.tag-10-1 as NSNumber)) as! YLButton
                
                if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                    buttonDeal(button)
                    if button.showNumber == 0 {
                        aroundButtonDeal(button)
                    }
                    
                }
            }
            
            if (upMid+1) % 10 != 0 {
                
                let button = self.gameBackView.viewWithTag(Int(sender.tag-10+1 as NSNumber)) as! YLButton
                if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                    buttonDeal(button)
                    if button.showNumber == 0 {
                        aroundButtonDeal(button)
                    }
                    
                }
            }
            
            
        }
        
        //下边三个
        let downMid = sender.tag-200+10;
        
        if downMid <= 99 {
            
            let button = self.gameBackView.viewWithTag(Int(sender.tag+10 as NSNumber)) as! YLButton
            
            if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                buttonDeal(button)
                if button.showNumber == 0 {
                    aroundButtonDeal(button)
                }
                
            }
            
            if downMid%10-1 >= 0 {
                let button = self.gameBackView.viewWithTag(Int(sender.tag+10-1 as NSNumber)) as! YLButton
                
                if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                    buttonDeal(button)
                    if button.showNumber == 0 {
                        aroundButtonDeal(button)
                    }
                    
                }
            }
            
            if (downMid+1) % 10 != 0 {
                
                let button = self.gameBackView.viewWithTag(Int(sender.tag+10+1 as NSNumber)) as! YLButton
                if button.ifMine != true && button.buttonStatue == 0 && button.buttonIfSign == false {
                    buttonDeal(button)
                    if button.showNumber == 0 {
                        aroundButtonDeal(button)
                    }
                    
                }
            }
    }
}
    

    //MARK:胜利条件
    
    func successJudge() ->Bool {
        
        if self.leftBome == 0 && self.leftCount==10 {
            return true;
        }
        return false;
    }
    
    
    //button处理
    
    func buttonDeal(sender:YLButton){
        if sender.buttonStatue == 0 {
            
            sender.buttonStatue = 1;
            sender.setBackgroundImage(UIImage(named: "game_mine_none_9"), forState: .Normal)
            
            
            if sender.ifMine == true {
                sender.setImage(UIImage(named: "game_dailog_mine"), forState: .Normal)
                
            }
            
            if sender.showNumber > 0 {
                sender.setImage(UIImage(named: String.init(format: "mine_number_%d", sender.showNumber!)), forState: .Normal)
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
