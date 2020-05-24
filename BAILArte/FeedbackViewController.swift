//
//  FeedbackViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 09/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import TPKeyboardAvoidingSwift
import FirebaseFirestoreSwift
import FirebaseFirestore

class FeedbackViewController: UIViewController, UITableViewDataSource, FeedbackTableViewCellDelegate {
    @IBOutlet private var tableView: TPKeyboardAvoidingTableView!
    
    private var questionsArray = [String]()
    private var answersArray = [Answer]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        questionsArray = FirebaseManager.shared.getFeedback()
        tableView.reloadData()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        cell.feedbackTableViewCellDelegate = self
        cell.update(with: questionsArray[indexPath.row], at: indexPath.row)
        
        return cell
    }
    
    func setAnswer(_ feedbackTableViewCell: FeedbackTableViewCell, answer: String, to questionAtindex: Int) {
        let answer = Answer(question: questionsArray[questionAtindex], answer: answer)
        if answersArray.indices.contains(questionAtindex) {
            answersArray.remove(at: questionAtindex)
        }
        answersArray.insert(answer, at: questionAtindex)
    }
    
    
    @IBAction func sendFeedback(_ sender: UIButton) {
        let db = Firestore.firestore()
        let ref = db.collection("feedback").document("ios")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myDict = answersArray.reduce(into: [String: String] ()) {
            $0[$1.question] = $1.answer
        }

        ref.setData([formatter.string(from: Date.init()) : myDict], merge: true)
    }
    
}


