//
//  ViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

//Hello World

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogginClass.printVCLifeCycleEvent(#function, String(describing: type(of: self)))
        
    }

}

