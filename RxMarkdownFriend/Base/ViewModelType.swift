//
//  ViewModelType.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/24.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}



