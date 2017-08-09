//
//  GPCellViews.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class semester_cell:UICollectionViewCell {
    
    var name:GPLabel = GPLabel()
    var gpa:GPLabel = GPLabel()
    
    fileprivate lazy var stack:GPStackView = {
        let s = GPStackView(arrangedSubviews: [self.name, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    
    var exists:Bool = false

    
    
    override func awakeFromNib() {
        name.backgroundColor = .clear
        gpa.backgroundColor = .clear
        if !exists {
            contentView.addSubview(stack)
            stack_cons = [
                stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.3),
                gpa.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.7),
                ])
            exists = true
        }
    }
    override func prepareForReuse() {
        
    }
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}


class class_cell:UICollectionViewCell {
    
    var name:GPLabel = GPLabel()
    var grade:GPLabel = GPLabel()
    var hours:GPLabel = GPLabel()
    var gpa:GPLabel = GPLabel()
    

    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.grade, self.hours, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        return s
    }()
    
    fileprivate lazy var stack1:GPStackView = {
        let s = GPStackView(arrangedSubviews: [self.name, self.stack])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var stack1_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var name_cons:[NSLayoutConstraint]!
    var exists:Bool = false

    
    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        name.backgroundColor = .clear
        grade.backgroundColor = .clear
        hours.backgroundColor = .clear
        gpa.backgroundColor = .clear

        if !exists {
            contentView.addSubview(stack1)
            
            stack1_cons = [
                stack1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                stack1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                stack1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                stack1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
            
            NSLayoutConstraint.activate(stack1_cons)


            NSLayoutConstraint.activate([
                grade.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                hours.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                gpa.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                ])
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack1.heightAnchor, multiplier: 0.5),
                stack.heightAnchor.constraint(equalTo: stack1.heightAnchor, multiplier: 0.5),
      
                ])

            exists = true
            
        }
        
    }
    
    override func prepareForReuse() {
        
    }
}


class CVHeader:UICollectionReusableView {
    
    var backBtn = UIButton(type: .custom)
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.backBtn])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    
    var stack_cons:[NSLayoutConstraint]!
    var active:Bool = false
    override func awakeFromNib() {
        backBtn.setFAIcon(icon: FAType.FAArrowLeft, forState: .normal)
        //        backBtn.setTitleColor(UIColor.white, for: .normal)
        
        if !active {
            active = true
            addSubview(stack)
            stack_cons = stack.getConstraintsOfView(to: self)
            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                
                backBtn.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 1),
                
                ])
        }
    }
    
    override func prepareForReuse() {
        
    }
}

class CVFooter:UICollectionReusableView {
    
    var plus_button:UIButton = UIButton()
    var minus_button:UIButton = UIButton()
    
    var active:Bool = false
    
    override func awakeFromNib() {
        if !active {
            plus_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            plus_button.setFAIcon(icon: FAType.FAPlus, forState: .normal)
            let plus = UIBarButtonItem(customView: plus_button)
            
            minus_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            minus_button.setFAIcon(icon: FAType.FAMinus, forState: .normal)
            let minus = UIBarButtonItem(customView: minus_button)
            
            let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            

            
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackOpaque
            toolbar.layer.cornerRadius = 12
            toolbar.layer.masksToBounds = true
//            toolbar.setBackgroundImage(UIImage(),
//                                            forToolbarPosition: .any,
//                                            barMetrics: .default)
//            toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            toolbar.setItems([plus, flexspace, minus], animated: true)
            self.addSubview(toolbar)
            
//            NSLayoutConstraint.activate(toolbar.getConstraintsOfView(to: self))
            NSLayoutConstraint.activate([
                toolbar.topAnchor.constraint(equalTo: self.topAnchor),
                toolbar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                toolbar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
                toolbar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30)
            ])
        }
    }
    
    override func prepareForReuse() {
        
    }
}



class GPStackView:UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        phaseTwo()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var layerColors:[CGColor] {
        set {
            if let laya = self.layer as? CAGradientLayer {
                laya.colors = newValue
                laya.locations = [0.0, 1.20]
            }
        }
        get {
            return [ UIColor(rgb: 0x82D15C).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        }
    }
    
    func phaseTwo() {
        if let laya = self.layer as? CAGradientLayer {
            laya.colors = [ UIColor(rgb: 0x82D15C).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
            laya.locations = [0.0, 1.20]
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.addDropShadowToView()
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

class MaxView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        phaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func phaseTwo() {
        if let laya = self.layer as? CAGradientLayer {
            laya.colors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
            laya.locations = [0.0, 1.20]
        }
        self.addDropShadowToView()
    }
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

