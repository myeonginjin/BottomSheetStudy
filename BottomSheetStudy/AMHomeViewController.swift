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
        
        //최대 축소
        case minimum
    }
    
    

    
    
    
    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var sheetPanStartingTopConstant: CGFloat = sheetPanMinTopConstant
    
    
    
    var testBtn: UIButton?
    var sheetControll: AMHomeSheetControll?
    var contentSheetItemView: AMHomeContentSheetItemView?
    
    private var sheetControllTopConstraint: NSLayoutConstraint!
    
    
    
    
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    // 기본값은 30으로 지정
    // 이 값이 최대 확장 시 화면 상단으로부터의 마진 값을 정해줌
    var sheetPanMinTopConstant: CGFloat = 20.0
    
    
    
    // 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    // 이 값은 중간 크기 상황의 시트의 화면 상단으로부터의 마진 값을 정해줌
    var defaultHeight: CGFloat = 500
    
    // Bottom Sheet과 safe Area Bottom 사이의 최소값을 지정하기 위한 프로퍼티
    // 이 값이 시트 최소 축소 시 화면 하단으로부터의 마진 값을 정해줌
    var sheetPanMinBottomConstant: CGFloat = 100.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        

        
        
        setTestBtn()
        guard let testBtn = testBtn else {return}
        self.view.addSubview(testBtn)
        
        sheetControll = AMHomeSheetControll()
        sheetControll?.actionDelegate = self
        
        contentSheetItemView = AMHomeContentSheetItemView()
        
        guard let sheetControll = sheetControll else{return}
        guard let contentSheetItemView = contentSheetItemView else{return}
        
        
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        //바텀시트 영역에만 제스처 인식 기능을 추가한다. 바텀시트 영역을 제외한 부분 제스처는 인식되지않아야해서
        sheetControll.addGestureRecognizer(viewPan)
        
        
        //바텀시트에 채울 내용물들을 담고 있는 스크롤뷰 붙여줌
        sheetControll.addSubview(contentSheetItemView)
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
            
            
            contentSheetItemView.topAnchor.constraint(equalTo: sheetControll.topAnchor),
            contentSheetItemView.leadingAnchor.constraint(equalTo: sheetControll.leadingAnchor),
            contentSheetItemView.trailingAnchor.constraint(equalTo: sheetControll.trailingAnchor),
            contentSheetItemView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
    }
    
    //뷰컨의 view가 나타날때 showBottomSheet 실행해서 바텀시트 올라오도록하기
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet(atState: .minimum)
    }
    
    
    
    private func showBottomSheet(atState: SheetViewState) {
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
            
            //최대 확장 상태
        } else if atState == .expanded{
            sheetControllTopConstraint.constant = sheetPanMinTopConstant
        } else {
            //최소 확장상태
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            
            sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - sheetPanMinBottomConstant
        }
        
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
        
        let velocity = panGestureRecognizer.velocity(in: view)
        
        let translation = panGestureRecognizer.translation(in: self.view)
        
        
        print(translation)
        
        switch panGestureRecognizer.state {
        case .began:
            sheetPanStartingTopConstant = sheetControllTopConstraint.constant
        case .changed:
            if sheetPanStartingTopConstant + translation.y > sheetPanMinTopConstant {
                sheetControllTopConstraint.constant = sheetPanStartingTopConstant + translation.y
            }
            
            
        case .ended:
            
            //빠르게 스크롤시 최소 크기
            if velocity.y > 2000 {
                showBottomSheet(atState: .minimum)
                return
            }
            
            
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            // 1
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            // 2
            let nearestValue = nearest(to: sheetControllTopConstraint.constant, inValues: [sheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == sheetPanMinTopConstant {
                print("Bottom Sheet을 Expanded 상태로 변경")
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
//                hideBottomSheetAndGoBack()
                
                
                //최소 크기로 축소
                showBottomSheet(atState: .minimum)
            }
            
            print("드래그가 끝남")
        default:
            break
        }
        print("유저가 위아래로 \(translation.y)만큼 드래그.")
    }
    
    
    //주어진 CGFloat 배열의 값 중 number로 주어진 값과 가까운 값을 찾아내는 메소드
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
    
    
    @objc func buttonTapped() {
        print("btn Tapped")
    }
    
    
    
    func didScroll() {
        print("did Scoll !!")
    }
}
