//
//  ActivityView.swift
//  PinKit
//
//  Created by 賀華 on 2025/3/10.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context _: Context) -> some UIViewController {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        activityController.completionWithItemsHandler = { (_: UIActivity.ActivityType?, completed: Bool, _: [Any]?, error: Error?) in

            if let error {
                Utils.toast(error.localizedDescription)
                return
            }

            if completed {
                Utils.toast(.localizable(.share_success))
            }
        }
        return activityController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}
}
