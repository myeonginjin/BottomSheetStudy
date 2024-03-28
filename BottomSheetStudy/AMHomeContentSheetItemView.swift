//
//  AMHomeContentSheetItemView.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/26/24.
//

import Foundation
import UIKit

//바텀시트 영역 내 컨텐트를 보여줄 스크롤뷰
public class AMHomeContentSheetItemView: UIScrollView,  UIGestureRecognizerDelegate {
    
    
    //UIScrollView 내부에서 발생하는 제스처 인식자와 다른 제스처 인식자가 동시에 인식될수 있도록 함. 현 프로젝트에서는 바텀시트 크기를 변경하기 위한 제스처리코그나이저의 제스처 인식도 허용되도록 선언
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
        
    //클래스의 뷰 인스턴스를 프로그래매틱하게 생성할 때 사용하는 초기화
    
    required public init() {
        
        //오토레이아웃으로 후에 크기, 위치 선언할 것아기에 우선 초기 위치 크기 지정x
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
            
        //영역 최상단 혹은 최하단에서 추가로 제스처했을 시 (스크롤뷰가 경계에 도달 했을 시) 스크롤뷰가 튕겨내는 에니메이션 기본값으로 설정 해지
        self.bounces = false
        
        // 스크롤 뷰 내에 버튼들을 담을 스택 뷰 생성
        let stackView = UIStackView()
        //수직 배열
        stackView.axis = .vertical
        // 요소들 간격 동일
        stackView.distribution = .equalSpacing
        // 행에서 가운데 배치
        stackView.alignment = .center
        stackView.spacing = 20 // 버튼 사이의 간격
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        
        // 스택 뷰 제약조건 설정
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor) // 스택 뷰 너비를 스크롤 뷰 너비와 동일하게 설정
        ])
        
        // 스택 뷰의 높이가 스크롤 뷰의 가시 영역을 초과할 수 있도록 임의의 높이 제약 조건 추가
        // 이는 스택 뷰 내의 버튼이 충분히 많을 경우 스크롤이 작동하도록 보장
        let stackViewHeightConstraint = stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        
        //스택 뷰의 높이 제약조건의 우선 순위를 낮춰, 스택 뷰가 내용에 따라 크기를 조정할 수 있도록 함
        stackViewHeightConstraint.priority = .defaultLow
        stackViewHeightConstraint.isActive = true
        
        
        // 버튼 생성 및 스택 뷰에 추가
        for i in 0..<20 {
            let button = UIButton(type: .system)
            button.setTitle("Button \(i+1)", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            
            // 버튼 크기 설정
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            stackView.addArrangedSubview(button)
        }
        
        

    }
    

    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
}
