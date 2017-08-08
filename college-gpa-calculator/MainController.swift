//
//  ViewController.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    let gpaLabel:GPLabel = GPLabel()
    let gpaBoxLabel:GPLabel = GPLabel()
    
    let space0:GPLabel = GPLabel()
    
    let model:GPModel = GPModel.sharedInstance
    
    let flipView:GPFlipView = GPFlipView()
    


  
    
    

    
    let semester_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(semester_cell.self, forCellWithReuseIdentifier: "semester_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.backgroundColor = .clear
//        cv.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        return cv
    }()
    
    let class_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(class_cell.self, forCellWithReuseIdentifier: "class_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
//        cv.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.backgroundColor = .clear
//        cv.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        return cv
    }()
    
    fileprivate lazy var stack:UIStackView = {
       let s = UIStackView(arrangedSubviews: [self.gpaLabel, self.gpaBoxLabel, self.space0, self.flipView])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
//        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .vertical
        return s
    }()
    
    var gpa_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var cv_cons:[NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MaxView(frame: UIScreen.main.bounds)
        space0.textColor = UIColor.darkGray
        space0.text = "SEMESTERS"
        space0.backgroundColor = .clear
        gpaLabel.text = "TOTAL GPA"
        gpaLabel.backgroundColor = .clear
        gpaLabel.textColor = UIColor.darkGray
        gpaBoxLabel.text = "3.14"
        gpaBoxLabel.layer.cornerRadius = 12
        gpaBoxLabel.layer.masksToBounds = true
        
        view.backgroundColor = .white
        view.addSubview(stack)

        stack_cons = [
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            gpaLabel.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1),
            gpaBoxLabel.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1),
            space0.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1),
            flipView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.7)
        ]
        
        flipView.firstView.addSubview(semester_cv)
        flipView.secondView.addSubview(class_cv)

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
        NSLayoutConstraint.activate(cv_cons)

        semester_cv.delegate = self
        semester_cv.dataSource = self
    }

    //cv datasource and delegate
    
    //dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == semester_cv {
            return model.semesters.count
        } else {
            return model.semesters[model.selected_semester_index].classes.count
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
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "class_cell", for: indexPath) as! class_cell
            cell.awakeFromNib()
            let current_class = model.semesters[model.selected_semester_index].classes[indexPath.item]
            cell.name.text = current_class.name
            cell.grade.text = current_class.grade
            cell.hours.text = String(describing: current_class.hours!)
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
            space0.animate(toText: model.semesters[model.selected_semester_index].name)
            flipView.switchViews {
                
            }
        } else {
            
        }
    }

    
    //flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == semester_cv {
            let box_size = collectionView.frame.width/2 - 5 - 20
            return CGSize(width: box_size, height: box_size)
        } else {
            let box_size = collectionView.frame.width - 5 - 20
            return CGSize(width: box_size, height: box_size/3)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CVHeader
            header.awakeFromNib()
            header.backBtn.addTarget(self, action: #selector(self.SwitchView), for: .touchUpInside)
            if collectionView == class_cv {
                return header
            }
            return UICollectionReusableView()
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == class_cv {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return .zero
    }
    
    
    
    func SwitchView() {
        space0.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        flipView.switchViews {
            
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

