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
    let collectionView = TTGTextTagCollectionView()
    private var selections = [String]()
    let uid = Auth.auth().currentUser?.uid ?? ""
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
 
    // MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(swipeIndicator)
        view.addSubview(chefLabel)
        view.addSubview(cusineTypeTextField)
        view.addSubview(addButton)
        view.addSubview(selectionLabel)
        view.addSubview(collectionView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        chefLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cusineTypeTextField.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 45)
        addButton.anchor(top: chefLabel.bottomAnchor, left: cusineTypeTextField.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 28, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 50, height: 30)
        selectionLabel.anchor(top: cusineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        collectionView.anchor(top: cusineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
    }
    
    func setupCollectionView() {
        collectionView.alignment = .center
        
        collectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        
        collectionView.addTags(["Mexican", "Italian", "Spanish", "American", "Thai", "Japanese", "Chinese", "Indian", "Cuban", "Greek", "Korean", "Cajun", "Portuguese", "Serbian", "Irish", "Peruvian", "French", "Jewish", "Swedish", "Latvian"], with: config)
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        
        if selected == true {
            CusineController.shared.addCusineWith(uid: uid, type: tagText) { (result) in
                switch result {
                case true:
                    self.selections.append(tagText)
                case false:
                    print("error in adding cusines")
                }
            }
        } else {
            CusineController.shared.deleteCusineWith(uid: uid, type: tagText) { (result) in
                switch result {
                case true:
                    print("\(self.selections)")
                case false:
                    print("error in adding cusines")
                }
            }
        }
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
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    var cusineTypeTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter a cusine here"
        text.font = UIFont.systemFont(ofSize: 17)
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.LightGrayBg()
        text.layer.cornerRadius = 5
//        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
//        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        return button
    }()
    
    var selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose as many that apply"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
}

