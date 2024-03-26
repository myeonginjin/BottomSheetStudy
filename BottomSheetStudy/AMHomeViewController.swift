//
//  ViewController.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/25/24.
//

import UIKit

class AMHomeViewController: UIViewController,  AMHomeSheetControllDelegate {
    
    
    
    var testBtn: UIButton?
    var sheetControll: AMHomeSheetControll?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        
        setTestBtn()
        guard let testBtn = testBtn else {return}
        self.view.addSubview(testBtn)
        
        sheetControll = AMHomeSheetControll()
        sheetControll?.actionDelegate = self
        
        
        guard let sheetControll = sheetControll else{return}
        self.view.addSubview(sheetControll)
        
        
        NSLayoutConstraint.activate([
            
            testBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            testBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            testBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            testBtn.heightAnchor.constraint(equalToConstant: 200),
            
            
            sheetControll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            sheetControll.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            sheetControll.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            sheetControll.heightAnchor.constraint(equalToConstant: 500)
            
        ])
        
    }
    
    
    
    func setTestBtn(){
        
        testBtn = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        
        if let testBtn {
            testBtn.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
            //
            testBtn.translatesAutoresizingMaskIntoConstraints = false
            testBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
    }
    
    
    @objc func buttonTapped() {
        print("btn Tapped")
    }
    
    
    
    func didScroll() {
        print("did Scoll !!")
    }
}
