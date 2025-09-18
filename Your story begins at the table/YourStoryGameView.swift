import Foundation
import SwiftUI

struct YourStoryEntryScreen: View {
    @StateObject private var loader: YourStoryWebLoader

    init(loader: YourStoryWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            YourStoryWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                YourStoryProgressIndicator(value: percent)
            case .failure(let err):
                YourStoryErrorIndicator(err: err)
            case .noConnection:
                YourStoryOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct YourStoryProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            YourStoryLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct YourStoryErrorIndicator: View {
    let err: String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct YourStoryOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
