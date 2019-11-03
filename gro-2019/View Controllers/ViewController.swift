//
//  ViewController.swift
//  gro-2019
//
//  Created by Victor Zhong on 11/1/19.
//  Copyright © 2019 Victor Zhong. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    private lazy var headline: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.text = "Demo"
        return label
    }()

    private lazy var listenButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setTitle("Listen", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(openListenerView), for: .touchUpInside)
        return button
    }()

    private var textField: UITextField = {
        let field = UITextField(forAutoLayout: ())
        field.placeholder = "Type"
        return field
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headline, textField, listenButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDesign()
    }

    @objc private func openListenerView() {
        let listener = ListenerViewController()
        listener.delegate = self
        present(listener, animated: true, completion: nil)
    }

    private func setupDesign() {
        self.view.backgroundColor = .white
        view.addSubview(stack)
        stack.autoAlignAxis(toSuperviewAxis: .horizontal)
        stack.autoPinEdge(.leading, to: .leading, of: view, withOffset: 32)
        stack.autoPinEdge(.trailing, to: .trailing, of: view, withOffset:-32)
    }

}

extension ViewController: ListenerViewDelegate {

    func sendAlert(title: String, message: String) {

    }

    func updateText(text: String) {
        textField.text = text
    }

}
