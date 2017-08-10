//
//  addSemester.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/9/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol GPNewDataDelegate {
    func addSemester(title:String)
}

class NewSemesterView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let s_types:[String] = ["summer", "spring", "fall", "winter"]
    let s_years:[String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"]
    
    var selected_type:String = "Fall"
    var selected_year:String = "17"
    
    var delegate:GPNewDataDelegate!

    let cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(empty_cell.self, forCellWithReuseIdentifier: "empty_cell")
        cv.register(new_semester_header.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(new_semester_footer.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        
        cv.isScrollEnabled = false

//        cv.backgroundColor = UIColor(rgb: 0x3A3A3A).withAlphaComponent(0.8)
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 12
        cv.layer.masksToBounds = true
        return cv
    }()
    var header_label:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .center
        l.backgroundColor = .clear
        return l
    }()
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty_cell", for: indexPath) as! empty_cell
        cell.awakeFromNib()
//        cell.contentView.backgroundColor = UIColor(rgb: 0x3A3A3A).withAlphaComponent(0.8)
        cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cell.contentView.addSubview(type_pick)
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate(type_pick.getConstraintsOfView(to: cell.contentView))
        NSLayoutConstraint.activate([
//            type_pick.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            ])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - 20 - 100)
    }
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    func phaseTwo() {
        
        addSubview(cv)
        
//        NSLayoutConstraint.activate([
//            cv.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
//            cv.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
//            cv.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
//            cv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
//            ])

        NSLayoutConstraint.activate(cv.getConstraintsOfView(to: self))
        cv.delegate = self
        cv.dataSource = self
        
        type_pick.delegate = self
        type_pick.dataSource = self

        
        //popup view asking for user input
        //pickerview with two columns.
        //SEMESTER - YEAR
        //-------------------
        //FALL        18
        //SPRING      20
        //...
        //NEXT button at the bottom.
        //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
        
        
    }
    
    fileprivate var type_pick:UIPickerView = {
        let s = UIPickerView()
        s.layer.cornerRadius = 12
        s.layer.masksToBounds = true
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return s_types.count
        }
        //year pick
        return s_years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        if component == 0 {
            selected_type = s_types[row]
        } else {
            selected_year = s_years[row]
        }
        header_label.text = "\(selected_type) \(selected_year)"


    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData:String!
        if component == 0 {
            titleData = s_types[row]
        } else {
            titleData = s_years[row]
        }
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! new_semester_header
            

            header.addSubview(header_label)
            header.frame = CGRect(x: 20, y: 0, width: collectionView.frame.width - 40, height: 50)
            NSLayoutConstraint.activate(header_label.getConstraintsOfView(to: header))
            header.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            header.layer.cornerRadius = 12
            header.layer.masksToBounds = true

         
            return header
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! new_semester_footer
//            footer.frame.size = CGSize(width: collectionView.frame.width - 40, height: 50)
            footer.frame = CGRect(x: 20, y: footer.frame.origin.y, width: collectionView.frame.width - 40, height: 50)
            footer.cancel_button.addTarget(self, action: #selector(self.cancel_semester), for: .touchUpInside)
            footer.done_button.addTarget(self, action: #selector(self.add_semester), for: .touchUpInside)
            footer.awakeFromNib()
            return footer
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func cancel_semester() {
        print("canceled adding semester")
        self.removeFromSuperview()
    }
    
    func add_semester() {
        delegate.addSemester(title:header_label.text!)
        self.removeFromSuperview()
        print("added semester")
    }
    


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //popup view asking for user input
    //pickerview with two columns.
    //SEMESTER - YEAR
    //-------------------
    //FALL        18
    //SPRING      20
    //...
    //NEXT button at the bottom.
    //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
    

}
