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
    
    func get_semesters_coredata(completion: @escaping () -> Void)  {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sems")
        request.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(request)
            print(results.count)
            if results.count != 0 {
                //there is data previously saved
                for result in results as! [Sems]{
                    //snatch the semesters array
                    print(result)
                    var retrieved_classes:[semester_class] = []
                    var retrieved_classes1:[semester_class] = []
                    let class_request = NSFetchRequest<NSFetchRequestResult>(entityName: "Classes")
                    class_request.returnsObjectsAsFaults = false
                    let class_results = try context.fetch(class_request)
                    print(class_results.count)
   
                    if class_results.count != 0 {
                        var count = 0
                
                        print(retrieved_classes.count)
                        for class_result in (class_results as! [Classes]) {
                            if count != Int(result.class_count) {
                                
                                var c = semester_class(name: class_result.name!, grade: class_result.grade!, hours: Int(class_result.hours), gpa: class_result.gpa!)
                                c.location = Int(class_result.location)
                                let n = Int(result.class_count - class_result.location)
                                print("class_rsult location: \(class_result.location)")
                                print("result class count: \(result.class_count)")
                                print("n \(n-1)")
                                print("count \(count)")
                     
                                retrieved_classes.append(c)
//                                retrieved_classes.append()
                                context.delete(class_result)
                                count += 1
                                
                            }
                            
                        }
                    }
                    var indx = 0
                    var cnt = retrieved_classes.count
                    while cnt != 0 {
                        for r in retrieved_classes {
                            if r.location == indx {
                                retrieved_classes1.append(r)
                                indx += 1
                                cnt -= 1
                            }
                        }
                        
                        
                    }
                    
                    self.semesters.append(semester(name: result.name!, gpa: result.gpa!, classes: retrieved_classes1))
                    completion()
//                    if let count = result.value(forKey: "semester") as? Data {
//                        print("semester retrieved: \(count)")
//                        if let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: count) as? NSArray {
//                            //extract data
//                            for semester_data in mySavedData {
//                                let sem = semester.unarchive(data: semester_data as! Data)
//                                semesters.append(sem)
//                            }
//                        }
//                        
//                        
//                        
//                    }
                    //after it has been recorded in memory delete all objects
                    context.delete(result)
                    do {
                        try context.save()
                    } catch {
                        print("error saving classes to context after deletion")
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
    //will delete by removing all at loadtime then saving ones that exist after the user exits
//    func delete_semester_coredata() {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sems")
//        request.returnsObjectsAsFaults = false
//        if let result = try? context.fetch(request) {
//            //heads-up: ive named object "item" or "result" in other instances such as saving and retrieving/getting
//            
//            for object in result as! [Sems] {
//                if object.
//            }
//    
//        }
//    }
    
    var CoreDataSemestersArray = NSMutableArray()
    
    func save_semesters_coredata() {
        for item in semesters {
//            let data:NSData = NSData(data: semester.archive(structure: sem))
//            CoreDataSemestersArray.add(data)
            let semes:Sems = NSEntityDescription.insertNewObject(forEntityName: "Sems", into: context) as! Sems
            semes.name = item.name
            semes.gpa = item.gpa
            semes.class_count = Int16(item.classes.count)
            var location = 0
        
            for class_data_item in item.classes {
                
                print(item.classes.count)
                let class_item:Classes = NSEntityDescription.insertNewObject(forEntityName: "Classes", into: self.context) as! Classes
                class_item.name = class_data_item.name
                class_item.gpa = class_data_item.gpa
                class_item.hours = Int16(class_data_item.hours)
                class_item.grade = class_data_item.grade
                class_item.location = Int16(location)
                location += 1
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
//        let coreDataObject = NSKeyedArchiver.archivedData(withRootObject: CoreDataSemestersArray)
//        semester_count_coredata.setValue(coreDataObject, forKey: "semester")
        //store new count
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //appDelegate.saveContext()
    }
    
}

//@objc(Sems)
//public class Sems:NSManagedObject {
//    
//    @NSManaged public var name:String?
//    @NSManaged public var gpa:String?
////    @NSManaged public var classes:[semester_class]?
//    
//    var allAttributes:semester {
//        get {
//            return semester(name: self.name!, gpa: self.gpa!)
//        }
//        set {
//            self.name = newValue.name
//            self.gpa = newValue.gpa
//        }
//    }
//    
//}



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
    
    init(name:String, gpa:String, classes:[semester_class]) {
        self.name = name
        self.gpa = gpa
        self.classes = classes
    }
    
    init(name:String, gpa:String) {
        self.name = name
        self.gpa = gpa
    }
}


struct semester_class {
    var name:String!
    var grade:String!
    var hours:Int!
    var gpa:String!
    
    var location:Int!
    
    
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
    
