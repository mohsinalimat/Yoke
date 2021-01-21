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
//        setupCollectionView()
        setupTagCollectionView()
//        fetchCusines()
    }
 
    // MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(swipeIndicator)
        view.addSubview(chefLabel)
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
        
        cusineTypeTextField.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 45)
        addButton.anchor(top: chefLabel.bottomAnchor, left: cusineTypeTextField.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 28, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 50, height: 30)
        selectionLabel.anchor(top: cusineTypeTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        tagCollectionView.anchor(top: selectionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
    }
    
//    func setupCollectionView() {
//        collectionView.backgroundColor = UIColor.LightGrayBg()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(CusineCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
//    }
    
    func setupTagCollectionView() {
        tagCollectionView.alignment = .center
        tagCollectionView.scrollDirection = .vertical
        tagCollectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.textColor = UIColor.orangeColor()
        config.selectedTextColor = .white
        config.selectedBackgroundColor = UIColor.orangeColor()
        
//        tagCollectionView.addTags(["Mexican", "Italian", "Spanish", "American", "Thai", "Japanese", "Chinese", "Indian", "Cuban", "Greek", "Korean", "Cajun", "Portuguese", "Serbian", "Irish", "Peruvian", "French", "Jewish", "Swedish", "Latvian"], with: config)
        
        firestoreDB.collection(Constants.Cusine).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cusine"] as? [String] else { return }
                for name in array {
                    self.tagCollectionView.addTags([name], with: config)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
//    func fetchCusines() {
//        CusineController.shared.fetchCusineWith(uid: uid) { (result) in
//            switch result {
//            case true:
//                PRId16
//            case false:
//                print("error in adding cusines")
//            }
//        }
//    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        let alertController = UIAlertController(title: "Delete", message: "Would you like to delete this cusine?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            CusineController.shared.deleteCusineWith(uid: self.uid, type: tagText) { (result) in
                switch result {
                case true:
                    self.tagCollectionView.removeTag(at: index)
                    self.tagCollectionView.reload()
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
                self.tagCollectionView.addTag(text, with: config)
                self.cusineTypeTextField.text = ""
                self.tagCollectionView.reload()
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
    
    var selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your selection's"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        return cv
//    }()
}

// MARK: - CollectionView
//extension ChefSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(CusineController.shared.cusines.count)
//        if CusineController.shared.cusines.count == 0 {
//            return 1
//        } else {
//            return CusineController.shared.cusines.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if CusineController.shared.cusines.count == 0 {
//            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
//            noCell.noPostLabel.text = "Add cusines"
//            return noCell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CusineCollectionViewCell
//        cell.cusine = CusineController.shared.cusines[indexPath.item]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if CusineController.shared.cusines.count == 0 {
//            return CGSize(width: view.frame.width, height: view.frame.width / 4)
//        } else {
//            return CGSize(width: view.frame.width / 5, height: 45)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        if cusines.count == 0 {
////            return
////        } else {
////            let gallery = galleries[indexPath.row]
////            let galleryDetail = GalleryDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
////            galleryDetail.gallery = gallery
////            navigationController?.pushViewController(galleryDetail, animated: true)
////        }
//    }
//
//}
