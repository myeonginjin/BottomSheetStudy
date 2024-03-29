//
//  AMHomeSheetControll.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/26/24.
//

import Foundation
import UIKit




// 커스텀 바텀시트
class AMHomeSheetControl: UIView{

    
    //해당 프로토콜은 didScroll 메소드를 구현하도록(채택하도록) 요구하는 프로토콜. 준수해야할 클래스 타입은 AnyObject(어느 객체든 가능),
    // didScroll 메소드는 AMHomeSheetControll객체가 UITapGestureRecognizer에 의해 클릭이 감지됐을 때 호출되는 handleTapGesture메소드에 의해 호출.
    weak var actionDelegate: AMHomeSheetControllDelegate?
    
        
    
    // 바텀시트를 무조건적으로 올렷다 내렷다 할 수 있는 영역의 뷰
    let dragIndicatorView: UIView = {
        let view = UIView()
        
        //UI 디버깅 용 하드코딩
        view.backgroundColor = .blue
        
        return view
    }()
    
    // dragIndicatorView 영역을 인지할 수 있도록 해주는 손잡이 부분
    let handleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    
    required public init() {
        
        super.init(frame: .zero)
        self.backgroundColor = .brown
        
        //모서리 곡률 반경 지정
        self.layer.cornerRadius = 10
        //왼쪽 상단과 오른쪽 상단에만 적용
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //이 뷰에 붙을 서브뷰들이 경계를 벗어나 곡률 처리된 영역을 침범할 경우 잘라내도록 설정
        self.clipsToBounds = true
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        //UITapGestureRecognizer를 통해 해당 뷰 객체가 클릭이 인식될 경우 handleTapGesture메소드 호출하도록 선언
        let Tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(Tap)
        
        
        
        self.addSubview(dragIndicatorView)
        dragIndicatorView.addSubview(handleBar)
        
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        handleBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dragIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dragIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            dragIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            
            handleBar.widthAnchor.constraint(equalToConstant: 60),
            handleBar.heightAnchor.constraint(equalToConstant: handleBar.layer.cornerRadius * 2),
            handleBar.centerXAnchor.constraint(equalTo: dragIndicatorView.centerXAnchor),
            handleBar.centerYAnchor.constraint(equalTo: dragIndicatorView.centerYAnchor),
        ])
        

    }
    

    
    //스위프트의 UIView 클래스를 상속받은 클래스가 인터페이스 빌더(IB)나 스토리보드에서 사용될 때 필요한 초기화 경로
    required public init?(coder: NSCoder) {
        //fatalError("init(coder:)이 메서드가 호출되면 애플리케이션이 크래시되도록 강제. 해당 클래스의 인스턴스가 스토리보드 또는 XIB 파일을 통해 생성되는 것을 의도하지 않았음을 나타냄. 이 클래스는 코드를 통해서만 인스턴스화되어야 한다는 것을 의미.
        //즉, 스토리보드나 XIB를 사용하여 인스턴스화되는 것을 원하지 않는 클래스에 대한 명확한 신호로 작용
        //스토리보드나 XIB 파일을 사용하여 이 클래스의 인스턴스를 생성하려할 때 막는 기능도 있음
        fatalError("init(coder:) has not been implemented")
    }
    
    //UITapGestureRecognizer에 의해 제스처가 인식됐을 경우 호출되는 메서드
    @objc func handleTapGesture() {
        //델리게이트의 didScroll메서드를 호출하도록 구현
        actionDelegate?.didScroll()
    }
    
    
    
}



//해당 클래스의 인스턴스를 생성하고 싶다면 이 프로토콜을 준수해야됨. 이 프로토콜은 AnyObject타입이 채택할 수 있고, didScroll 메소드를 채택해 코드 몸체 부분을 구현해야됨.
protocol AMHomeSheetControllDelegate: AnyObject {
    func didScroll()
}
