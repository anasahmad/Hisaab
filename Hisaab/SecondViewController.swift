//
//  SecondViewController.swift
//  Hisaab
//
//  Created by Anas Ahmed on 5/20/18.
//  Copyright © 2018 Anas Ahmad. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var SecondStack: UIStackView!
    var Numbers: [UIButton] = [UIButton.init()]
    var HorizontalStacks: [UIStackView] = [UIStackView.init(), UIStackView.init()]

    var one: UIButton!
    var two: UIButton!
    var three: UIButton!
    var four: UIButton!
    
    var first: UIStackView!
    var second: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        one = UIButton.init()
        one.titleLabel?.text = "1"
        one.backgroundColor = .red
        
        two = UIButton.init()
        two.titleLabel?.text = "2"
        two.backgroundColor = .blue
        
        three = UIButton.init()
        three.titleLabel?.text = "3"
        three.backgroundColor = .brown
        
        four = UIButton.init()
        four.titleLabel?.text = "4"
        four.backgroundColor = .black
        
        first = UIStackView.init(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        first.axis = UILayoutConstraintAxis.vertical
        first.distribution = UIStackViewDistribution.equalSpacing
        
        second = UIStackView.init()
        second.axis = UILayoutConstraintAxis.vertical
        second.distribution = UIStackViewDistribution.equalSpacing
        
        first.addArrangedSubview(one)
        first.addArrangedSubview(two)
        
        second.addArrangedSubview(three)
        second.addArrangedSubview(four)
        
        SecondStack.addArrangedSubview(first)
        SecondStack.addArrangedSubview(second)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
