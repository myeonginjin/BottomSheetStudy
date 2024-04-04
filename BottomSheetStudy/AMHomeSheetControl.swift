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
    var dragIndicatorView = UIView()
    // dragIndicatorView 영역을 인지할 수 있도록 해주는 손잡이 부분
    var handleBar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        initViews()
    
        initLayouts()
    }
    
    func initViews(){
        initDragIndicatorView()
        
        initHandleBar()
        
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
    
    func initDragIndicatorView(){
        let dragIndicatorView = UIView()
        dragIndicatorView.backgroundColor = .blue
        self.dragIndicatorView = dragIndicatorView
    }
    
    func initHandleBar(){
        let handleBar = UIView()
        handleBar.backgroundColor = .white
        handleBar.layer.cornerRadius = 3
        self.handleBar = handleBar
    }
    
    func initLayouts(){
        var constraints = [NSLayoutConstraint]()
        
        if let dragIndicatorViewConstraints = self.dragIndicatorViewConstraints() {
            constraints += dragIndicatorViewConstraints
        }
        
        if let handleBarConstraints = self.handleBarConstraints() {
            constraints += handleBarConstraints
        }
            
        NSLayoutConstraint.activate(constraints)
    }
    
    func dragIndicatorViewConstraints() -> [NSLayoutConstraint]? {
        return [dragIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                dragIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                dragIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
                dragIndicatorView.heightAnchor.constraint(equalToConstant: 30)]
    }
    
    func handleBarConstraints() -> [NSLayoutConstraint]? {
        return[handleBar.centerXAnchor.constraint(equalTo: dragIndicatorView.centerXAnchor),
               handleBar.centerYAnchor.constraint(equalTo: dragIndicatorView.centerYAnchor),
               handleBar.heightAnchor.constraint(equalToConstant: handleBar.layer.cornerRadius * 2),
               handleBar.widthAnchor.constraint(equalToConstant: 60)
        ]
    }
    
    func sheetPanMinTopConstant() -> CGFloat {
        return 80.0
    }
    
    func defaultHeight() -> CGFloat {
        return 450.0
    }
    
    func sheetPanMinBottomConstant() -> CGFloat {
        return 100.0
    }
}




