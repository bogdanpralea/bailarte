//
//  ClassesViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 30/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import youtube_ios_player_helper_swift

class ClassesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var classesCollectionView: UICollectionView!
    
    var categories = [Category]()
    var categoriesNumberOfVideos = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        
        categories = Request.shared.getCategories()
        categoriesNumberOfVideos = Request.shared.categoriesNumberOfVideos
        classesCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
////        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
////        self.navigationController?.navigationBar.shadowImage = UIImage()
////        self.navigationController?.navigationBar.isTranslucent = true
////        self.navigationController?.view.backgroundColor = UIColor.clear
//
        navigationController?.navigationBar.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.headerLabel.text = "Tutoriale"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2 , height: 220)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassColectionViewCell", for: indexPath) as! ClassCollectionViewCell
        cell.updateCell(with: categories[indexPath.row], nrOfVides: categoriesNumberOfVideos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        goToCategory(at: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? VideosViewController {
            if let indexPath = self.classesCollectionView.indexPathsForSelectedItems?.first?.row {
            nextViewController.videos = Request.shared.getVideos(for: categories[indexPath])
                
            }
        }
    }
    
    func goToCategory(at index: Int) {
        
//        prepare(for: "showVideos", sender: <#T##Any?#>)
        let vc = storyboard?.instantiateViewController(identifier: "VideosVc") as! VideosViewController
        vc.videos = Request.shared.getVideos(for: categories[index])
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

