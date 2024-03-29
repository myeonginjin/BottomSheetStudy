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

    // 바텀시트를 무조건적으로 올렷다 내렷다 할 수 있는 영역의 뷰
    let dragIndicatorView: UIView = {
        let view = UIView()
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
        initLayouts()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func commonInit(){
        self.backgroundColor = .brown
        
        //모서리 곡률 반경 지정
        self.layer.cornerRadius = 10
        //왼쪽 상단과 오른쪽 상단에만 적용
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //이 뷰에 붙을 서브뷰들이 경계를 벗어나 곡률 처리된 영역을 침범할 경우 잘라내도록 설정
        self.clipsToBounds = true
        
        self.addSubview(dragIndicatorView)
        dragIndicatorView.addSubview(handleBar)
        
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        handleBar.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    open func initLayouts(){
        var constraints = [NSLayoutConstraint]()
        
        constraints += [
            dragIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dragIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dragIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 30)

        ]
        
        constraints += [
            handleBar.centerXAnchor.constraint(equalTo: dragIndicatorView.centerXAnchor),
            handleBar.centerYAnchor.constraint(equalTo: dragIndicatorView.centerYAnchor),
            handleBar.heightAnchor.constraint(equalToConstant: handleBar.layer.cornerRadius * 2),
            handleBar.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}




