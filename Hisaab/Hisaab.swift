//
//  ViewController.swift
//  Hisaab
//
//  Created by Anas Ahmed on 5/7/18.
//  Copyright © 2018 Anas Ahmad. All rights reserved.
//

import UIKit

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct calc {
    var Numbers: NSMutableArray = []
    var Symbols: [Int] = []
    var ActiveNumber: Float? = 0
    var DecimalPressed: Bool? = false
    var DecimalPower: Float? = 1
    var name: String?
}

class Hisaab: UIViewController, UIScrollViewDelegate {

    var Hisaabs: [calc]! = [calc.init(), calc.init(), calc.init()] //end goal
    
    var Hisaab1: calc!
    var Hisaab2: calc!
    
    var MainHisaab: calc!
    
    var ScreenWidth: CGFloat!
    var ScreenHeight: CGFloat!
        
    @IBOutlet var TheScrollView: UIScrollView!
    @IBOutlet var ClearButton: UIButton!
    @IBOutlet var MainStack: UIStackView!
   
    var TopStack:MyStack!
    var TopStack2:MyStack!
    var ActiveStack:MyStack!
    
    var Scroller:UIScrollView!
    
    @IBAction func Number(_ sender: Any) {
    
        //all numbers invoke this function
        
//        NSLog(String(TheScrollView.contentOffset.debugDescription))

        
        let n = ((sender as! UIButton).tag as Int)
        
        ActiveStack.CView!.text = ActiveStack.CView!.text + String(n)
        
        if !MainHisaab.DecimalPressed!
        {
            MainHisaab.ActiveNumber = Float(n) + MainHisaab.ActiveNumber! * 10
        }
        
        else
        {
            MainHisaab.ActiveNumber = MainHisaab.ActiveNumber! + Float(n) * 1/MainHisaab.DecimalPower!
            MainHisaab.DecimalPower = MainHisaab.DecimalPower! * 10
        }
        
    }
    
    //10 => ÷ -- 11 => x -- 12 => + -- 13 => -
    
    @IBAction func Symbol(_ sender: Any) {
        
        let s = (sender as! UIButton).tag
        
        if(!MainHisaab.ActiveNumber!.isNaN)
        {
            MainHisaab.Numbers.add(NSNumber(value: MainHisaab.ActiveNumber!))
        }
        
        MainHisaab.Symbols.append(s)
        
        switch s {
        case 10:
            ActiveStack.CView!.text = ActiveStack.CView!.text + " ÷ "
            MainHisaab.ActiveNumber = 0.0
        case 11:
            ActiveStack.CView!.text = ActiveStack.CView!.text + " x "
            MainHisaab.ActiveNumber = 0.0
        case 12:
            ActiveStack.CView!.text = ActiveStack.CView!.text + " + "
            MainHisaab.ActiveNumber = 0.0
        case 13:
            ActiveStack.CView!.text = ActiveStack.CView!.text + " - "
            MainHisaab.ActiveNumber = 0.0
        case 14:
            ActiveStack.CView!.text = ActiveStack.CView!.text + " % "
            MainHisaab.Numbers[MainHisaab.Numbers.count - 1] = (MainHisaab.Numbers[MainHisaab.Numbers.count - 1] as! NSNumber).floatValue * 100
            MainHisaab.ActiveNumber = 0.0
        case 15:
            ActiveStack.CView!.text = ActiveStack.CView!.text + "√ "
        case 16:
            ActiveStack.CView!.text = ActiveStack.CView!.text + "² "
        default:
            break
        }
        
        MainHisaab.DecimalPower = 1
        MainHisaab.DecimalPressed = false
    }
    
    @IBAction func Equals(_ sender: Any) {
        
        if(!MainHisaab.ActiveNumber!.isNaN)
        {
            MainHisaab.Numbers.add(NSNumber(value: MainHisaab.ActiveNumber!))
        }
        
        MainHisaab.DecimalPower = 1
        MainHisaab.DecimalPressed = false
        
        
        let r = Evaluate()
        
        if(r.isNaN)
        {
            ActiveStack.RView?.text = "Incorrect Equation"
        }
            
        else if r.isInfinite
        {
            ActiveStack.RView?.text = "∞"
            MainHisaab.ActiveNumber = 0.0
            
            ActiveStack.CView!.text = String(0)
        }
        
        else
        {
            ActiveStack.RView!.text = String(r.cleanValue)
            MainHisaab.ActiveNumber = r
            
            ActiveStack.CView!.text = String(r.cleanValue)
        }
        
    }
    
