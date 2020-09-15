//
//  ViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogginClass.printVCLifeCycleEvent(nil, #function, String(describing: type(of: self)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogginClass.printVCLifeCycleEvent("\(String(describing: type(of: self))) moved from <Disappeared> to <Appearing>", #function, String(describing: type(of: self)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogginClass.printVCLifeCycleEvent("\(String(describing: type(of: self))) moved from <Appearing> to <Appeared>", #function, String(describing: type(of: self)))
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        LogginClass.printVCLifeCycleEvent(nil, #function, String(describing: type(of: self)))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogginClass.printVCLifeCycleEvent(nil, #function, String(describing: type(of: self)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogginClass.printVCLifeCycleEvent("\(String(describing: type(of: self))) moved from <Appeared> to <Disappearing>", #function, String(describing: type(of: self)))
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogginClass.printVCLifeCycleEvent("\(String(describing: type(of: self))) moved from <Disappearing> to <Disappeared>", #function, String(describing: type(of: self)))
        
    }

}

