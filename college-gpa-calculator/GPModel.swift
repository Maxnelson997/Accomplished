//
//  GPModel.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import CoreData


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

    var class_is_being_edited:Bool = false
    var class_being_edited:Int = 0
    var class_object_to_edit:semester_class!
    var selected_semester_index:Int = 0
    var semesters:[semester] = [
//        semester(name: "FALL 17", gpa: "3.6", classes: [ semester_class(name: "Algorithms", grade: "A", hours: 3, gpa: "4.0"), semester_class(name: "Comp Organization", grade: "B+", hours: 3, gpa: "3.20")]),
//        semester(name: "SPRING 17", gpa: "3.14", classes: [semester_class(name: "Math", grade: "A+", hours: 5, gpa: "3.6"), semester_class(name: "English", grade: "A-", hours: 3, gpa: "4.00"),semester_class(name: "Math", grade: "A+", hours: 5, gpa: "3.6"), semester_class(name: "English", grade: "A-", hours: 3, gpa: "4.00")])
    ]
    
    var context:NSManagedObjectContext!
    
    func get_semesters_coredata() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Semesters")
        request.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(request)
            if results.count != 0 {
                //there is data previously saved
                for result in results as! [NSManagedObject]{
                    //snatch the semesters array
                    if let count = result.value(forKey: "semester") as? Data {
                        print("semester retrieved: \(count)")
                        if let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: count) as? NSArray {
                            //extract data
                            for semester_data in mySavedData {
                                let sem = semester.unarchive(data: semester_data as! Data)
                                semesters.append(sem)
                            }
                        }
                        
                        
                        
                    }
                }
            } else {
                print("count not saved in Core Data")
            }
        }
        catch
        {
            print("hmm error retreiving image count")
        }
    }
        var CoreDataSemestersArray = NSMutableArray()
    
    
    func save_semesters_coredata() {
        var image_count_coredata:NSManagedObject!
        
        //check if count exists
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Semesters")
        
        request.returnsObjectsAsFaults = false
        if let results = try? context.fetch(request) {
            
            if results.count != 0 {
                //a count exists
                image_count_coredata = results.first as! NSManagedObject
            } else {
                //create a count
                image_count_coredata = NSEntityDescription.insertNewObject(forEntityName: "Semesters", into: context)
            }
        } else {
            //failed
            print("hmm failed?")
        }
        for sem in semesters {
            let data:NSData = NSData(data: semester.archive(structure: sem))
            CoreDataSemestersArray.add(data)
        }
        let coreDataObject = NSKeyedArchiver.archivedData(withRootObject: CoreDataSemestersArray)
        image_count_coredata.setValue(coreDataObject, forKey: "semester")
        //store new count
        
        do
        {
            try context.save()
            print("image count saved in Core Data model: \(String(describing: image_count_coredata.value(forKey: "image")!))")
        }
        catch
        {
            print("hmm error saving credentials")
        }
        //                appDelegate.saveContext()
    }
    
}

struct semester {
    var name:String!
    var gpa:String!
    var classes:[semester_class] = []
    
    //convert Data to semester struct
    static func unarchive(data: Data) -> semester {
        guard data.count == MemoryLayout<semester>.stride else {
            fatalError("hmmm looks like we got an error!!!!!!!!!")
        }
        
        var w:semester?
        data.withUnsafeBytes({(bytes: UnsafePointer<semester>) -> Void in
            w = UnsafePointer<semester>(bytes).pointee
        })
        return w!
    }
    
    //convert semester struct to Data
    static func archive(structure:semester) -> Data {
        var fw = structure
        return Data(bytes: &fw, count: MemoryLayout<semester>.stride)
    }
    
    init() {
        //nothin
    }
    
    init(name:String, gpa:String, classes:[semester_class]) {
        self.name = name
        self.gpa = gpa
        self.classes = classes
    }
}

struct semester_class {
    var name:String!
    var grade:String!
    var hours:Int!
    var gpa:String!
    

    
    init(name: String, grade: String, hours:Int, gpa:String) {
        self.name = name
        self.grade = grade
        self.hours = hours
        self.gpa = String(describing: calculate_class_gpa(grade: grade, hour: Double(hours)))
    }
}

let letters:[String:Double] = [
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

func calculate_class_gpa(grade:String, hour:Double) -> Double {
    let grade_value:Double = letters[grade]!
//    let points = grade_value * hour
//    let gpa = points/hour
//    return gpa
    return grade_value
}
    
