//
//  ContentView.swift
//  DeFifolio
//
//  Created by Jeremy Kalmus on 2/7/25.
//

import SwiftUI
import SwiftData
import Charts
import WalletConnectSwift

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    // Custom colors
    private let deepBlue = Color(red: 0.02, green: 0.05, blue: 0.1)
    private let darkestBlue = Color(red: 0.01, green: 0.02, blue: 0.05)
    private let accentBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    private let glowBlue = Color(red: 0.2, green: 0.4, blue: 1.0)
    
    // WalletConnect variables
    private var client: WalletConnect!
    @State private var isConnected = false

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [deepBlue, darkestBlue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Subtle glow effect in background
                RadialGradient(
                    gradient: Gradient(colors: [glowBlue.opacity(0.1), Color.clear]),
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: 400
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo/Icon area
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.linearGradient(
                            colors: [glowBlue, accentBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(color: glowBlue.opacity(0.5), radius: 10)
                        .padding(.top, 60)
                    
                    // Welcome Text
                    VStack(spacing: 16) {
                        Text("Welcome to DeFifolio")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Track your DeFi portfolio with\nreal-time analytics")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    // Connect Wallet Button
                    Button(action: connectWallet) {
                        Text(isConnected ? "Connected" : "Connect Wallet")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [accentBlue, glowBlue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: glowBlue.opacity(0.3), radius: 8)
                    }
                    .padding(.horizontal, 20)
                    
                    // Features list
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "wallet.pass.fill", text: "Connect Multiple Wallets", glowColor: glowBlue, accentColor: accentBlue)
                        FeatureRow(icon: "chart.xyaxis.line", text: "Track Performance", glowColor: glowBlue, accentColor: accentBlue)
                        FeatureRow(icon: "bell.badge.fill", text: "Custom Price Alerts", glowColor: glowBlue, accentColor: accentBlue)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    // Get Started Button
                    Button(action: {
                        // Add action for getting started
                    }) {
                        Text("Get Started")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [accentBlue, glowBlue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: glowBlue.opacity(0.3), radius: 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            setupWalletConnect()
        }
    }

    private func setupWalletConnect() {
        client = WalletConnect(delegate: self)
    }

    private func connectWallet() {
        guard let url = URL(string: "https://walletconnect.org") else { return }
        let session = client.connect(to: url)
        isConnected = true
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

// Feature row component
struct FeatureRow: View {
    let icon: String
    let text: String
    let glowColor: Color
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [glowColor, accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

extension ContentView: WalletConnectDelegate {
    func didConnect(session: Session) {
        // Handle successful connection
        print("Connected to wallet: \(session)")
    }

    func didDisconnect(session: Session) {
        // Handle disconnection
        print("Disconnected from wallet: \(session)")
        isConnected = false
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
