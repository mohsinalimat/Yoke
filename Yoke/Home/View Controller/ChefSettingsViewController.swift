//
//  ChefSettingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class ChefSettingsViewController: UIViewController, TTGTextTagCollectionViewDelegate {
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let collectionView = TTGTextTagCollectionView()
    private var selections = [String]()
    
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
        view.addSubview(collectionView)
    }
    
    func constrainViews() {
        collectionView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func setupCollectionView() {
        collectionView.alignment = .center
        collectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.orangeColor()
        config.textColor = .white
        
        collectionView.addTags(["Mexican", "Italian", "Spanish", "American", "Thai", "Japanese", "Chinese", "Indian", "Cuban", "Greek", "Korean", "Cajun", "Portuguese", "Serbian", "Irish", "Peruvian", "French", "Jewish", "Swedish", "Latvian"], with: config)
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        selections.append(tagText)
        print("/(selections)")
    }
}

