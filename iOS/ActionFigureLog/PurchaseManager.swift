import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published var isPro: Bool = false
    @Published var products: [Product] = []

    static let proProductID = "com.shimondeitel.actionfigurelog.pro.monthly"

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                if case .verified(let transaction) = update {
                    await self?.handle(transaction)
                }
            }
        }
        Task { await self.loadProducts() }
        Task { await self.refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.proProductID])
        } catch {
            products = []
        }
    }

    func purchasePro() async {
        guard let product = products.first else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await handle(transaction)
                }
            default:
                break
            }
        } catch {
            // purchase failed or cancelled
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func handle(_ transaction: Transaction) async {
        isPro = true
        await transaction.finish()
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.proProductID {
                isPro = true
            }
        }
    }
}
