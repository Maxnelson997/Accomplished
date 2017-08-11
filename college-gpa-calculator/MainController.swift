//
//  ViewController.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GPNewDataDelegate {

    let gpaLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        return g
    }()
    
    let gpaBoxLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 65)
        return g
    }()
    
    let space0:GPLabel = GPLabel()
    
    let infoLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        return g
    }()
    
    let model:GPModel = GPModel.sharedInstance
    let viewModel:ViewModel = ViewModel()
    
    let flipView:GPFlipView = GPFlipView()

    let semester_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(semester_cell.self, forCellWithReuseIdentifier: "semester_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(CVFooter.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        cv.backgroundColor = .clear
        return cv
    }()
    
    let class_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(class_cell.self, forCellWithReuseIdentifier: "class_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(CVFooter.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.backgroundColor = .clear
        return cv
    }()

    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.topStack, self.space0, self.flipView])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .vertical
        return s
    }()
    
    fileprivate lazy var topStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.labelStack, self.gpaBoxLabel])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .horizontal
        return s
    }()
    
    fileprivate lazy var labelStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.gpaLabel, self.infoLabel])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .vertical
        return s
    }()
    
    var gpa_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var top_stack_cons:[NSLayoutConstraint]!
    var label_stack_cons:[NSLayoutConstraint]!
    var cv_cons:[NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MaxView(frame: UIScreen.main.bounds)
        infoLabel.textColor = UIColor.darkGray
        infoLabel.text = "SEMESTERS"
        infoLabel.backgroundColor = .clear
        space0.backgroundColor = .clear
        gpaLabel.text = "TOTAL GPA"
        gpaLabel.backgroundColor = .clear
        gpaLabel.textColor = UIColor.darkGray
        gpaBoxLabel.text = "0.00"
        gpaBoxLabel.textColor = UIColor.darkGray
        gpaBoxLabel.layer.cornerRadius = 12
        gpaBoxLabel.layer.masksToBounds = true
        
        view.backgroundColor = .white
        view.addSubview(stack)
        
        label_stack_cons = [
            gpaLabel.heightAnchor.constraint(equalTo: labelStack.heightAnchor, multiplier: 0.5),
            infoLabel.heightAnchor.constraint(equalTo: labelStack.heightAnchor, multiplier: 0.5),
        ]
        
        top_stack_cons = [
            labelStack.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: 0.5),
            gpaBoxLabel.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: 0.5),
        ]

        stack_cons = [
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            topStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2),
            space0.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.05),
            flipView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.75)
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
        
        NSLayoutConstraint.activate(label_stack_cons)
        NSLayoutConstraint.activate(top_stack_cons)
        NSLayoutConstraint.activate(stack_cons)
        NSLayoutConstraint.activate(cv_cons)

        semester_cv.delegate = self
        semester_cv.dataSource = self
    }

    func addSemester(title:String) {
        NSLayoutConstraint.deactivate(new_semester_cons)
        new_semester_view.removeFromSuperview()
        let new_semester = semester(name: title, gpa: "--", classes: [])
        model.semesters.append(new_semester)
        infoLabel.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        semester_cv.reloadData()
    }
 
    func addClass(title: String, grade: String, hour: Int) {
        NSLayoutConstraint.deactivate(new_class_cons)
        new_class_view.removeFromSuperview()
        let new_class = semester_class(name: title, grade: grade, hours: hour, gpa: "--")
        if model.class_is_being_edited {
            model.semesters[model.selected_semester_index].classes[model.class_being_edited] = new_class
            model.class_is_being_edited = false
        } else {
            model.semesters[model.selected_semester_index].classes.append(new_class)
        }
        
        gpaBoxLabel.animate(toText: viewModel.calculate_semester_gpa())
        model.semesters[model.selected_semester_index].gpa = viewModel.calculate_semester_gpa()
        class_cv.reloadData()
        semester_cv.reloadData()
    }
    
    

    
    var new_semester_view:NewSemesterView = {
        let p = NewSemesterView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        return p
    }()
    
    var new_class_view:NewClassView = {
        let p = NewClassView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        return p
    }()
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.5)
        cell.alpha = 0
        
        
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 20, options: .curveEaseIn, animations: {
            cell.alpha = 1.0
            //cell.layer.transform = CATransform3DIdentity
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
    }
    var new_semester_cons:[NSLayoutConstraint]!
    var new_class_cons:[NSLayoutConstraint]!
    //VMMV view logic or model logic or something
    func add_semester() {
        new_semester_cons = new_semester_view.getConstraintsOfView(to: flipView.firstView)
        new_semester_view.delegate = self
   
        self.flipView.firstView.addSubview(new_semester_view)
        NSLayoutConstraint.activate(new_semester_cons)
        new_semester_view.cv.reloadData()
        new_semester_view.load()
        //popup view asking for user input
        //pickerview with two columns.
            //SEMESTER - YEAR
            //-------------------
            //FALL        18
            //SPRING      20
            //...
        //NEXT button at the bottom. 
        //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
        
        print("add semester")
    }
    
    func remove_semester() {
        print("remove semester")
    }
    
    func add_class() {
        new_class_cons = new_class_view.getConstraintsOfView(to: flipView.secondView)
        new_class_view.delegate = self
        flipView.secondView.addSubview(new_class_view)
        NSLayoutConstraint.activate(new_class_cons)
        new_class_view.cv.reloadData()

        new_class_view.load()

        //popup view asking for user input
        //textfield asking for class name
            //CLASS NAME
        //pickeview with twocolumns 
            //GRADE - CREDIT HOUR
            //---------------------
            //A+          4
            //B+          3
        //ADD button at the bottom
        //view fades new class cell pops in
        //GPA for semester updates. this is when I perform the logic of all classes adding up. do this for all semesters too.
        print("add class")
    }
    
    func remove_class() {
        print("remove class")
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

            infoLabel.animate(toText: model.semesters[model.selected_semester_index].name)
            gpaBoxLabel.animate(toText: viewModel.calculate_semester_gpa())
            gpaLabel.animate(toText: "SEMESTER GPA")
            self.class_cv.alpha = 0
            flipView.switchViews {
                self.class_cv.alpha = 1
                if self.class_cv.delegate == nil {
                    self.class_cv.delegate = self
                    self.class_cv.dataSource = self
                } else {
                    self.class_cv.reloadData()
                }
            }
        } else {
            //edit a class cell
            model.class_is_being_edited = true
            model.class_being_edited = indexPath.item
            model.class_object_to_edit = model.semesters[model.selected_semester_index].classes[indexPath.item]
            add_class()
        }
    }

    
    //flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == semester_cv {
            let box_size = collectionView.frame.width/2 - 20
            return CGSize(width: box_size, height: box_size)
        } else {
            let box_size = collectionView.frame.width - 20
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
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! CVFooter
            if collectionView == class_cv {
                footer.plus_button.addTarget(self, action: #selector(self.add_class), for: .touchUpInside)
                footer.minus_button.addTarget(self, action: #selector(self.remove_class), for: .touchUpInside)
            } else if collectionView == semester_cv {
                footer.plus_button.addTarget(self, action: #selector(self.add_semester), for: .touchUpInside)
                footer.minus_button.addTarget(self, action: #selector(self.remove_semester), for: .touchUpInside)
            }
            footer.awakeFromNib()
            return footer
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == class_cv {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func SwitchView() {
        infoLabel.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        gpaBoxLabel.animate(toText: String(describing: viewModel.calculate_all_semester_gpa()))
        gpaLabel.animate(toText: "TOTAL GPA")
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

