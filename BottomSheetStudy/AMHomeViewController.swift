//
//  ViewController.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/25/24.
//

import UIKit

class AMHomeViewController: UIViewController,  AMHomeSheetControllDelegate {
    
    
    //바텀시트 상태 지정하기 위한 열거형 데이터
    enum SheetViewState {
        
        //최대 확장
        case expanded
        
        //중간 턱
        case normal
    }
    
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    // 기본값은 30으로 지정
    var sheetPanMinTopConstant: CGFloat = 30.0
    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var sheetPanStartingTopConstant: CGFloat = sheetPanMinTopConstant
    
    
    
    var testBtn: UIButton?
    var sheetControll: AMHomeSheetControll?
    private var sheetControllTopConstraint: NSLayoutConstraint!
    
    
    // 1 - 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    var defaultHeight: CGFloat = 150
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        
        setTestBtn()
        guard let testBtn = testBtn else {return}
        self.view.addSubview(testBtn)
        
        sheetControll = AMHomeSheetControll()
        sheetControll?.actionDelegate = self
        
        
        guard let sheetControll = sheetControll else{return}
        self.view.addSubview(sheetControll)
        
        
        
        sheetControll.translatesAutoresizingMaskIntoConstraints = false
        
        //바텀시트 초기 높이값 설정
//        let topConstant: CGFloat = 300
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height

        sheetControllTopConstraint = sheetControll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)

        
        NSLayoutConstraint.activate([
            
            testBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            testBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            testBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            testBtn.heightAnchor.constraint(equalToConstant: 200),
            
            
            sheetControll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sheetControll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sheetControll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetControllTopConstraint,
            
        ])
        
    }
    
    //뷰컨의 view가 나타날때 showBottomSheet 실행해서 바텀시트 올라오도록하기
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        //바텀시트 높이 재설정
        sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        //UIView.animate 메소드의 animations에 closure를 전달
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    
            //뷰컨의 뷰 딤드 처리
            self.view.alpha = 0.7
            
            
                    // 바텀시트가 스무스하게 올라오도록 해줌
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        
        
        let translation = panGestureRecognizer.translation(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            sheetPanStartingTopConstant = sheetControllTopConstraint.constant
        case .changed:
            if sheetPanStartingTopConstant + translation.y > sheetPanMinTopConstant {
                sheetControllTopConstraint.constant = sheetPanStartingTopConstant + translation.y
            }
        case .ended:
            print("드래그가 끝남")
        default:
            break
        }
        print("유저가 위아래로 \(translation.y)만큼 드래그.")
    }
    
    @objc func buttonTapped() {
        print("btn Tapped")
    }
    
    
    
    func didScroll() {
        print("did Scoll !!")
    }
}
