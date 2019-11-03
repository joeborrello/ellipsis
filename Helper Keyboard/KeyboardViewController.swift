////
////  KeyboardViewController.swift
////  Helper Keyboard
////
////  Created by Victor Zhong on 11/1/19.
////  Copyright © 2019 Victor Zhong. All rights reserved.
////

import UIKit

class KeyboardViewController: UIInputViewController {

    var capsLockOn = true

    var currentWord = ""

    let placeholderText = "Start Typing!"

    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    @IBOutlet weak var row3: UIView!
    @IBOutlet weak var row4: UIView!

    @IBOutlet weak var charSet1: UIView!
    @IBOutlet weak var charSet2: UIView!

    @IBOutlet weak var suggestionButton: UIButton!

    @IBAction func suggestionButtonTapped(_ sender: Any) {
        guard suggestionButton.titleLabel?.text != placeholderText else { return }

        for _ in 0..<currentWord.count {
            textDocumentProxy.deleteBackward()
        }

        let suggestionUsed = suggestionButton.titleLabel?.text ?? ""
        textDocumentProxy.insertText(suggestionUsed)
        currentWord = suggestionUsed
        suggestionButton.setTitle(placeholderText, for: .normal)
    }

    var suggestionString: UILexicon?

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as? UIView

        charSet2.isHidden = true
    }

    @IBAction func nextKeyboardPressed(button: UIButton) {
        advanceToNextInputMode()
    }

    @IBAction func capsLockPressed(button: UIButton) {
        capsLockOn = !capsLockOn

        changeCaps(containerView: row1)
        changeCaps(containerView: row2)
        changeCaps(containerView: row3)
        changeCaps(containerView: row4)
    }

    @IBAction func keyPressed(button: UIButton) {
        let string = button.titleLabel!.text
        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
        currentWord += string!

        // TODO: Guess sentence
        suggestionButton.setTitle("Add Bullsheet", for: .normal)

        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: {(_) -> Void in
            button.transform =
                CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    @IBAction func backSpacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
        _ = currentWord.popLast()
    }

    @IBAction func spacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
        currentWord += " "
    }

    @IBAction func returnPressed(button: UIButton) {
    }

    @IBAction func charSetPressed(button: UIButton) {
        if button.titleLabel!.text == "1/2" {
            charSet1.isHidden = true
            charSet2.isHidden = false
            button.setTitle("2/2", for: .normal)
        } else if button.titleLabel!.text == "2/2" {
            charSet1.isHidden = false
            charSet2.isHidden = true
            button.setTitle("1/2", for: .normal)
        }
    }

    func changeCaps(containerView: UIView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if capsLockOn {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: .normal)
                } else {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: .normal)
                }
            }
        }
    }

}

//extension KeyboardViewController: SpeechHelperDelegate {
//
//    func sendAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//}
