//
//  MimeType.swift
//  PinNetwork
//
//  Created by pinyi Li on 2025/7/8.
//  Copyright © 2025 yoku. All rights reserved.
//

import Foundation

public enum MimeType: String, CaseIterable {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case multipart = "multipart/form-data"
    case plainText = "text/plain"
    case html = "text/html"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"
    case heic = "image/heic"
    case heif = "image/heif"
    case webp = "image/webp"
    case pdf = "application/pdf"
    case octetStream = "application/octet-stream"
    case mp4 = "video/mp4"
    case mov = "video/quicktime"
    
    public static func from(filename: String) -> MimeType? {
        let fileExtension = (filename as NSString).pathExtension.lowercased()
        switch fileExtension {
        case "json":
            return .json
        case "png":
            return .png
        case "jpg", "jpeg":
            return .jpeg
        case "gif":
            return .gif
        case "heic":
            return .heic
        case "heif":
            return .heif
        case "webp":
            return .webp
        case "pdf":
            return .pdf
        case "mp4":
            return .mp4
        case "mov":
            return .mov
        case "txt":
            return .plainText
        case "html", "htm":
            return .html
        default:
            return .octetStream
        }
    }
    
    public static func from(mimeType: String) -> MimeType? {
        return MimeType(rawValue: mimeType.lowercased())
    }
    
    public var fileExtension: String {
        switch self {
        case .json:
            return "json"
        case .png:
            return "png"
        case .jpeg:
            return "jpg"
        case .gif:
            return "gif"
        case .heic:
            return "heic"
        case .heif:
            return "heif"
        case .webp:
            return "webp"
        case .pdf:
            return "pdf"
        case .mp4:
            return "mp4"
        case .mov:
            return "mov"
        case .plainText:
            return "txt"
        case .html:
            return "html"
        case .formURLEncoded, .multipart, .octetStream:
            return ""
        }
    }
} 
