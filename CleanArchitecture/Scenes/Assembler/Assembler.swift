//
//  Assembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

protocol Assembler: class,
    RepositoriesAssembler,
    AppAssembler,
    MainAssembler,
    ReposAssembler {
    
}

class DefaultAssembler: Assembler {
    
}
