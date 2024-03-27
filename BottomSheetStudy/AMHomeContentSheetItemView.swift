//
//  AMHomeContentSheetItemView.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/26/24.
//

import Foundation
import UIKit

public class AMHomeContentSheetItemView: UIScrollView  {

    
        
    
    required public init() {
        
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        
        self.translatesAutoresizingMaskIntoConstraints = false

        
        // 스크롤 뷰 내에 버튼들을 담을 스택 뷰 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
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
        // 이는 스택 뷰 내의 버튼이 충분히 많을 경우 스크롤이 작동하도록 보장합니다.
        let stackViewHeightConstraint = stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        stackViewHeightConstraint.priority = .defaultLow // 중요도를 낮춰서 스택 뷰가 내용에 따라 늘어날 수 있도록 함
        stackViewHeightConstraint.isActive = true
        
        
        // 버튼 생성 및 스택 뷰에 추가
        for i in 0..<7 {
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
