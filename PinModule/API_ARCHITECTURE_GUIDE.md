# API 架構建構指南

本文件說明如何建構新的 API 模組，包含 API、DataSource、Repository 等結構設計。

## 📁 資料夾結構

每個新的功能模組應該遵循以下資料夾結構：

```
YourModule/
├── Data/
│   ├── DataSource/
│   │   └── Remote/
│   │       ├── YourModuleAPI.swift
│   │       └── YourModuleRemoteDataSource.swift
│   └── Repository/
│       └── YourModuleRepository.swift
├── Domain/
│   ├── YourModel.swift
│   └── YourResponse.swift
└── Presentation/
    ├── View/
    └── ViewModel/
```

## 🏗️ 架構層級說明

### 1. Domain Layer (領域層)
**路徑**: `YourModule/Domain/`
**職責**: 定義業務邏輯和資料模型

#### 範例: Post.swift
```swift
public struct PostResponse: Decodable {
    public let data: [Post]?
    public let next: String?
}

public class Post: Identifiable, Hashable, Codable {
    public var postId: String?
    public var author: User?
    public var text: String?
    // ... 其他屬性
    
    // 實作 Codable, Hashable, Identifiable
}
```

**建構要點**:
- ✅ 實作 `Codable` 協議以支援 JSON 解析
- ✅ 如需在 UI 中使用，實作 `Identifiable`
- ✅ 如需比較或作為 Dictionary key，實作 `Hashable`
- ✅ 使用 `CodingKeys` 映射 API 欄位名稱

### 2. Data Layer (資料層)

#### 2.1 Remote DataSource
**路徑**: `YourModule/Data/DataSource/Remote/`

##### API 定義 (YourModuleAPI.swift)
```swift
import Foundation
import Moya

private let config = Container.shared.appManager().config!

enum YourModuleAPI {
    case getItems(page: Int, limit: Int)
    case createItem(item: YourModel)
}

extension YourModuleAPI: TargetType {
    var baseURL: URL {
        let constantsApi = config.constantsAPI
        let urlPath: String = switch Utils.currentEnv {
        case .prod: constantsApi.prodUrl
        case .dev: constantsApi.devUrl
        case .custom: UserDefaults.adminCustomUrl ?? ""
        }
        return URL(string: urlPath)!
    }
    
    var path: String {
        switch self {
        case .getItems:
            return "/your-endpoint"
        case .createItem:
            return "/your-endpoint"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getItems:
            return .get
        case .createItem:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getItems(let page, let limit):
            return .requestParameters(
                parameters: ["page": page, "limit": limit],
                encoding: URLEncoding.queryString
            )
        case .createItem(let item):
            // 將模型轉換為參數
            let encoder = JSONEncoder()
            let data = try! encoder.encode(item)
            let dict = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        let appInfo = config.appInfo
        let accessToken = UserDefaults.accessToken ?? ""
        return [
            "Content-Type": "application/json",
            "Authorization": accessToken,
            "app_version": appInfo.appVersion,
            "app_build": appInfo.buildVersion,
            "system": appInfo.systemName,
            "system_version": appInfo.systemVersion,
            "device": appInfo.device,
            "platform": appInfo.platform
        ]
    }
}
```

**建構要點**:
- ✅ 使用 `Moya` 框架定義 API endpoints
- ✅ 支援多環境配置 (prod/dev/custom)
- ✅ 統一的 headers 設定包含認證和裝置資訊
- ✅ 根據 HTTP 方法選擇適當的參數編碼方式

##### Remote DataSource (YourModuleRemoteDataSource.swift)
```swift
import Moya
import PinNetwork

public final class YourModuleRemoteDataSource {
    
    func getItems(page: Int, limit: Int) async throws -> [YourModel] {
        try await provider.decodeRequest(.getItems(page: page, limit: limit))
    }
    
    func createItem(item: YourModel) async throws -> YourModel {
        try await provider.decodeRequest(.createItem(item: item))
    }
    
    private let provider = MoyaProvider<YourModuleAPI>(plugins: [StatusCodePlugin()])
}
```

