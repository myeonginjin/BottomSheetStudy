//
//  ViewController.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/25/24.
//

import UIKit

//바텀시트 상태 지정하기 위한 열거형 데이터
enum SheetViewState {
    
    //최대 확장
    case expanded
    
    //디폴트
    case normal
    
    case minimum //최대 축소 (현재 기획의도x)
}

class AMHomeViewController: UIViewController,
                            UIScrollViewDelegate {
    
    // 오프셋 0일떄 컨텐츠 스크롤이 아닌 시트가 내려가도록 (제스처가 viewPanned2로 가도록) 확장 여부 저장하는 변수
    var isExpanded = false
    
    // 현재 바텀 시트의 상태를 추적하기 위한 변수
    var currentSheetState: SheetViewState = .normal
    
    // 드래그 시작 점에서(화면터치) Bottom Sheet의 현재 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var sheetPanStartingTopConstant: CGFloat = sheetPanMinTopConstant
    
    //바텀시트의 크기를 동적으로(제스처에 따라 변화도록) 변하시키기 위해 상단 제약조건을 따로 변수로 선언
    private var sheetControlTopConstraint: NSLayoutConstraint!
    
    //뷰컨트롤러 view에 붙어있을 버튼
    var testBtn: UIButton?
    
    //바텀시트
    var sheetControll: AMHomeSheetControl?
    
    //바텀시트 안 내용물(content) 뷰
    var contentSheetItemView: AMHomeContentSheetItemView?
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    // 기본값은 0으로 지정해놓고 viewdidLoad시 초기화 해줌
    // 이 값이 최대 확장 시 화면 상단으로부터의 마진 값을 정해줌
    var sheetPanMinTopConstant: CGFloat = 0.0
    
    
    // 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    // 이 값은 중간 크기 상황의 시트의 화면 상단으로부터의 마진 값을 정해줌
    var defaultHeight: CGFloat = 0.0
    
    // Bottom Sheet과 safe Area Bottom 사이의 최소값을 지정하기 위한 프로퍼티
    // 이 값이 시트 최소 축소 시 화면 하단으로부터의 마진 값을 정해줌
    var sheetPanMinBottomConstant: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    func commonInit(){
        initViews()

        registerPanGestures()
        
        initLayouts()
    }
    
    //뷰컨의 view가 나타날때 showBottomSheet 실행해서 바텀시트 올라오도록하기
    //이전에는 sheetControllTopConstraint는 바텀시트가 화면밖(화면 최하단 및)에 있도록 설정되어있음
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet(atState: .normal)
    }

    //바텀시트의 높이를 최대확장, 디폴트, 최대축소로 변경하는 메서드
    private func showBottomSheet(atState: SheetViewState) {
        
        //현제 바텀시트 상태 추적
        currentSheetState = atState
        
        // 화면 중단에 걸쳐져 있는 상태
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            sheetControlTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
            
            //확장 상태가 아님
            isExpanded = false
            
            //최대 확장 상태
        } else if atState == .expanded{
            sheetControlTopConstraint.constant = sheetPanMinTopConstant
            
            //최대 확장 상태임 (스크롤뷰 오프셋이 0일 때 아래로 제스처 시 시트가 내려갈 수 있도록 하기 위해 해당 변수 사용
            isExpanded = true
            
        } else {
            
            //최소 확장상태 우선 제외
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            sheetControlTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
            
            //최소 확장상태 만들어 주는 로직 (viewPanned메소드에 노말상태에서 아래로 제스처 시 return 시키는 부분도 제거해야 적용됨)
            //            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            //            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            //
            //            sheetControlTopConstraint.constant = (safeAreaHeight + bottomPadding) - sheetPanMinBottomConstant
        }
        
        //UIView.animate 메소드의 animations에 closure를 전달
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            
            //뷰컨의 뷰 딤드 처리
            //            self.view.alpha = 0.7
            // 바텀시트가 스무스하게 올라오도록 해줌
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func initViews() {
        
        initTestBtn()
        
        initSheetControll()
        
        initcontentSheetItemView()

        self.view.backgroundColor = .gray
    }
    
    func initTestBtn() {
        let testBtn = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        testBtn.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
        testBtn.translatesAutoresizingMaskIntoConstraints = false
        testBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.view.addSubview(testBtn)
        self.testBtn = testBtn
    }
    
    func initSheetControll() {
        let sheetControll = AMHomeSheetControl()
        sheetControll.translatesAutoresizingMaskIntoConstraints = false
        
        //바텀시트 초기 높이값 설정 화면 밖 최하단 밑으로 설정
        // 후에 디폴트 값인 화면 중단쯤으로 조정될 때 밑에서 부터 올라오는 효과를 부여해줄 수 있음
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        sheetControlTopConstraint = sheetControll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        //시트 확장, 기본, 최소 상태일 때 시트뷰 탑 제약조건 지정해줌
        sheetPanMinTopConstant = sheetControll.sheetPanMinTopConstant()
        defaultHeight = sheetControll.defaultHeight()
        sheetPanMinBottomConstant = sheetControll.sheetPanMinBottomConstant()
        
        self.view.addSubview(sheetControll)
        self.sheetControll = sheetControll
    }
    
    func initcontentSheetItemView() {
        guard let sheetControll = self.sheetControll else { return}
        let contentSheetItemView = AMHomeContentSheetItemView()
        
        //바텀시트에 채울 내용물들을 담고 있는 스크롤뷰 붙여줌
        sheetControll.addSubview(contentSheetItemView)
        self.contentSheetItemView = contentSheetItemView
    }
    
    func registerPanGestures() {
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let handleBarPan = UIPanGestureRecognizer(target: self, action: #selector(handleBarPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        handleBarPan.delaysTouchesBegan = false
        handleBarPan.delaysTouchesEnded = false
        
        guard let sheetControll = self.sheetControll else { return }
        guard let contentSheetItemView = self.contentSheetItemView else { return }
        //바텀시트의 헨들바가 있는 영역 dragIndicatorView가 제스처를 통해 시트의 높이를
        //변경할 수 있도록 UIPanGestureRecognizer 붙여준다
        sheetControll.dragIndicatorView.addGestureRecognizer(handleBarPan)
        
        //스크롤뷰 오프셋이 0인 경우 아래로 스크롤할 시 시트뷰가 노멀 사이즈로 바뀌도록 하기 위해 컨텐트 시트 아이템뷰에도 제스처 리코그나이저 붙여놓음
        let contentViewPan = UIPanGestureRecognizer(target: self, action: #selector(contentViewPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        contentViewPan.delaysTouchesBegan = false
        contentViewPan.delaysTouchesEnded = false
        contentSheetItemView.addGestureRecognizer(contentViewPan)
        
        //스크롤 뷰 제스처 인식에 따른 프로세스 처리를 AMHomeViewController에 위임
        contentSheetItemView.delegate = self
    }
    
    func initLayouts(){
        var constraints = [NSLayoutConstraint]()
        
        if let testBtnConstraints = self.testBtnConstraints() {
            constraints += testBtnConstraints
        }
        
        if let sheetControllConstraints = self.sheetControllConstraints() {
            constraints += sheetControllConstraints
        }
        
        if let contentSheetItemViewConstraints = self.contentSheetItemViewConstraints() {
            constraints += contentSheetItemViewConstraints
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func testBtnConstraints() -> [NSLayoutConstraint]? {
        
        guard let testBtn = self.testBtn else { return nil }
        
        return [testBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
                testBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                testBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                testBtn.heightAnchor.constraint(equalToConstant: 200)]
    }
    
    func sheetControllConstraints() -> [NSLayoutConstraint]? {
        
        guard let sheetControll = self.sheetControll else { return nil }
        
        return [sheetControll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                sheetControll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                sheetControll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                sheetControlTopConstraint]
    }
    func contentSheetItemViewConstraints() -> [NSLayoutConstraint]? {
        
        guard let sheetControll = self.sheetControll else { return nil }
        guard let contentSheetItemView = self.contentSheetItemView else { return nil }
        
        return [contentSheetItemView.topAnchor.constraint(equalTo: sheetControll.dragIndicatorView.bottomAnchor),
                contentSheetItemView.leadingAnchor.constraint(equalTo: sheetControll.leadingAnchor),
                contentSheetItemView.trailingAnchor.constraint(equalTo: sheetControll.trailingAnchor),
                contentSheetItemView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
    }
    
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    @objc private func handleBarPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        //제스처의 속도 측정
        let velocity = panGestureRecognizer.velocity(in: view)
        
        //지정된 뷰의 좌표계에서, 이 view의 새 위치를 식별하는 점
        // x와 y에 따라 가로 세로, 부호에 따라 방향이 반환된다.
        let translation = panGestureRecognizer.translation(in: self.view)
        
        switch panGestureRecognizer.state {
            
        //제스처가 시작할 때 상황 (화면 터치되어있음)
        case .began:
            
            //현재 화면 상단으로부터의 바텀시트 top 제약조건 저장해놓음
            sheetPanStartingTopConstant = sheetControlTopConstraint.constant
            
        // 드래그가 진행 중 (터치되어 있는 상태에서 손가락의 위치가 이동하고 있음)
        case .changed:
            //바텀시트가 중단에 있는 상황에서 드래그를 아래로 향했음
            if currentSheetState == .normal && translation.y > 0 {
            
                // 노말 상테에서 아래로 드래그하는 동작 무시
                // 노말 상태에서 바텀시트는 더이상 작아지면 안됨 고로 제스처 인식해줄 필요 없음
                return
            }
            
            // 바텀시트의 제스처 이전 탑 제약조건에 드래그 통해 새 좌쵸가 될 지점까지의 거리값을 더했을 때 최대 확장시 top제약조건 보다 크다면 sheetControllTopConstraint의 제약조건에 그 더한값을 지정해줌
            // sheetPanStartingTopConstant의 값은 한번의 제스처 동안에는 그 값이  변하지않음
            if sheetPanStartingTopConstant + translation.y >
                sheetPanMinTopConstant {
                sheetControlTopConstraint.constant = sheetPanStartingTopConstant + translation.y
            }
            
            //드래그가 종료됨. 제스처 이후 화면에서 손가락이 떼졌음
        case .ended:
            
            //빠르게 스크롤시 바텀시트를 최소 크기로 바꿔주는 로직
//            if velocity.y > 2000 {
//                showBottomSheet(atState: .minimum)
//                return
//            }

            //핸드폰 안전구역 높이
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            
            //안전구역의 바텀영역값 (일반적으로 노치 디자인 34pt, 일반디자인 0pt)
            let bottomPadding = view.safeAreaInsets.bottom
            
            //핸드폰 화면에서 앱의 화면이 차지할 수 있는 전체 영역에서 바텀시트의 화면상단으로부터의 기본 마진값을 뺌
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            //제스처를 통해 새로 지정된 좌표값이 담긴 sheetControlTopConstraint.constant가 바텀시트 최대 확장 시 위치, 기본값 위치, 핸드폰 최하단 위치 이 세 지점에서 어디에 가장 근접한지 구함
            let nearestValue = nearest(to: sheetControlTopConstraint.constant, inValues: [sheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            //최대확장 지점에 가장 가까울 시
            if nearestValue == sheetPanMinTopConstant {
                print("Bottom Sheet을 Expanded 상태로 변경")
                
                //바텀시트 최대확장 상태로 변경해줌 (이때 높이변화는 끊기지 않고 스무스하게 일어남)
                showBottomSheet(atState: .expanded)
                
            } else if nearestValue == defaultPadding {
                
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
                
            } else {
                
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
                //아래 메소드에 바텀시트를 아예 화면 밖으로 보내는 로직을 추가할 수도 있음
//                hideBottomSheetAndGoBack()
                
                //아니면 최소 상태로 변경 제스처 속도가 빠를때만 hideBottomSheetAndGoBack시키도록 분기할수도 있음
                //최소 크기로 축소 (현재 제외)
                //showBottomSheet(atState: .minimum)
                
                //현재는 디폴트 크기 normal과 최대확장 두가지로만 분기
                showBottomSheet(atState: .normal)
            }
            
            print("드래그가 끝남")
        default:
            break
        }
        print("유저가 위아래로 \(translation.y)만큼 드래그.")
    }
    
    
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    // 이 메소느는 UIScrollView인 AMHomeContentSheetItemView에 붙어있는 UIPanGestureRecognizer에 의해 호출됨
    // 오프셋이 0인경우 스크롤뷰를 아래로 내릴 시 시트가 내려가지도록 하기 위해서 구현함
    @objc private func contentViewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {

        guard let contentSheetItemView = self.contentSheetItemView else { return }
        
        // 스크롤뷰의 오프셋이 0인 상황(컨텐트가 아래로 조금도 내려가있지않는 상태)에서 최대 확장시에만 시트 변화를 야기시키는 viewPanned2매소드를 진행시켜야함
        if (contentSheetItemView.contentOffset.y <= 0 && isExpanded) {

        }
        else{
            // 그게 아니라면 스크롤뷰의 제스처 인식 기능만 활성화하고 시트뷰의 높이를 변화시켜주는 UIPanGestureRecognizer는 무시되어야함
            return
        }
        
        let velocity = panGestureRecognizer.velocity(in: view)
        let translation = panGestureRecognizer.translation(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            sheetPanStartingTopConstant = sheetControlTopConstraint.constant
        case .changed:
            if sheetPanStartingTopConstant + translation.y > sheetPanMinTopConstant {
                sheetControlTopConstraint.constant = sheetPanStartingTopConstant + translation.y
            }
            
        case .ended:
            
            //빠르게 스크롤시 최소 크기
//            if velocity.y > 2000 {
//                showBottomSheet(atState: .normal)
//                return
//            }
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            let nearestValue = nearest(to: sheetControlTopConstraint.constant, inValues: [sheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == sheetPanMinTopConstant {
                print(" 2 Bottom Sheet을 Expanded 상태로 변경")
    
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
            print(" 2 드래그가 끝남")
        default:
            break
        }
        print(" 2 유저가 위아래로 \(translation.y)만큼 드래그.")
    }
    
    //주어진 CGFloat 배열의 값 중 number로 주어진 값과 가까운 값을 찾아내는 메소드
    //배열을 순회화면서, 2개의 원소를 순차적으로 비교하면서 number와 차이가 가장 적은 원소가 계속해서 비교군이된다. 차이가 같은 원소가 있을 경우 인덱스가 더 낮은 원소가 선정된다.
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }

    //contentSheetItem 스크롤 인식하는 메소드 현재 해당 스크롤뷰에는 기본적으로 붙어있는 스크롤뷰 제스처 인식 기능기와(scrollViewDidScroll 메소드 등을 호출하는) UIPanGestureRecognizer의 제스처 인식기가 모두 붙어있다.
    //스크롤뷰 안 영역에 제스처를 수행했을 때 호출되는 메소드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //제스처 아래에서 위로 (아래로 스크롤 하는 중)
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            // 스크롤뷰 바닥 부분은 팅겨야함
            scrollView.bounces = true
        
        //드래그 방향이 위로 향하는 순간 false로 처리해줘야함
        } else {
            // 상단의 경우 튕기지 않아야함
            scrollView.bounces = false
        }
    }

    //스크롤뷰 안 영역에 드래그가 시작될 타이밍, 터치가 되어있을 때 호출되는 메소드
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            //드래그 시작 타이밍 떄마다 초기화 안해주면 빠르게 위아래 제스처시 상단도 튕길수도 있음
            scrollView.bounces = false
    }
    
    @objc func buttonTapped(){
        print("test btn tapped")
    }
}

