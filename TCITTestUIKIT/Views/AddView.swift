//
//  AddView.swift
//  TCITTestUIKIT
//
//  Created by Luis Barrios on 28/7/23.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

class AddView: UIView {
    
    
    
    private let nameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = UIColor(Color.gray.opacity(0.1))
        txtField.placeholder = "Username"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        return txtField
    }()
    
    private let descriptionTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = UIColor(Color.gray.opacity(0.1))
        txtField.placeholder = "Name"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        return txtField
    }()
    
    private  let addButton:UIButton = {
        let btn = UIButton(type:.system)
        btn.setTitle("Create", for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        return btn
    }()
    
    var postAdditionManager: PostAdder?{
        didSet{
            setupBindings()
        }
    }
    
    
    let isEditing = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTxtField)
        self.addSubview(descriptionTxtField)
        self.addSubview(addButton)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        nameTxtField.topAnchor.constraint(equalTo:self.topAnchor, constant:20).isActive = true
        nameTxtField.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:20).isActive = true
        nameTxtField.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-20).isActive = true
        
        descriptionTxtField.topAnchor.constraint(equalTo:nameTxtField.bottomAnchor, constant:8).isActive = true
        descriptionTxtField.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:20).isActive = true
        descriptionTxtField.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-20).isActive = true
        
        addButton.topAnchor.constraint(equalTo:descriptionTxtField.bottomAnchor, constant:8).isActive = true
        addButton.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:20).isActive = true
        addButton.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-20).isActive = true
        
    }
    
    private  func  setupBindings() {
        
        addButton.rx.tap.bind{ [weak self] in
            guard let `self` = self,
                  let name = nameTxtField.text,
                  let description =  descriptionTxtField.text
            else {return}
            self.postAdditionManager?.addPost(name: name, description: description)
        }.disposed(by: disposeBag)
        
        

        nameTxtField.rx
            .controlEvent(UIControl.Event.editingDidBegin)
            .bind{[weak self] value in
                self?.isEditing.onNext(true)
            }.disposed(by: disposeBag)
        
        descriptionTxtField.rx
            .controlEvent(UIControl.Event.editingDidBegin)
            .bind{[weak self] value in
                self?.isEditing.onNext(true)
            }.disposed(by: disposeBag)
        
        nameTxtField.rx.text.changed.bind{
            [weak self] value in
            guard let `self` = self
            else {return}
            self.setupButton()
        }.disposed(by: disposeBag)
        
        descriptionTxtField.rx.text.changed.bind{
            [weak self] value in
            guard let `self` = self
            else {return}
            self.setupButton()
        }.disposed(by: disposeBag)
        
    }
    
    private func setupButton(){
        guard
            let name = nameTxtField.text,
            let description =  descriptionTxtField.text
        else {return}
        
        if !name.isEmpty && !description.isEmpty {
            addButton.isEnabled = true
        } else{
            addButton.isEnabled = false
        }
    }
    
    
    
}
