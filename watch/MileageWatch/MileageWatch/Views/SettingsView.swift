import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: MileageViewModel
    @State private var emailInput: String = ""

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
                }
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            emailInput = viewModel.userEmail
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
        .environmentObject(MileageViewModel())
}
