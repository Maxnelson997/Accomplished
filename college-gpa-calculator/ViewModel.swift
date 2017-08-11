//
//  ViewModel.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/10/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class ViewModel {
    let model = GPModel.sharedInstance
    
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
        let gpa = grade_value/hour
        return gpa
    }
    
    func calculate_semester_gpa() -> CGFloat {
        
        let classes = model.semesters[model.selected_semester_index].classes
        var points:CGFloat = 0.0
        var hours_attempted:CGFloat = 0.0
        var grade_points = classes.map { letters[$0.grade]! }
        var hours = classes.map { $0.hours! }
        _ = classes.map { hours_attempted += $0.hours! }
        for i in 0 ..< grade_points.count {
            points += grade_points[i] * hours[i]
        }
        print("\npoints \(points)")
        print("hours attempted: \(hours_attempted)\n")
        let gpa = points / hours_attempted
        return gpa
    }
    
    func calculate_all_semester_gpa() -> CGFloat {
        var points:CGFloat = 0.0
        var hours_attempted:CGFloat = 0.0
        for i in 0 ..< model.semesters.count {
            let classes = model.semesters[i].classes
            var grade_points = classes.map { letters[$0.grade]! }
            var hours = classes.map { $0.hours! }
            _ = classes.map { hours_attempted += $0.hours! }
            for i in 0 ..< grade_points.count {
                points += grade_points[i] * hours[i]
            }
        }
        print("\npoints \(points)")
        print("hours attempted: \(hours_attempted)\n")
        let gpa = points / hours_attempted
        return gpa
    }
}
