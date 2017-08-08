//
//  GPModel.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

extension UIView {
    func getConstraintsOfView(to: UIView) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: to.leftAnchor),
            self.rightAnchor.constraint(equalTo: to.rightAnchor),
            self.bottomAnchor.constraint(equalTo: to.bottomAnchor),
            self.topAnchor.constraint(equalTo: to.topAnchor)
        ]
    }
}

class GPModel {
    static let sharedInstance = GPModel()
    private init() {}
    
    var selected_semester_index:Int!
    var semesters:[semester]!
    
}


struct semester {
    var name:String!
    var gpa:String!
    var classes:[semester_class]!
}

struct semester_class {
    var name:String!
    var grade:String!
    var hours:CGFloat!
    var gpa:String!
}

class semester_cell:UICollectionViewCell {
    
    var name:GPLabel!
    var gpa:GPLabel!
    
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.name, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    
    var exists:Bool = false
    
    override func awakeFromNib() {
        if !exists {
            stack_cons = stack.getConstraintsOfView(to: self)
            NSLayoutConstraint.activate(stack_cons)
            
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.3),
                gpa.heightAnchor.constraint(equalTo: gpa.heightAnchor, multiplier: 0.7),
                ])
            exists = true
        }
    }
    override func prepareForReuse() {
        
    }
}


class class_cell:UICollectionViewCell {
    
    var name:GPLabel!
    var grade:GPLabel!
    var hours:GPLabel!
    var gpa:GPLabel!
    
    fileprivate lazy var stack:UIStackView = {
       let s = UIStackView(arrangedSubviews: [self.name, self.grade, self.hours, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    var exists:Bool = false
    
    override func awakeFromNib() {
        if !exists {
            stack_cons = stack.getConstraintsOfView(to: self)
            NSLayoutConstraint.activate(stack_cons)
            
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
                grade.heightAnchor.constraint(equalTo: grade.heightAnchor, multiplier: 0.25),
                hours.heightAnchor.constraint(equalTo: hours.heightAnchor, multiplier: 0.25),
                gpa.heightAnchor.constraint(equalTo: gpa.heightAnchor, multiplier: 0.25),
                ])
            exists = true
        }

    }
    
    override func prepareForReuse() {
        
    }
}
