//
//  LoginView.swift
//  PinModule
//
//  Created by Claude on 2025/7/27.
//

import SwiftUI

public struct LoginView: View {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background
                backgroundGradient

                ScrollView {
                    VStack(spacing: 40) {
                        Spacer(minLength: 40)

                        headerSection

                        loginButtonsSection

                        Spacer(minLength: 30)

                        footerSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
            }
        }
        .alert("登入錯誤", isPresented: .constant(viewModel.showError)) {
            Button("確定") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .disabled(viewModel.isLoading)
    }

    // MARK: Private

    @Environment(LoginViewModel.self) private var viewModel

    // MARK: - View Components

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.1),
                Color.purple.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("歡迎使用")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text("選擇登入方式以繼續")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var loginButtonsSection: some View {
        VStack(spacing: 16) {
            // Apple Sign In
            LoginButton(
                platform: .apple,
                isLoading: viewModel.isAppleLoading,
                isEnabled: !viewModel.isLoading
            ) {
                await viewModel.loginWithApple()
            }

            // Google Sign In
            LoginButton(
                platform: .google,
                isLoading: viewModel.isGoogleLoading,
                isEnabled: !viewModel.isLoading
            ) {
                await viewModel.loginWithGoogle()
            }
        }
    }

    private var footerSection: some View {
        VStack(spacing: 12) {
            Text("繼續即表示您同意我們的")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Button("服務條款") {
                    // Handle terms
                }
                .font(.caption)
                .foregroundStyle(.blue)

                Text("和")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("隱私政策") {
                    // Handle privacy
                }
                .font(.caption)
                .foregroundStyle(.blue)
            }
        }
    }
}

// MARK: - Login Button Component

private struct LoginButton: View {
    // MARK: Internal

    let platform: LoginPlatform
    let isLoading: Bool
    let isEnabled: Bool
    let action: () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(foregroundColor)
                } else {
                    platform.icon.image
                        .font(.title3)
                        .fontWeight(.medium)
                }

                Text("使用 \(platform.displayName) 登入")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: strokeWidth)
            )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }

    // MARK: Private

    private var backgroundColor: Color {
        switch platform {
        case .apple:
            return .black
        case .google:
            return .white
        }
    }

    private var foregroundColor: Color {
        switch platform {
        case .apple:
            return .white
        case .google:
            return .black
        }
    }

    private var borderColor: Color {
        switch platform {
        case .apple:
            return .clear
        case .google:
            return .gray.opacity(0.3)
        }
    }

    private var strokeWidth: CGFloat {
        switch platform {
        case .apple:
            return 0
        case .google:
            return 1
        }
    }
}

#Preview {
    let viewModel = LoginViewModel(
        authRepository: AuthRepository(
            appleDataSource: AppleAuthDataSource(),
            googleDataSource: GoogleAuthDataSource()
        )
    )

    LoginView()
        .environment(viewModel)
}
