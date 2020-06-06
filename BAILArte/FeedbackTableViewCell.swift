//
//  FeedbackTableViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 09/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

protocol FeedbackTableViewCellDelegate: class {
    func setAnswer(_ feedbackTableViewCell: FeedbackTableViewCell, answer: String, to questionAtindex: Int)
}

class FeedbackTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var answerTextView: UITextView!
    
    weak var feedbackTableViewCellDelegate: FeedbackTableViewCellDelegate?
    var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with question: String, clearTextField: Bool, at index: Int) {
        answerTextView.text = clearTextField ? "" : answerTextView.text
        questionLabel.text = question
        currentIndex = index
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setAnswer()
    }
    
    func setAnswer() {
        feedbackTableViewCellDelegate?.setAnswer(self, answer: answerTextView.text, to: currentIndex)
    }
}
