//
//  MomentlyDetailView.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import SwiftUI

struct MomentlyDetailView: View {

    @ObservedObject var viewModel: MomentlyDetailViewModel

    @State private var isShowingDatePicker = false

    @State private var isShowingImagePicker = false
    @State private var isShowingSourceDialog = false
    @State private var pickerError: PhotoAccessError?
    @State private var isShowingErrorAlert = false
        
    var body: some View {
        ScrollView {
            VStack(spacing: 34) {
                Text("🍼 Momently")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .padding(.top, 20)
                    .accessibilityAddTraits(.isHeader)
                photoSection
                formSection
                Spacer(minLength: 32)
                ctaButton
            }
            .padding([.horizontal])
        }
        .sheet(isPresented: $isShowingDatePicker) {
            VStack(spacing: 16) {
                DatePicker(
                    "Select birthday",
                    selection: Binding(
                        get: { viewModel.birthday ?? Date() },
                        set: { viewModel.birthday = $0 }
                    ),
                    in: ...Calendar.current.startOfDay(for: Date()),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .ignoresSafeArea(.keyboard)

                Button("Done") {
                    if viewModel.birthday == nil {
                        viewModel.birthday = Calendar.current.startOfDay(for: Date())
                    }
                    isShowingDatePicker = false
                }
                .font(.headline)
                .padding(.bottom)
            }
            .padding()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(
                sourceType: viewModel.currentSource == .camera
                    ? .camera : .photoLibrary,
                onImagePicked: { image in
                    Task { @MainActor in
                        viewModel.handleImagePicked(image)
                    }
                }
            )
        }
        .alert(isPresented: $isShowingErrorAlert, error: pickerError) { 
            Button("OK", role: .cancel) { }
        }
        .alert(item: $viewModel.profileError) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        }
    }

    private var photoSection: some View {
        VStack {
            Button(action: {
                isShowingSourceDialog = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 200, height: 200)
                        .shadow(
                            color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 189, height: 190)
                            .clipShape(Circle())
                    } else {
                        VStack(spacing: 12) {
                            Image("baby_default_2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Baby Photo")
            .accessibilityHint("Double tap to select or change baby's photo")
        }
        .confirmationDialog(
            "Select Photo Source", isPresented: $isShowingSourceDialog,
            titleVisibility: .visible
        ) {
            Button("Photo Library") {
                Task {
                    do {
                        try await viewModel.prepareImagePicker(
                            for: .photoLibrary)
                        await MainActor.run { isShowingImagePicker = true }
                    } catch let error as PhotoAccessError {
                        await MainActor.run {
                            pickerError = error
                            isShowingErrorAlert = true
                        }
                    }
                }
            }
            Button("Camera") {
                Task {
                    do {
                        try await viewModel.prepareImagePicker(
                            for: .camera)
                        await MainActor.run {
                            isShowingImagePicker = true
                        }
                    } catch let error as PhotoAccessError  {
                        await MainActor.run {
                            pickerError = error
                            isShowingErrorAlert = true
                        }
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            formField(
                title: "Name",
                content: TextField("Baby's Name", text: $viewModel.babyName)
                    .textContentType(.name)
                    .autocorrectionDisabled()
            )

            formField(
                title: "Birthday",
                content: HStack {
                    Text(
                        viewModel.birthday?.formatted(
                            date: .abbreviated, time: .omitted)
                            ?? "Select a date"
                    )
                    .foregroundColor(
                        viewModel.birthday == nil ? .gray : .primary)

                    Spacer()

                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())  // makes whole row tappable
                .onTapGesture {
                    isShowingDatePicker = true
                }
            )
        }
    }

    private var ctaButton: some View {
        Button(action: {
            viewModel.saveProfile()
        }) {
            Text("Show Birthday Screen")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            viewModel.isFormValid
                                ? Color.blue : Color.blue.opacity(0.3))
                )
                .shadow(
                    color: viewModel.isFormValid
                        ? Color.black.opacity(0.1) : .clear,
                    radius: 4, x: 0, y: 2
                )
                .animation(.easeInOut, value: viewModel.isFormValid)
        }
    }

    private func formField<Content: View>(title: String, content: Content)
        -> some View
    {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)

            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
}

#Preview {
    MomentlyDetailView(viewModel: PreviewViewModelFactory.makeDetailViewModel())
}
