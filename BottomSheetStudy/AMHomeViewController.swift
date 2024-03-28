//
//  ViewController.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/25/24.
//

import UIKit

class AMHomeViewController: UIViewController,  AMHomeSheetControllDelegate, UIScrollViewDelegate {
    
    
    //바텀시트 상태 지정하기 위한 열거형 데이터
    enum SheetViewState {
        
        //최대 확장
        case expanded
        
        //중간 턱
        case normal
        
        //최대 축소 현재 (기획의도x)
        case minimum
    }
    
    

    // 현재 바텀 시트의 상태를 추적하기 위한 변수 추가
    var currentSheetState: SheetViewState = .normal

    

    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var sheetPanStartingTopConstant: CGFloat = sheetPanMinTopConstant
    
    
    
    var testBtn: UIButton?
    var sheetControll: AMHomeSheetControll?
    var contentSheetItemView: AMHomeContentSheetItemView?
    
    private var sheetControllTopConstraint: NSLayoutConstraint!
    
    
    // 오프셋 0일떄 컨텐츠 스크롤이 아닌 시트가 내려가도록 (제스처가 viewPanned2로 가도록) 확장 여부 저장하는 변수
    var isExpanded = false
    

    
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    // 기본값은 30으로 지정
    // 이 값이 최대 확장 시 화면 상단으로부터의 마진 값을 정해줌
    var sheetPanMinTopConstant: CGFloat = 20.0
    
    
    
    // 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    // 이 값은 중간 크기 상황의 시트의 화면 상단으로부터의 마진 값을 정해줌
    var defaultHeight: CGFloat = 450
    
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
        // !!!! 우선 드래그인디케이터 뷰만 제스처 인식 가능하도록 변경 !!!
        sheetControll.dragIndicatorView.addGestureRecognizer(viewPan)
        
        
        
        
        //스크롤뷰 오프셋이 0인 경우 아래로 스크롤할 시 시트뷰가 노멀 사이즈로 바뀌도록 하기 위해 컨텐트 시트 아이템뷰에도 제스처 리코그나이저 붙여놓음
        let viewPan2 = UIPanGestureRecognizer(target: self, action: #selector(viewPanned2(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan2.delaysTouchesBegan = false
        viewPan2.delaysTouchesEnded = false
        contentSheetItemView.addGestureRecognizer(viewPan2)
        
        
        

        //스크롤 뷰 제스처 인식하기 위해서 AMHomeViewController 대리자로 위임
        contentSheetItemView.delegate = self
        
        
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
            
            
            contentSheetItemView.topAnchor.constraint(equalTo: sheetControll.dragIndicatorView.bottomAnchor),
            contentSheetItemView.leadingAnchor.constraint(equalTo: sheetControll.leadingAnchor),
            contentSheetItemView.trailingAnchor.constraint(equalTo: sheetControll.trailingAnchor),
            contentSheetItemView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
    }
    
    //뷰컨의 view가 나타날때 showBottomSheet 실행해서 바텀시트 올라오도록하기
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet(atState: .normal)
    }
    
    
    
    private func showBottomSheet(atState: SheetViewState) {
        
        //현제 바텀시트 상태 푸적
        currentSheetState = atState
        
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
            
            
            isExpanded = false
            
            //최대 확장 상태
        } else if atState == .expanded{
            
            
            
            
            sheetControllTopConstraint.constant = sheetPanMinTopConstant
            
            
            isExpanded = true
            
        } else {
            
            //최소 확장상태 우선 제외
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
            
            
            //최소 확장상태
//            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
//            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
//            
//            sheetControllTopConstraint.constant = (safeAreaHeight + bottomPadding) - sheetPanMinBottomConstant
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
            
            if currentSheetState == .normal && translation.y > 0 {
                
                
                // 노말 상테에서 아래로 드래그하는 동작 무시
                return
            }
            
            if sheetPanStartingTopConstant + translation.y > sheetPanMinTopConstant {
                sheetControllTopConstraint.constant = sheetPanStartingTopConstant + translation.y
            }
            
            
        case .ended:
            
            //빠르게 스크롤시 최소 크기
//            if velocity.y > 2000 {
//                showBottomSheet(atState: .normal)
//                return
//            }
//            
            
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            // 1
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            // 2
            let nearestValue = nearest(to: sheetControllTopConstraint.constant, inValues: [sheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == sheetPanMinTopConstant {
                print("Bottom Sheet을 Expanded 상태로 변경")
                
                //확장되자마자 상황은 시트내 스크롤이 아예 안되어잇음

                

            
                
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
//                hideBottomSheetAndGoBack()
                
                
                //최소 크기로 축소 (현재 제외)
                //showBottomSheet(atState: .minimum)
                
                showBottomSheet(atState: .normal)
            }
            
            print("드래그가 끝남")
        default:
            break
        }
        print("유저가 위아래로 \(translation.y)만큼 드래그.")
    }
    
    
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    
    // 오프셋이 0인경우 스크롤뷰를 아래로 내릴 시 시트가 내려가지도록 하기 위해서 구현함
    @objc private func viewPanned2(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        if(contentSheetItemView!.contentOffset.y <= 0 && isExpanded){
            
            print("that's it")
        }
        else{
            return
        }
        
        
        print(" \n\n\n \(sheetControllTopConstraint.constant)")
        

        
        
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
//            if velocity.y > 2000 {
//                showBottomSheet(atState: .normal)
//                return
//            }
//
            
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            // 1
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            // 2
            let nearestValue = nearest(to: sheetControllTopConstraint.constant, inValues: [sheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == sheetPanMinTopConstant {
                print(" 222 222222  Bottom Sheet을 Expanded 상태로 변경")
                
                //확장되자마자 상황은 시트내 스크롤이 아예 안되어잇음

                

                
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
//                hideBottomSheetAndGoBack()
                
                
                //최소 크기로 축소 (현재 제외)
                //showBottomSheet(atState: .minimum)
                
                showBottomSheet(atState: .normal)
            }
            
            print(" 2222222  222   드래그가 끝남")
        default:
            break
        }
        print(" 22222222 222 유저가 위아래로 \(translation.y)만큼 드래그.")
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
    
    

    
    //contentSheetItem 스크롤 인식하는 메소드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 뷰의 contentOffset이 0이고, 사용자가 아래로 스크롤할 때
        // 바텀 시트 상태를 .normal로 변경
        

        
        //제스처 아래에서 위로 (아래로 스크롤 하는 중)
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            // 스크롤뷰 바닥 부분은 팅겨야함
            
            
            
            

            
//            print(" test : \(scrollView.bounces)")
            scrollView.bounces = true
        
            //드래그 방향이 위로 향하는 순간 false로 처리해줘야함
        } else {
            // 상단의 경우 튕기지 않아야함
            scrollView.bounces = false
        }
        
        //제스처 위에서 아래로 (위로 스크롤 중)
        if scrollView.panGestureRecognizer.translation(in: scrollView).y > 0 {
            

            

        }
        
        if scrollView.contentOffset.y <= 0 {

        }
        


    }
    

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
            //드래그 시작 타이밍 떄마다 초기화 안해주면 빠르게 위아래 제스처시 상단도 튕길수도 있음
            scrollView.bounces = false

        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        

        
    }
    
}

