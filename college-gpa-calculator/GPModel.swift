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

    var selected_semester_index:Int = 0
    var semesters:[semester] = [
        semester(name: "FALL 17", gpa: "3.6", classes: [ semester_class(name: "Algorithms", grade: "A", hours: 3, gpa: "4.0"), semester_class(name: "Comp Organization", grade: "B+", hours: 3, gpa: "3.20")]),
        semester(name: "SPRING 17", gpa: "3.14", classes: [semester_class(name: "Math", grade: "A+", hours: 5, gpa: "3.6"), semester_class(name: "English", grade: "A-", hours: 3, gpa: "4.00"),semester_class(name: "Math", grade: "A+", hours: 5, gpa: "3.6"), semester_class(name: "English", grade: "A-", hours: 3, gpa: "4.00")])
    ]
}

struct semester {
    var name:String!
    var gpa:String!
    var classes:[semester_class] = []
}

struct semester_class {
    var name:String!
    var grade:String!
    var hours:CGFloat!
    var gpa:String!
    
    init(name: String, grade: String, hours:CGFloat, gpa:String) {
        self.name = name
        self.grade = grade
        self.hours = hours
        self.gpa = String(describing: calculate_class_gpa(grade: grade, hour: hours))
    }
}

let letters:[String:CGFloat] = [
    "A+":4.0,
    "A":4.0,
    "A-":3.7,
    "B+":3.33,
    "B":3.00,
    "B-":2.7,
    "C+":2.3,
    "C":2.0,
    "C-":1.7,
    "D+":1.3,
    "D":1.0,
    "D-":0.70,
    "F":0]

func calculate_class_gpa(grade:String, hour:CGFloat) -> CGFloat {
    let grade_value:CGFloat = letters[grade]!
//    let points = grade_value * hour
//    let gpa = points/hour
//    return gpa
    return grade_value
}
    
