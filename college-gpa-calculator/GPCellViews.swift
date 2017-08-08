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
    
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.name, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    
    var exists:Bool = false
    
    override func awakeFromNib() {
        
        if !exists {
            contentView.addSubview(stack)
            stack_cons = stack.getConstraintsOfView(to: self.contentView)
            NSLayoutConstraint.activate(stack_cons)
            //            stack_cons = [
            //                stack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            //                stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //                stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            //                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            //            ]
            //            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.3),
                gpa.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.7),
                ])
            exists = true
            stack.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    override func prepareForReuse() {
        
    }
}


class class_cell:UICollectionViewCell {
    
    var name:GPLabel = GPLabel()
    var grade:GPLabel = GPLabel()
    var hours:GPLabel = GPLabel()
    var gpa:GPLabel = GPLabel()
    
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.name, self.grade, self.hours, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    var exists:Bool = false
    
    override func awakeFromNib() {
        if !exists {
            contentView.addSubview(stack)
            stack_cons = stack.getConstraintsOfView(to: self.contentView)
            NSLayoutConstraint.activate(stack_cons)
            //
            //            stack_cons = [
            //                stack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            //                stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //                stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            //                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            //            ]
            //            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
                grade.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
                hours.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
                gpa.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
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

