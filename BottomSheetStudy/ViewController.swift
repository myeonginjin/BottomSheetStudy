
//
//  ViewController.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/25/24.
//

import UIKit

class ViewController: UIViewController {
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .gray
        
        let testBtn = UIButton(type: .system)
//        if let img = UIImage(named: "images")?.withRenderingMode(.alwaysOriginal){ // 원본 이미지 사용
//            testBtn.setImage(img, for: .normal)
//        } else {
//            print("?")
//        }
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        testBtn.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
//
        testBtn.translatesAutoresizingMaskIntoConstraints = false
        testBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(testBtn)
        
        NSLayoutConstraint.activate([
            testBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    
        ])
        
    }
    
    @objc func buttonTapped() {
        print("test")
        
        //BottomSheetViewController의 이니셜라이저의 contentViewController로 임시로 빈 UIViewController를 전달
        let bottomSheetVC = BottomSheetViewController(contentViewController: UIViewController())
        
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        
        self.present(bottomSheetVC, animated: false , completion: nil)
    }


}
