//
//  LinkHandlerModifier.swift
//  PinKit
//
//  Created by pinyi Li on 2025/4/18.
//

import SwiftUI

public struct LinkHandler {
    // MARK: Lifecycle

    public init(onMention: ((String) -> Void)? = nil,
                onHashtag: ((String) -> Void)? = nil,
                onLink: ((URL) -> Void)? = nil,
                fallback: ((URL) -> Void)? = nil) {
        self.onMention = onMention
        self.onHashtag = onHashtag
        self.onLink = onLink
        self.fallback = fallback
    }

    // MARK: Public

    public var onMention: ((String) -> Void)?
    public var onHashtag: ((String) -> Void)?
    public var onLink: ((URL) -> Void)?
    public var fallback: ((URL) -> Void)?

    @discardableResult
    public func handle(_ url: URL, openURL: OpenURLAction? = nil) -> OpenURLAction.Result {
        guard let scheme = url.scheme else {
            openURL?(url)
            return .systemAction
        }

        let decoded = url.absoluteString.components(separatedBy: ":").last?.removingPercentEncoding

        switch scheme {
        case "mention":
            if let mention = decoded {
                onMention?(mention)
                return .handled
            }

        case "hashtag":
            if let hashtag = decoded {
                onHashtag?(hashtag)
                return .handled
            }

        case "http",
             "https":
            if let onLink {
                onLink(url)
                return .handled
            }
            openURL?(url)
            return .systemAction

        default:
            break
        }

        fallback?(url)
        return .systemAction
    }
}

public struct LinkHandlerModifier: ViewModifier {
    // MARK: Lifecycle

    public init(handler: LinkHandler) {
        self.handler = handler
    }

    // MARK: Public

    public func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                handler.handle(url, openURL: openURL)
            })
    }

    // MARK: Private

    @Environment(\.openURL) private var openURL

    private let handler: LinkHandler
}

public extension View {
    func handleLinkURL(onLink: ((URL) -> Void)? = nil,
                       onMention: ((String) -> Void)? = nil,
                       onHashtag: ((String) -> Void)? = nil,
                       fallback: ((URL) -> Void)? = nil) -> some View {
        let handler = LinkHandler(
            onMention: onMention,
            onHashtag: onHashtag,
            onLink: onLink,
            fallback: fallback
        )
        return modifier(LinkHandlerModifier(handler: handler))
    }
}
