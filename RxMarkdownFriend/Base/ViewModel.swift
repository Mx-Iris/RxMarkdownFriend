//
//  ViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import Foundation
import RxSwift

class ViewModel {
    let provider: MarkdownFileProvider
    let disposeBag = DisposeBag()
    
    init(provider: MarkdownFileProvider) {
        self.provider = provider
    }
}
