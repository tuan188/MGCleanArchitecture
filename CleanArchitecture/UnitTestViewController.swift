//
//  UnitTestViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/6/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class UnitTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension UnitTestViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