**建構要點**:
- ✅ 使用 `async/await` 語法
- ✅ 區分 `decodeRequest` (需要解析回應) 和 `request` (無需解析)
- ✅ 加入 `StatusCodePlugin` 處理 HTTP 狀態碼

#### 2.2 Repository
**路徑**: `YourModule/Data/Repository/`

```swift
import Foundation

public protocol YourModuleRepositoryProtocol {
    func getItems(page: Int, limit: Int) async throws -> [YourModel]
    func createItem(item: YourModel) async throws -> YourModel
}

class YourModuleRepository: YourModuleRepositoryProtocol {
    
    init(remoteDataSource: YourModuleRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getItems(page: Int, limit: Int) async throws -> [YourModel] {
        try await remoteDataSource.getItems(page: page, limit: limit)
    }
    
    func createItem(item: YourModel) async throws -> YourModel {
        try await remoteDataSource.createItem(item: item)
    }
    
    private let remoteDataSource: YourModuleRemoteDataSource
}
```

**建構要點**:
- ✅ 定義 Protocol 便於測試和抽象
- ✅ Repository 作為業務邏輯和資料來源的橋樑
- ✅ 封裝 Remote DataSource，提供統一的資料存取介面

### 3. Dependency Injection (依賴注入)

在 Repository 文件底部加入 Container 擴展：

```swift
// MARK: - Container
public extension Container {
    var yourModuleRemoteDataSource: Factory<YourModuleRemoteDataSource> {
        self { YourModuleRemoteDataSource() }.singleton
    }
    
    var yourModuleRepository: Factory<YourModuleRepositoryProtocol> {
        self {
            YourModuleRepository(
                remoteDataSource: self.yourModuleRemoteDataSource()
            )
        }
        .singleton
    }
}
```

## 🎯 使用範例

### 在 ViewModel 中使用
```swift
class YourModuleViewModel: ObservableObject {
    @Published var items: [YourModel] = []
    @Published var isLoading = false
    
    private let repository: YourModuleRepositoryProtocol
    
    init(repository: YourModuleRepositoryProtocol = Container.shared.yourModuleRepository()) {
        self.repository = repository
    }
    
    func loadItems() {
        Task {
            await MainActor.run { isLoading = true }
            do {
                let fetchedItems = try await repository.getItems(page: 1, limit: 20)
                await MainActor.run {
                    self.items = fetchedItems
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    // 處理錯誤
                }
            }
        }
    }
}
```

## ✅ 檢查清單

建構新 API 模組時，請確認以下項目：

### Domain Layer
- [ ] 定義主要資料模型
- [ ] 實作 `Codable` 協議
- [ ] 適當實作 `Identifiable` 和 `Hashable`
- [ ] 設定正確的 `CodingKeys`

### Data Layer - API
- [ ] 定義所有必要的 API endpoints
- [ ] 支援多環境配置
- [ ] 設定正確的 HTTP 方法
- [ ] 配置適當的參數編碼
- [ ] 包含完整的 headers

### Data Layer - DataSource
- [ ] Remote DataSource 使用 `async/await`
- [ ] 區分 `decodeRequest` 和 `request`
- [ ] 加入 `StatusCodePlugin`

### Data Layer - Repository
- [ ] 定義 Repository Protocol
- [ ] 實作具體 Repository 類別
- [ ] 封裝 Remote DataSource
- [ ] 在 Container 中註冊依賴注入

### 測試
- [ ] 為 Repository 創建 Mock 實作
- [ ] 撰寫單元測試
- [ ] 測試錯誤處理情況

## 🔧 工具和框架

- **網路請求**: [Moya](https://github.com/Moya/Moya)
- **依賴注入**: Factory (Container)
- **網路層**: PinNetwork module

遵循此架構指南可以確保代碼的一致性、可測試性和可維護性。 