    @IBAction func Decimal(_ sender: Any) {
        
        if !MainHisaab.DecimalPressed!
        {
            ActiveStack.CView!.text = ActiveStack.CView!.text + "."
            
            MainHisaab.DecimalPressed = true
            MainHisaab.DecimalPower = 10
        }
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        
        if(sender.currentTitle == "Clear")
        {
            sender.setTitle("Sure?", for: .normal)
            sender.backgroundColor = .orange
        }
        
        else
        {
            ActiveStack.RView!.text = ""
            ActiveStack.CView!.text = ""
            MainHisaab.Numbers.removeAllObjects()
            MainHisaab.Symbols.removeAll()
            
            MainHisaab.ActiveNumber = 0
            MainHisaab.DecimalPower = 1
            MainHisaab.DecimalPressed = false
            
            sender.setTitle("Clear", for: .normal)
            sender.backgroundColor = .red
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        NSLog((String(scrollView.contentOffset.x.description) + " - " + String(self.view.frame.size.width.description)))
        
        if(scrollView.contentOffset.x >= self.view.frame.size.width - 20)
        {
            if(MainHisaab.name == Hisaab1.name)
            {
                Hisaab1 = MainHisaab
                MainHisaab = Hisaab2
                ActiveStack = TopStack2!
            }
        }
        
        else if(scrollView.contentOffset.x == 0)
        {
            if(MainHisaab.name == Hisaab2.name)
            {
                Hisaab2 = MainHisaab
                MainHisaab = Hisaab1
                ActiveStack = TopStack!
            }
        }
        
    }
    
    func Evaluate() -> Float
    {
        
        if(MainHisaab.Numbers.count != MainHisaab.Symbols.count + 1)
        {
            let r = Float.nan
            return r
        }
        
        var x: Float?
        
        for i in MainHisaab.Symbols
        {
            let index = MainHisaab.Symbols.index(of: i)
            
            if (MainHisaab.Symbols[index!]) == 15
            {
                x = sqrtf((MainHisaab.Numbers[index! + 1] as! NSNumber).floatValue)
                MainHisaab.Numbers.removeObject(at: index! + 1)
                
                if((MainHisaab.Numbers[index!] as! NSNumber).floatValue == 0)
                {
                    MainHisaab.Numbers.replaceObject(at: index!, with: x!)
                }
                    
                else
                {
                    MainHisaab.Numbers.replaceObject(at: index!, with: x! + (MainHisaab.Numbers[index!] as! NSNumber).floatValue)
                }
                
                MainHisaab.Symbols.remove(at: index!)
            }
            
        }
        
        for i in MainHisaab.Symbols
        {
            let index = MainHisaab.Symbols.index(of: i)
            
            if (MainHisaab.Symbols[index!]) == 10 || (MainHisaab.Symbols[index!]) == 14
            {
                let x = (MainHisaab.Numbers[index!] as! NSNumber).floatValue / (MainHisaab.Numbers[index!+1] as! NSNumber).floatValue
                MainHisaab.Numbers.removeObject(at: index!+1)
                MainHisaab.Numbers.replaceObject(at: index!, with: x)
                MainHisaab.Symbols.remove(at: index!)
                
            }
        }
    
    
    
        for i in MainHisaab.Symbols
        {
            let index = MainHisaab.Symbols.index(of: i)
            
            if (MainHisaab.Symbols[index!]) == 11 || (MainHisaab.Symbols[index!]) == 16
            {
                x = (MainHisaab.Numbers[index!] as! NSNumber).floatValue * (MainHisaab.Numbers[index!+1] as! NSNumber).floatValue
                MainHisaab.Numbers.removeObject(at: index!+1)
                MainHisaab.Numbers.replaceObject(at: index!, with: x!)

                MainHisaab.Symbols.remove(at: index!)

            }
        }
    
        
        for i in MainHisaab.Symbols
        {
            let index = MainHisaab.Symbols.index(of: i)

            if((MainHisaab.Symbols[index!]) == 12 || (MainHisaab.Symbols[index!]) == 13)
            {
                if (MainHisaab.Symbols[index!]) == 12
                {
                    x = (MainHisaab.Numbers[index!] as! NSNumber).floatValue + (MainHisaab.Numbers[index!+1] as! NSNumber).floatValue
                    
                }
                
                else if (MainHisaab.Symbols[index!]) == 13
                {
                    x = (MainHisaab.Numbers[index!] as! NSNumber).floatValue - (MainHisaab.Numbers[index!+1] as! NSNumber).floatValue
                }
                
                MainHisaab.Numbers.removeObject(at: index!+1)
                MainHisaab.Numbers.replaceObject(at: index!, with: x ?? 0)
                
                MainHisaab.Symbols.remove(at: index!)
            }
        }
        
        
        let result = (MainHisaab.Numbers.object(at: 0) as! NSNumber).floatValue
        
        MainHisaab.Numbers.removeAllObjects()
        
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog(MainStack.frame.width.description + " - " + view.frame.width.description)
        
        ScreenWidth = MainStack.frame.width
        ScreenHeight = MainStack.frame.height
        
        Hisaab1 = calc.init()
        Hisaab2 = calc.init()
        
        Hisaab1.name = "1"
        Hisaab2.name = "2"
        
        MainHisaab = calc.init()
        MainHisaab.name = "1"
        
//        Testing()
        
        if UIDevice.current.orientation.isPortrait || UIApplication.shared.statusBarOrientation.isPortrait
        {
            TheScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - (view.frame.size.width * 0.05), height: ScreenHeight * 0.45)
            TheScrollView.heightAnchor.constraint(equalToConstant: ScreenHeight * 0.45).isActive = true
            
            NSLog(TheScrollView.frame.debugDescription)
            

            TopStack = MyStack.init(frame: CGRect(x: TheScrollView.frame.size.width * 0.025, y: 0, width: TheScrollView.frame.size.width - (TheScrollView.frame.size.width * 0.05), height: TheScrollView.frame.size.height))
            
            TopStack2 = MyStack.init(frame: CGRect(x: TheScrollView.frame.size.width + (TheScrollView.frame.size.width * 0.025), y: 0, width: TheScrollView.frame.size.width - (TheScrollView.frame.size.width * 0.05), height: TheScrollView.frame.size.height))
            
            TheScrollView.contentSize = CGSize(width: (TheScrollView.frame.width)*2, height: ScreenHeight * 0.35)
            
        }
        
        else if UIDevice.current.orientation.isLandscape || UIApplication.shared.statusBarOrientation.isLandscape
        {
            
            NSLog(ScreenHeight.description + " - " + UIScreen.main.bounds.width.description)
            
            TheScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ScreenWidth * 0.35)
            TheScrollView.heightAnchor.constraint(equalToConstant: ScreenWidth * 0.35).isActive = true
            
            
            TopStack = MyStack.init(frame: CGRect(x: 0, y: 0, width: TheScrollView.frame.size.width, height: TheScrollView.frame.size.height))
            
            TopStack2 = MyStack.init(frame: CGRect(x: TheScrollView.frame.size.width, y: 0, width: TheScrollView.frame.size.width, height: TheScrollView.frame.size.height))
            
            TheScrollView.contentSize = CGSize(width: TheScrollView.frame.size.width * 2, height: ScreenHeight * 0.35)
            
        }
        

