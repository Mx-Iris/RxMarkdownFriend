//
//  SidebarViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/24.
//

import AppKit
import RxSwift
import RxCocoa

class SidebarViewModel: ViewModel, ViewModelType {
    struct Input {}

    struct Output {
        let items: Observable<[String]>
    }

    let selectedIndex: BehaviorSubject<Int> = .init(value: 0)
    
    func transform(_ input: Input) -> Output {
        let items = Observable<[String]>.just([
            "Document",
            "Code Block",
        ])
        return Output(items: items)
    }
}
