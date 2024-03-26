//
//  AMHomeSheetControll.swift
//  BottomSheetStudy
//
//  Created by 진명인 on 3/26/24.
//

import Foundation
import UIKit





class AMHomeSheetControll: UIScrollView{

    
    weak var actionDelegate: AMHomeSheetControllDelegate?
    
    
    required public init() {
        
        super.init(frame: .zero)
        self.backgroundColor = .brown
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let Tap = UITapGestureRecognizer(target: self, action: #selector(Scroll))
        

        
        self.addGestureRecognizer(Tap)

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