        TheScrollView.delegate = self

        TheScrollView.backgroundColor = .black
        
        ClearButton.setTitle("Clear", for: .normal)
        
        TheScrollView.addSubview(TopStack)
        TheScrollView.addSubview(TopStack2)
        
        ActiveStack = TopStack!
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            if UIDevice.current.orientation.isPortrait
            {
                NSLog(MainStack.frame.width.description + " - " + MainStack.frame.height.description)
                
                TheScrollView.frame = CGRect(x: ScreenWidth * 0.025, y: 0, width: ScreenWidth - (ScreenWidth * 0.05), height: ScreenHeight * 0.35)
                TheScrollView.contentSize = CGSize(width: TheScrollView.frame.size.width * 2, height: TheScrollView.frame.size.height * 0.35)
                
                ActiveStack.update(F: TheScrollView.frame)
                
                //TheScrollView.removeConstraint(TheScrollView.constraints[0])
                TheScrollView.clearConstraints()
                TheScrollView.heightAnchor.constraint(equalToConstant: ScreenHeight * 0.35).isActive = true
            }
            
            else if UIDevice.current.orientation.isLandscape
            {
                NSLog(MainStack.frame.width.description + " - " + MainStack.frame.height.description)

                TheScrollView.frame = CGRect(x: 0, y: 0, width: ScreenHeight, height: ScreenWidth * 0.35)
                TheScrollView.contentSize = CGSize(width: TheScrollView.frame.size.width * 2, height: TheScrollView.frame.size.height * 0.35)
                
                ActiveStack.update(F: TheScrollView.frame)
                
                TheScrollView.clearConstraints()
//                TheScrollView.removeConstraint(TheScrollView.constraints[0])
                TheScrollView.heightAnchor.constraint(equalToConstant: ScreenWidth * 0.35).isActive = true
            }
    }
    
    class MyStack: UIStackView {
        
        var RView: UITextView?
        var CView: UITextView?
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
    
            
            if UIApplication.shared.statusBarOrientation.isPortrait
            {
                RView = UITextView.init(frame: CGRect(x: 0, y: frame.size.width * 0.025, width: frame.size.width, height: frame.size.height * 0.4))
                CView = UITextView.init(frame: CGRect(x: 0, y: (frame.size.height * 0.40) + frame.size.width * 0.05, width: frame.size.width, height: frame.size.height * 0.45))
            }
            
            else
            {
                RView = UITextView.init(frame: CGRect(x: 0, y: frame.size.height * 0.05, width: frame.size.width * 0.5, height: frame.size.height * 0.9))
                CView = UITextView.init(frame: CGRect(x: frame.size.width * 0.55, y: (frame.size.height * 0.05), width: frame.size.width * 0.5, height: frame.size.height * 0.9))
            }
            
            RView?.backgroundColor = UIColor.lightGray
            CView?.backgroundColor = UIColor.gray
            
            RView?.font = UIFont(name:UIFont.familyNames[1], size: 40)
            CView?.font = UIFont(name:UIFont.familyNames[1], size: 20)
            
            RView?.textColor = .black
            
            CView!.textAlignment = .right
            RView!.textAlignment = .center
            
            self.addSubview(RView!)
            self.addSubview(CView!)
        }
        
        func update(F:CGRect)
        {
            if(UIDevice.current.orientation.isPortrait)
            {
                RView?.frame = CGRect(x: 0, y: F.size.width * 0.025, width: F.size.width, height: F.size.height * 0.4)
                CView?.frame = CGRect(x: 0, y: (F.size.height * 0.40) + F.size.width * 0.05, width: F.size.width, height: F.size.height * 0.45)
            }
            
            else if UIDevice.current.orientation.isLandscape
            {
                RView?.frame = CGRect(x: 0, y: F.size.height * 0.05, width: F.size.width * 0.5, height: F.size.height * 0.9)
                CView?.frame = CGRect(x: F.size.width * 0.55, y: (F.size.height * 0.05), width: F.size.width * 0.5, height: F.size.height * 0.9)
            }
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func Testing()
    {
        var c = 0
        
        for _ in 0...1000
        {
            let n1 = Float(arc4random_uniform(99) + 1)
            let n2 = Float(arc4random_uniform(99) + 1)
            let n3 = Float(arc4random_uniform(99) + 1)
            let n4 = Float(arc4random_uniform(99) + 1)
            let n5 = Float(arc4random_uniform(99) + 1)
            var r:Float?
            
            
            MainHisaab.Numbers = [n1,n2,n3,n4,n5]
            MainHisaab.Symbols = [11,13,10,12]
            
            r = (n1 * n2) - (n3/n4) + n5
            let e = Evaluate()
            
            if(e != r)
            {
                NSLog(String(e) + " != " + String(r!))
            }
            
            else
            {
                c = c + 1
                NSLog("=")
            }
            
        }
        NSLog(String(c))
    }

}

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
