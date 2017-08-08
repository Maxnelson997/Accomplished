//
//  ViewController.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    let GPAView:GPView = GPView()
    let GPALabel:GPLabel = GPLabel()
    let GPABoxLabel:GPLabel = GPLabel()
    
    let model:GPModel = GPModel.sharedInstance
    
    let flipView:GPFlipView = GPFlipView()
    
    let semester_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(semester_cell.self, forCellWithReuseIdentifier: "semester_cell")
        return cv
    }()
    
    let class_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(semester_cell.self, forCellWithReuseIdentifier: "class_cell")
        return cv
    }()
    
    fileprivate lazy var stack:UIStackView = {
       let s = UIStackView(arrangedSubviews: [self.GPAView, self.flipView])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        return s
    }()
    
    var gpa_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var cv_cons:[NSLayoutConstraint]!
    
    var selected_semester_index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        stack_cons = [
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            GPAView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.3),
            flipView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.7)
        ]
        
        gpa_cons = [
            GPALabel.topAnchor.constraint(equalTo: GPAView.topAnchor),
            GPALabel.leftAnchor.constraint(equalTo: GPAView.leftAnchor),
            GPALabel.rightAnchor.constraint(equalTo: GPAView.rightAnchor),
            GPALabel.heightAnchor.constraint(equalTo: GPAView.heightAnchor, multiplier: 0.5),
            
            GPABoxLabel.bottomAnchor.constraint(equalTo: GPAView.bottomAnchor),
            GPABoxLabel.leftAnchor.constraint(equalTo: GPAView.leftAnchor),
            GPABoxLabel.rightAnchor.constraint(equalTo: GPAView.rightAnchor),
            GPABoxLabel.heightAnchor.constraint(equalTo: GPAView.heightAnchor, multiplier: 0.4),
        ]
        
        cv_cons = [
            semester_cv.leftAnchor.constraint(equalTo: flipView.firstView.leftAnchor),
            semester_cv.rightAnchor.constraint(equalTo: flipView.firstView.rightAnchor),
            semester_cv.topAnchor.constraint(equalTo: flipView.firstView.topAnchor),
            semester_cv.bottomAnchor.constraint(equalTo: flipView.firstView.bottomAnchor),
            
            class_cv.leftAnchor.constraint(equalTo: flipView.secondView.leftAnchor),
            class_cv.rightAnchor.constraint(equalTo: flipView.secondView.rightAnchor),
            class_cv.topAnchor.constraint(equalTo: flipView.secondView.topAnchor),
            class_cv.bottomAnchor.constraint(equalTo: flipView.secondView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(stack_cons)
        NSLayoutConstraint.activate(gpa_cons)
        NSLayoutConstraint.activate(cv_cons)
        
        //test data
        model.semesters = [
            
        ]
        //test data

        semester_cv.delegate = self
        semester_cv.dataSource = self
    }
    
    //cv datasource and delegate
    
    //dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == semester_cv {
            return model.semesters.count
        } else {
            return model.semesters[selected_semester_index].classes.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == semester_cv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "semester_cell", for: indexPath) as! semester_cell
            cell.awakeFromNib()
            cell.name.text = model.semesters[indexPath.item].name
            cell.gpa.text = model.semesters[indexPath.item].gpa
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "class_cell", for: indexPath) as! class_cell
            cell.awakeFromNib()
            let current_class = model.semesters[model.selected_semester_index].classes[indexPath.item]
            cell.name.text = current_class.name
            cell.grade.text = current_class.grade
            cell.hours.text = String(describing: current_class.hours)
            cell.gpa.text = current_class.gpa
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == semester_cv {
            model.selected_semester_index = indexPath.item
            if class_cv.delegate == nil {
                class_cv.delegate = self
                class_cv.dataSource = self
            } else {
                class_cv.reloadData()
            }
        } else {
            
        }
    }

    
    //flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == semester_cv {
            let box_size = collectionView.frame.width/2 - 40
            return CGSize(width: box_size, height: box_size)
        } else {
            let box_size = collectionView.frame.width - 40
            return CGSize(width: box_size, height: box_size/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == semester_cv {
            return 10
        } else {
            return 20
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView == semester_cv {
//            return 10
//        } else {
//            return 20
//        }
//        return 10
//    }

}

