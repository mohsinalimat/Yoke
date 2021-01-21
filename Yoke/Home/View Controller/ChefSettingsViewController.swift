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
    let tagCollectionView = TTGTextTagCollectionView()
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
        setupCollectionView()
        setupTagCollectionView()
        fetchCusines()
    }
 
    // MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(swipeIndicator)
        view.addSubview(chefLabel)
        view.addSubview(collectionView)
        view.addSubview(cusineTypeTextField)
        view.addSubview(addButton)
        view.addSubview(selectionLabel)
        view.addSubview(tagCollectionView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        chefLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        collectionView.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 200)
        
        cusineTypeTextField.anchor(top: collectionView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 45)
        addButton.anchor(top: collectionView.bottomAnchor, left: cusineTypeTextField.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 28, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 50, height: 30)
        selectionLabel.anchor(top: cusineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        tagCollectionView.anchor(top: selectionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(MenuHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(CusineCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func setupTagCollectionView() {
        tagCollectionView.alignment = .center
        
        tagCollectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        
        tagCollectionView.addTags(["Mexican", "Italian", "Spanish", "American", "Thai", "Japanese", "Chinese", "Indian", "Cuban", "Greek", "Korean", "Cajun", "Portuguese", "Serbian", "Irish", "Peruvian", "French", "Jewish", "Swedish", "Latvian"], with: config)
    }
    
    func fetchCusines() {
        CusineController.shared.fetchCusineWith(uid: uid) { (result) in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case false:
                print("error in adding cusines")
            }
        }
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        label.text = "Choose all that apply"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
}

// MARK: - CollectionView
extension ChefSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(CusineController.shared.cusines.count)
        if CusineController.shared.cusines.count == 0 {
            return 1
        } else {
            return CusineController.shared.cusines.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if CusineController.shared.cusines.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "Add cusines"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CusineCollectionViewCell
        cell.cusine = CusineController.shared.cusines[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if CusineController.shared.cusines.count == 0 {
            return CGSize(width: view.frame.width, height: view.frame.width / 4)
        } else {
            let width = (view.frame.width - 2) / 2
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if cusines.count == 0 {
//            return
//        } else {
//            let gallery = galleries[indexPath.row]
//            let galleryDetail = GalleryDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
//            galleryDetail.gallery = gallery
//            navigationController?.pushViewController(galleryDetail, animated: true)
//        }
    }

}
