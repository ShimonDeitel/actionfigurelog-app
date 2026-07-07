import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 44))
                .foregroundStyle(Theme.accent)
            Text("ActionFigureLog Pro")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.ink)
            Text("Wave-completion tracker and carded-value notes")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.inkMuted)
                .padding(.horizontal, 32)

            if let product = purchases.products.first {
                Text("\(product.displayPrice) / month")
                    .font(Theme.headlineFont)
                    .foregroundStyle(Theme.ink)
            }

            Button {
                Task { await purchases.purchasePro() }
            } label: {
                Text("Unlock Pro")
                    .font(Theme.headlineFont)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accent)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .accessibilityIdentifier("paywallUnlockButton")
            .padding(.horizontal, 32)

            Button("Restore Purchases") {
                Task { await purchases.restore() }
            }
            .accessibilityIdentifier("paywallRestoreButton")
            .font(Theme.bodyFont)
            .foregroundStyle(Theme.inkMuted)

            Spacer()

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("paywallDismissButton")
                .foregroundStyle(Theme.inkMuted)
                .padding(.bottom, 16)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}
