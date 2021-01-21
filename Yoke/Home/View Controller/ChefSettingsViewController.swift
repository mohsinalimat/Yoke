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
    let cusineCollectionView = TTGTextTagCollectionView()
    let cusineListCollectionView = TTGTextTagCollectionView()
    private var selections = [String]()
    let uid = Auth.auth().currentUser?.uid ?? ""
    let firestoreDB = Firestore.firestore()
    let noCellId = "noCellId"
    let cellId = "cellId"
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCusineCollectionView()
        setupSelectCusineCollectionView()
    }
 
    // MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(swipeIndicator)
        view.addSubview(chefLabel)
        view.addSubview(cusineTypeTextField)
        view.addSubview(addButton)
        view.addSubview(moreButton)
        view.addSubview(selectionLabel)
        view.addSubview(cusineCollectionView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        chefLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cusineTypeTextField.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 45)
        addButton.anchor(top: chefLabel.bottomAnchor, left: cusineTypeTextField.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 28, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 50, height: 30)
        moreButton.anchor(top: cusineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 25)
        selectionLabel.anchor(top: moreButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        cusineCollectionView.anchor(top: selectionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 50)
    }
    
    func setupSelectCusineCollectionView() {
        cusineListCollectionView.alignment = .center
        cusineListCollectionView.scrollDirection = .horizontal
        cusineListCollectionView.alignment = .fillByExpandingWidthExceptLastLine
        cusineListCollectionView.delegate = self
        
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        let array = ["Italian","Indian","Mexican","Greek","Chinese","Mediterranean","Thai","Japanese","Seafood","Spanish","Moroccan","Turkish","Middle Eastern","Korean BBQ","Korean","Cajun","Southern American","American","Caribbean","Lebanese","Brazilian BBQ","Brazilian","Georgian","Vietnamese","German","Ukrainian","Canadian","Argentinian","Soul Food","British","South Korea","Vegetarian","Sigaporean","French","Austrian","Brazilian","Russian","Shanghaninese","South Indian","Sichuan","Portuguese","South African","Jamaican","Shanghai","Chilean","Cuban","Afghan","Malaysian","Saudi Arabia","Puerto Rican","Jewish","Balkan","Sicilian","Hungarian","Welsh","Swiss","Irish","Colombian","Taiwanese","Macau","Papua New Guinean","Iranian","Egyptian","Filipino","Texas","Scottish","Buddhist","Ghanaian","Tunisian","Azerbaijan","Mongolian","Somali","Belgian","Oaxacan","Swidish","Nepalese","Algerian","South African","Ethiopian","Indonesian","Mughlai","Guatemalan","Laotian","Cambodian","Sri Lankan","Vegan","Salvadoran","Icelandic","Continental","Midwestern","Chadian","Tex-Mex","BBQ"]
        let sortedArray = array.sorted(by: { $0 < $1 })
        cusineListCollectionView.addTags(sortedArray, with: config)
    }
    
    func setupCusineCollectionView() {
        cusineCollectionView.alignment = .center
        cusineCollectionView.scrollDirection = .horizontal
        cusineCollectionView.alignment = .fillByExpandingWidthExceptLastLine
        cusineCollectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        
        firestoreDB.collection(Constants.Cusine).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cusine"] as? [String] else { return }
                for name in array {
                    self.cusineCollectionView.addTags([name], with: config)
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        let alertController = UIAlertController(title: "Delete", message: "Would you like to delete this cusine?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            CusineController.shared.deleteCusineWith(uid: self.uid, type: tagText) { (result) in
                switch result {
                case true:
                    self.cusineCollectionView.removeTag(at: index)
                    self.cusineCollectionView.reload()
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
        let alertController = UIAlertController(title: "Empty field", message: "Please enter a cusine to add", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleAdd() {
        guard let text = cusineTypeTextField.text, !text.isEmpty else { return handleEmptyText()}
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.orangeColor()
        config.textColor = UIColor.white
        CusineController.shared.addCusineWith(uid: uid, type: text) { (result) in
            switch result {
            case true:
                self.cusineCollectionView.addTag(text, with: config)
                self.cusineTypeTextField.text = ""
                self.cusineCollectionView.reload()
            case false:
                print("error in adding cusines")
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var cusineTypeTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter a cusine. Example: Cuban, American, French..."
        text.font = UIFont.systemFont(ofSize: 17)
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.LightGrayBg()
        text.layer.cornerRadius = 5
        return text
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Or choose from our list", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    var selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your selection's"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
}

