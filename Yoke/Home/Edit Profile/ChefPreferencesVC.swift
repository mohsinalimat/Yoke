//
//  ChefPreferencesVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ChefPreferencesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
        setupViews()
        setupOnLoadView()
    }
    
    func setupOnLoadView() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!)
        ref.observe(.value) { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            let isChef = dictionary?[Constants.IsChef] as? Bool
            
            if isChef == true {
                self.chefSwitch.setOn(true, animated: true)
            } else {
                self.chefSwitch.setOn(false, animated: true)
            }

        }

    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
    let howToLabel: UILabel = {
        let label = UILabel()
        label.text = "Personalize how you want to be searched. Choose all that apply."
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Chef"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var chefSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(chefSwitch(chefSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func chefSwitch(chefSwitchChanged: UISwitch) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!)
        
        if chefSwitch.isOn {
            let values = [Constants.IsChef: true]
            ref.updateChildValues(values)
        } else {
            let values = [Constants.IsChef: false]
            ref.updateChildValues(values)
        }
    }
    
    let nutritionistLable: UILabel = {
        let label = UILabel()
        label.text = "Nutritionist"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var nutritionistSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
                switchBool.addTarget(self, action: #selector(nutritionistSwitch(nutritionistSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func nutritionistSwitch(nutritionistSwitchChanged: UISwitch) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!).child(Constants.ChefType)
        
        if nutritionistSwitch.isOn {
            let values = [Constants.IsNutritionist: true]
            ref.updateChildValues(values)
        } else {
            let values = [Constants.IsNutritionist: false]
            ref.updateChildValues(values)
        }
    }
    
    let pastryLable: UILabel = {
        let label = UILabel()
        label.text = "Pastry Chef"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var pastrySwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
                switchBool.addTarget(self, action: #selector(pastrySwitch(pastrySwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func pastrySwitch(pastrySwitchChanged: UISwitch) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!).child(Constants.ChefType)
        
        if pastrySwitch.isOn {
            let values = [Constants.IsPastry: true]
            ref.updateChildValues(values)
        } else {
            let values = [Constants.IsPastry: false]
            ref.updateChildValues(values)
        }
    }
    
    let vegetarianLable: UILabel = {
        let label = UILabel()
        label.text = "Vegetarian Chef"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var vegetarianSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
                switchBool.addTarget(self, action: #selector(vegetarianSwitch(vegetarianSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func vegetarianSwitch(vegetarianSwitchChanged: UISwitch) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!).child(Constants.ChefType)
        
        if vegetarianSwitch.isOn {
            let values = [Constants.IsVegetarian: true]
            ref.updateChildValues(values)
        } else {
            let values = [Constants.IsVegetarian: false]
            ref.updateChildValues(values)
        }
    }
    
    let veganLable: UILabel = {
        let label = UILabel()
        label.text = "Vegan Chef"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var veganSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(veganSwitch(veganSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func veganSwitch(veganSwitchChanged: UISwitch) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!).child(Constants.ChefType)
        
        if veganSwitch.isOn {
            let values = [Constants.IsVegan: true]
            ref.updateChildValues(values)
        } else {
            let values = [Constants.IsVegan: false]
            ref.updateChildValues(values)
        }
    }
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "Turn rates on"
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var rateSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.secondaryColor()
        switchBool.onTintColor = UIColor.secondaryColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(rateSwitch(rateSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func rateSwitch(rateSwitchChanged: UISwitch) {
        if rateSwitch.isOn {
            rateLabel.text = "Turn rates off"
            rangeSlider.isHidden = false
            priceLabel.isHidden = false
            priceTextView.isHidden = false
            saveRate(amount: 25)
            priceTextView.text = "$\(25)/hr"
        } else {
            saveRate(amount: 0)
            rateLabel.text = "Turn rates on"
            rangeSlider.isHidden = true
            priceLabel.isHidden = true
            priceTextView.isHidden = true

        }
    }

    var rangeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = UIColor.secondaryColor()
        slider.maximumValue = 500
        slider.minimumValue = 1
        slider.setValue(25, animated: true)
        slider.addTarget(self, action: #selector(ChefPreferencesVC.changeValue(_:)), for: .valueChanged)
        return slider
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "What's your hourly rate?"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let priceTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textAlignment = .center
        textView.textColor = UIColor.black
        textView.keyboardType = UIKeyboardType.numberPad
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    @objc func changeValue(_ sender: UISlider) {
        priceTextView.text = "$\(Int(sender.value))/hr"
        saveRate(amount: Int(sender.value))
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    func saveRate(amount: Int) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!)
        let values = [Constants.UserRate: amount]
        ref.updateChildValues(values)
        NotificationCenter.default.post(name: ChefPreferencesVC.updateNotificationName, object: nil)
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Chef Preferences"
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        scrollView.anchor(top: navView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(howToLabel)
        howToLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        let chefView = UIStackView(arrangedSubviews: [chefLabel, chefSwitch])
        chefView.distribution = .fillProportionally
        chefView.axis = .horizontal
        chefView.spacing = 0
        view.addSubview(chefView)
        chefView.anchor(top: howToLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        chefView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let nutritionistView = UIStackView(arrangedSubviews: [nutritionistLable, nutritionistSwitch])
        nutritionistView.distribution = .fillProportionally
        nutritionistView.axis = .horizontal
        nutritionistView.spacing = 0
        view.addSubview(nutritionistView)
        nutritionistView.anchor(top: chefView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        nutritionistView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let pastryView = UIStackView(arrangedSubviews: [pastryLable, pastrySwitch])
        pastryView.distribution = .fillProportionally
        pastryView.axis = .horizontal
        pastryView.spacing = 0
        view.addSubview(pastryView)
        pastryView.anchor(top: nutritionistView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        pastryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let vegetarianView = UIStackView(arrangedSubviews: [vegetarianLable, vegetarianSwitch])
        vegetarianView.distribution = .fillProportionally
        vegetarianView.axis = .horizontal
        vegetarianView.spacing = 0
        view.addSubview(vegetarianView)
        vegetarianView.anchor(top: pastryView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        vegetarianView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let veganView = UIStackView(arrangedSubviews: [veganLable, veganSwitch])
        veganView.distribution = .fillProportionally
        veganView.axis = .horizontal
        veganView.spacing = 0
        view.addSubview(veganView)
        veganView.anchor(top: vegetarianView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        veganView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let rateView = UIStackView(arrangedSubviews: [rateLabel, rateSwitch])
        rateView.distribution = .fillProportionally
        rateView.axis = .horizontal
        rateView.spacing = 0
        view.addSubview(rateView)
        rateView.anchor(top: veganView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        veganView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(priceLabel)
        priceLabel.anchor(top: rateView.bottomAnchor, left: rateView.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(priceTextView)
        priceTextView.anchor(top: rateView.bottomAnchor, left: nil, bottom: nil, right: rateView.rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 30)
        
        view.addSubview(rangeSlider)
        rangeSlider.anchor(top: priceLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: view.bounds.width - 2 * 20, height: 30)
        rangeSlider.center = view.center
    }
    
    @objc func handleDone() {
        print("done")
    }
 

}
