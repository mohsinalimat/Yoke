//
//  ChefSettingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import FirebaseFirestore
import FirebaseAuth

class ChefSettingsViewController: UIViewController, TTGTextTagCollectionViewDelegate {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let cuisineCollectionView = TTGTextTagCollectionView()
    let cuisineListCollectionView = TTGTextTagCollectionView()
    private var selections = [String]()
    let uid = Auth.auth().currentUser?.uid ?? ""
    let firestoreDB = Firestore.firestore()
    let noCellId = "noCellId"
    let cellId = "cellId"
    var isCuisineList: Bool = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCuisineCollectionView()
        setupSelectCuisineCollectionView()
    }
 
    // MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(swipeIndicator)
        view.addSubview(chefLabel)
        view.addSubview(cuisineTypeTextField)
        view.addSubview(addButton)
        view.addSubview(moreButton)
        view.addSubview(selectionLabel)
        view.addSubview(cuisineCollectionView)
        view.addSubview(listViewBackground)
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.layer.masksToBounds = true
        blurredEffectView.layer.cornerRadius = 10
        blurredEffectView.frame = listViewBackground.bounds
        blurredEffectView.alpha = 0.8
        listViewBackground.addSubview(blurredEffectView)
        view.addSubview(listView)
        view.addSubview(cuisineListCollectionView)
        view.addSubview(doneButton)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        chefLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cuisineTypeTextField.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 45)
        addButton.anchor(top: nil, left: cuisineTypeTextField.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 8, width: 75, height: 35)
        addButton.centerYAnchor.constraint(equalTo: cuisineTypeTextField.centerYAnchor).isActive = true
        
        moreButton.anchor(top: cuisineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 25)
        selectionLabel.anchor(top: moreButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        cuisineCollectionView.anchor(top: selectionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 200)
        listViewBackground.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        listView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 350, height: 375)
        listView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        listView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        listView.layer.cornerRadius = 5
        cuisineListCollectionView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 345, height: 250)
        cuisineListCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cuisineListCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        doneButton.anchor(top: listView.topAnchor, left: nil, bottom: nil, right: cuisineListCollectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 100, height: 35)
    }
    
    func setupSelectCuisineCollectionView() {
        cuisineListCollectionView.backgroundColor = .white
        cuisineListCollectionView.alignment = .center
        cuisineListCollectionView.scrollDirection = .vertical
        cuisineListCollectionView.alignment = .fillByExpandingWidthExceptLastLine
        cuisineListCollectionView.delegate = self
        
        cuisineListCollectionView.isHidden = true
        listView.isHidden = true
        listViewBackground.isHidden = true
        doneButton.isHidden = true
        
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        config.borderColor = .clear
        config.shadowRadius = 4
        config.shadowOpacity = 0.2
        config.shadowColor = UIColor.gray
        let array = ["Italian","Indian","Mexican","Greek","Chinese","Mediterranean","Thai","Japanese","Seafood","Spanish","Moroccan","Turkish","Middle Eastern","Korean BBQ","Korean","Cajun","Southern American","American","Caribbean","Lebanese","Brazilian BBQ","Brazilian","Georgian","Vietnamese","German","Ukrainian","Canadian","Argentinian","Soul Food","British","South Korea","Vegetarian","Sigaporean","French","Austrian","Brazilian","Russian","Shanghaninese","South Indian","Sichuan","Portuguese","South African","Jamaican","Shanghai","Chilean","Cuban","Afghan","Malaysian","Saudi Arabia","Puerto Rican","Jewish","Balkan","Sicilian","Hungarian","Welsh","Swiss","Irish","Colombian","Taiwanese","Macau","Papua New Guinean","Iranian","Egyptian","Filipino","Texas","Scottish","Buddhist","Ghanaian","Tunisian","Azerbaijan","Mongolian","Somali","Belgian","Oaxacan","Swidish","Nepalese","Algerian","South African","Ethiopian","Indonesian","Mughlai","Guatemalan","Laotian","Cambodian","Sri Lankan","Vegan","Salvadoran","Icelandic","Continental","Midwestern","Chadian","Tex-Mex","BBQ"]
        let sortedArray = array.sorted(by: { $0 < $1 })
        cuisineListCollectionView.addTags(sortedArray, with: config)
    }
    
    func setupCuisineCollectionView() {
        cuisineCollectionView.alignment = .center
        cuisineCollectionView.scrollDirection = .vertical
        cuisineCollectionView.alignment = .fillByExpandingWidthExceptLastLine
        cuisineCollectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = UIColor.orangeColor()
        config.selectedBackgroundColor = .white
        config.borderColor = .clear
        config.shadowRadius = 4
        config.shadowOpacity = 0.2
        config.shadowColor = UIColor.gray
        
        firestoreDB.collection(Constants.Chefs).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cuisine"] as? [String] else { return }
                let sortedArray = array.sorted(by: { $0 < $1 })
                for name in sortedArray {
                    self.cuisineCollectionView.addTags([name], with: config)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func handleAddFromCuisineList(uid: String, text: String, index: UInt) {
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.orangeColor()
        config.textColor = UIColor.white
        CuisineController.shared.addCusineWith(uid: uid, type: text) { (result) in
            switch result {
            case true:
                self.cuisineCollectionView.addTag(text, with: config)
                self.cuisineCollectionView.reload()
                self.cuisineListCollectionView.reload()
            case false:
                print("error in adding cuisine")
            }
        }
    }
    
    func handleDelete(uid: String, text: String, index: UInt) {
        let alertController = UIAlertController(title: "Delete", message: "Would you like to delete this cuisine?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            CuisineController.shared.deleteCusineWith(uid: self.uid, type: text) { (result) in
                switch result {
                case true:
                    self.cuisineCollectionView.removeTag(at: index)
                    self.cuisineCollectionView.reload()
                case false:
                    print("error in adding cusines")
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleEmptyText() {
        let alertController = UIAlertController(title: "Empty field", message: "Please enter a cuisine to add", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        if isCuisineList == true {
            handleAddFromCuisineList(uid: uid, text: tagText, index: index)
        } else {
            handleDelete(uid: uid, text: tagText, index: index)
        }
    }
    
    //MARK: - Selectors
    @objc func handleAddTextField() {
        guard let text = cuisineTypeTextField.text, !text.isEmpty else { return handleEmptyText()}
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.orangeColor()
        config.textColor = UIColor.white
        CuisineController.shared.addCusineWith(uid: uid, type: text) { (result) in
            switch result {
            case true:
                self.cuisineCollectionView.addTag(text, with: config)
                self.cuisineTypeTextField.text = ""
                self.cuisineCollectionView.reload()
            case false:
                print("error in adding cuisine")
            }
        }
    }
    
    @objc func handleShowCuisineList() {
        cuisineListCollectionView.isHidden = false
        listView.isHidden = false
        listViewBackground.isHidden = false
        doneButton.isHidden = false
        isCuisineList = true
    }
    
    @objc func handleHideCuisineList() {
        cuisineListCollectionView.isHidden = true
        listView.isHidden = true
        listViewBackground.isHidden = true
        doneButton.isHidden = true
        isCuisineList = false
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    var chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Chef Settings"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .gray
        return label
    }()
    
    var cuisineTypeTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter a cuisine"
        text.font = UIFont.systemFont(ofSize: 17)
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.LightGrayBg()
        text.layer.cornerRadius = 10
        text.layer.shadowOffset = CGSize(width: 0, height: 4)
        text.layer.shadowRadius = 4
        text.layer.shadowOpacity = 0.1
        text.layer.shadowColor = UIColor.gray.cgColor
        return text
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleAddTextField), for: .touchUpInside)
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Or choose from our list of cuisines", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.titleLabel?.font = UIFont(name: "", size: 15)
        button.addTarget(self, action: #selector(handleShowCuisineList), for: .touchUpInside)
        return button
    }()
    
    var selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your selection's"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .gray
        return label
    }()
    var listViewBackground: UIView = {
        let view = UIView()
        return view
    }()
    
    var listView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont(name: "", size: 18)
        button.addTarget(self, action: #selector(handleHideCuisineList), for: .touchUpInside)
        return button
    }()
}

