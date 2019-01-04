//
//  Assembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

protocol Assembler: class,
    MainAssembler,
    ReposAssembler,
    EditProductAssembler,
    ProductsAssembler,
    ProductDetailAssembler,
    SectionedProductsAssembler,
    StaticProductDetailAssembler,
    DynamicEditProductAssembler,
    RepositoriesAssembler,
    AppAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
