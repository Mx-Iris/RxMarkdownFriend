//
//  CodeBlockModels.swift
//  MarkdownFriend
//
//  Created by JH on 2023/6/4.
//

import AppKit
import Markdown
import SwiftFormat
import UniformTypeIdentifiers

protocol CodeFormatter: MarkupRewriter {
    var configuration: URL? { set get }
}

enum CodeBlockModels {
    enum SupportedLanguage: String, CaseIterable {
        case swift = "Swift"
    }

    enum SupportedFormatter: String, CaseIterable {
        case swiftFormat = "SwiftFormat"
        var contentType: UTType {
            switch self {
            case .swiftFormat:
                return .swiftformat
            }
        }
    }

    struct SwiftCodeFormatter: MarkupRewriter, CodeFormatter {
        var configuration: URL? {
            didSet {
                if let configuration = configuration,
                   let data = try? Data(contentsOf: configuration),
                   let args = try? parseConfigFile(data),
                   let options = try? formatOptionsFor(args) {
                    self.options = options
                }
            }
        }

        var options: FormatOptions?

        mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Markup? {
            guard let formatCode = try? format(codeBlock.code, options: options ?? .default) else {
                return defaultVisit(codeBlock)
            }
            return CodeBlock(language: "swift", formatCode)
        }
    }

    struct Committer {
        let url: URL
        var configuration: URL?
        let formatter: SupportedFormatter

        func commit() -> String? {
            guard let source = try? String(contentsOf: url) else { return nil }

            let document = Document(parsing: source)

            var codeFormatter: any CodeFormatter

            switch formatter {
            case .swiftFormat:
                codeFormatter = SwiftCodeFormatter()
            }

            codeFormatter.configuration = configuration

            let newDocument = codeFormatter.visit(document) as! Document

            return newDocument.format()
        }
    }
}

extension UTType {
    static let swiftformat = UTType(filenameExtension: "swiftformat")!
}
