# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## iOS Development Guidelines

**Target**: Follow iOS 17 strictly. Use only SwiftUI and system APIs available in iOS 17 — no higher, no lower.

**Architecture**: Follow Clean Architecture with Data/Domain/Presentation layers as defined in `Docs/API_ARCHITECTURE_GUIDE.md`

**Models**: All domain models must implement `Codable`, `Identifiable`, and `Hashable`

## SwiftUI Architecture

- **State Management**: Use `@Observable` classes instead of ViewModels. Use `@State`/`@Binding` for view state, `@Environment` for dependencies
- **Views**: Split into small, focused components with clear state responsibilities  
- **Dependencies**: Inject via SwiftUI Environment (Repository, APIClient, etc.)
- **Testing**: Test business logic in service/network layers, not in Views

## Project Overview

PinKit is a Swift Package Manager library organized into three main modules:
- **PinCore**: Core utilities, extensions, SwiftUI components, and helpers
- **PinModule**: Higher-level UI components and utilities with dependency injection
- **PinNetwork**: Network layer with Moya integration and API utilities

## Development Commands

This is a Swift Package Manager project. Common development tasks:

### Building
```bash
swift build
```

### Testing
```bash
swift test
```

### Xcode Integration
Open Package.swift in Xcode or add as dependency to an iOS/macOS project.

## Architecture

### Module Structure
- **PinCore**: Foundation layer with extensions, SwiftUI components, and utilities
  - `Extension/`: Swift standard library and Foundation extensions
  - `SwiftUI/`: SwiftUI views, modifiers, and extensions
  - `Helper/`: Utility classes (permissions, logging, toast)
  - `PropertyWrapper/`: Custom property wrappers

- **PinModule**: Application-level components and dependency injection
  - Depends on PinCore and PinNetwork
  - Uses Factory for dependency injection

- **PinNetwork**: Network abstraction layer
  - Built on Moya framework
  - Custom JSONDecoder with mixed ISO8601 date parsing
  - Extensions for async/await support

### Key Dependencies
- **Kingfisher**: Image loading and caching
- **Moya**: Network abstraction layer
- **Factory**: Dependency injection container

## Important Notes

- Network layer uses custom date decoding for mixed ISO8601 formats
- Extensions are organized by framework (Foundation, UIKit, SwiftUI)
- Use existing logging infrastructure (PinLogger) for debugging
- **Colors**: Define in `Assets.xcassets` with light/dark variants, access via `Color(appColor: .colorName)`
- **Images**: Use `KingfisherImageView` for remote URLs, SF Symbols for icons, `Image(appImage: .imageName)` for assets
- **Fonts**: Always use `.systemFont(size: _, weight: _)`
- **DI**: For singleton services, use Factory pattern with Container for injection. Prefer direct injection for other dependencies.

## Project Structure

e.g.
```
PinModule/               # module
├── Calendar/              # Calendar feature module
│   ├── Data/
│   │   ├── DataSource/Remote/  # API definitions (using Moya)
│   │   └── Repository/         # Repository protocols and implementations
│   ├── Domain/                 # Data models (Codable, Identifiable, Hashable)
│   └── Presentation/View/      # SwiftUI views
├── Settings/              # Settings feature module
│   ├── Data/
│   ├── Domain/
│   └── Presentation/View/
├── Shared/                # Shared components
│   ├── Views/             # Reusable UI components
│   └── Extensions/        # Swift extensions
└── Resources/             # Assets (colors, images, etc.)
```
