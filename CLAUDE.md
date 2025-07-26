# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
  - Contains LazyPager for paginated views

- **PinNetwork**: Network abstraction layer
  - Built on Moya framework
  - Custom JSONDecoder with mixed ISO8601 date parsing
  - Extensions for async/await support

### API Architecture Pattern
Follow the comprehensive API architecture guide in `PinModule/API_ARCHITECTURE_GUIDE.md`:

1. **Domain Layer**: Models with Codable, Identifiable, Hashable protocols
2. **Data Layer**: 
   - API definitions using Moya TargetType
   - RemoteDataSource with async/await
   - Repository pattern with protocol abstraction
3. **Dependency Injection**: Use Factory Container for DI registration

### Key Dependencies
- **Kingfisher**: Image loading and caching
- **Moya**: Network abstraction layer
- **Factory**: Dependency injection container

### Platform Support
- iOS 16.0+
- watchOS 8.0+
- macOS 10.15+

## Code Conventions

- Follow existing Swift naming conventions
- Use `public` access for module APIs
- Implement proper protocols (Codable, Identifiable, Hashable) for data models
- Use async/await for network operations
- Register dependencies in Factory Container extensions
- Follow the API architecture pattern for new network modules

## Important Notes

- Network layer uses custom date decoding for mixed ISO8601 formats
- All SwiftUI components are designed for iOS 16+ with modern APIs
- Extensions are organized by framework (Foundation, UIKit, SwiftUI)
- Use existing logging infrastructure (PinLogger) for debugging