import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ZeroClickViewModel
    @State private var emailInput: String = ""
    @State private var showingDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text("Instellingen")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    TextField("je@email.nl", text: $emailInput)
                        .textContentType(.emailAddress)
                        .font(.caption)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                Button(action: saveEmail) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Opslaan")
                    }
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)

                if !viewModel.userEmail.isEmpty {
                    VStack(spacing: 4) {
                        Text("Ingelogd als:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(viewModel.userEmail)
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)

                    Button(action: { Task { await viewModel.refreshAll() } }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Ververs")
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                    // Delete Account button
                    Button(role: .destructive, action: { showingDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Account verwijderen")
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.red)
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            emailInput = viewModel.userEmail
        }
        .alert("Account verwijderen?", isPresented: $showingDeleteConfirmation) {
            Button("Annuleren", role: .cancel) { }
            Button("Verwijderen", role: .destructive) {
                Task {
                    await viewModel.deleteAccount()
                }
            }
        } message: {
            Text("Dit verwijdert permanent al je gegevens.")
        }
    }

    private func saveEmail() {
        viewModel.userEmail = emailInput
        UserDefaults.standard.set(emailInput, forKey: "userEmail")
        Task {
            await viewModel.refreshAll()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ZeroClickViewModel())
}
