//
//  AMHomeSheetControll.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/26/24.
//

import Foundation
import UIKit





class AMHomeSheetControll: UIView{

    
    weak var actionDelegate: AMHomeSheetControllDelegate?
    
    

    let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let radiusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    
    required public init() {
        
        super.init(frame: .zero)
        self.backgroundColor = .brown
        
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let Tap = UITapGestureRecognizer(target: self, action: #selector(Scroll))
        

        
        self.addGestureRecognizer(Tap)
        
        self.addSubview(dragIndicatorView)
        dragIndicatorView.addSubview(radiusBar)
        
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        radiusBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dragIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dragIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            dragIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            
            radiusBar.widthAnchor.constraint(equalToConstant: 60),
            radiusBar.heightAnchor.constraint(equalToConstant: radiusBar.layer.cornerRadius * 2),
            radiusBar.centerXAnchor.constraint(equalTo: dragIndicatorView.centerXAnchor),
            radiusBar.centerYAnchor.constraint(equalTo: dragIndicatorView.centerYAnchor),
        ])
        

    }
    

    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func Scroll() {
        actionDelegate?.didScroll()
    }
    
}





protocol AMHomeSheetControllDelegate: AnyObject {
    func didScroll()
}
