//
//  MomentlyDetailView.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import SwiftUI

struct MomentlyDetailView: View {

    @ObservedObject var viewModel: MomentlyDetailViewModel
    
    private let imageSizeRatio: CGFloat = 0.45
    private let formSpacing: CGFloat = 34.0
    private let buttonVerticalPadding: CGFloat = 16
    private let selectedImageScale: CGFloat = 0.9
    private let placeholderImageScale: CGFloat = 0.8
    
    // MARK: View Body

    var body: some View {
        ScrollView {
            VStack(spacing: formSpacing) {
                header
                photoSection
                formFields
                ctaButton
            }
            .padding()
        }
        .background(Color.yellow.opacity(0.4))
        // MARK: Date Picker Modal
        .sheet(
            item: Binding<MomentlyPresentation?>(
                get: {
                    if case .datePicker = viewModel.presentation {
                        return .datePicker
                    }
                    return nil
                },
                set: { _ in viewModel.presentation = nil }
            )
        ) { _ in
            DatePickerSheet(date: $viewModel.birthday) {
                viewModel.presentation = nil
            }
        }
        // MARK: Image Picker Modal
        .sheet(
            item: Binding<MomentlyPresentation?>(
                get: {
                    if case .imagePicker = viewModel.presentation {
                        return .imagePicker
                    }
                    return nil
                },
                set: { _ in viewModel.presentation = nil }
            )
        ) { _ in
            ImagePicker(
                sourceType: viewModel.currentSource == .camera ? .camera : .photoLibrary,
                onImagePicked: viewModel.handleImagePicked
            )
        }
        // MARK: Select Photo Source
        .confirmationDialog(
            "Select Photo Source",
            isPresented: Binding(
                get: {
                    if case .photoSourceDialog = viewModel.presentation {
                        return true
                    }
                    return false
                },
                set: { newValue in
                    if !newValue {
                        viewModel.presentation = nil
                    }
                }
            )
        ) {
            Button("Photo Library") {
                Task { await viewModel.prepareImagePicker(for: .photoLibrary) }
            }
            .accessibilityLabel("Choose from photo library")

            Button("Camera") {
                Task { await viewModel.prepareImagePicker(for: .camera) }
            }
            .accessibilityLabel("Take photo with camera")

            Button("Cancel", role: .cancel) {}
                .accessibilityLabel("Cancel action and go back")
        }
        // MARK: Alert
        .alert(
            item: Binding(
                get: {
                    if case .alert = viewModel.presentation {
                        return viewModel.presentation
                    }
                    return nil
                },
                set: { _ in viewModel.presentation = nil }
            )
        ) { item in
            if case let .alert(title, message) = item {
                return Alert(
                    title: Text(title),
                    message: Text(message),
                    dismissButton: .default(Text("OK")) {
                        viewModel.presentation = nil
                    }
                )
            } else {
                return Alert(
                    title: Text("Something went wrong"),
                    message: Text("An unexpected error occurred."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.presentation = nil
                    }
                )
            }
        }
        // MARK: Navigation
        .fullScreenCover(
            item: Binding(
                get: {
                    if case .birthdayScreen = viewModel.presentation {
                        return viewModel.presentation
                    }
                    return nil
                },
                set: { _ in viewModel.presentation = nil }
            )
        ) { item in
            if case let .birthdayScreen(vm) = item {
                MomentlyBirthdayView(viewModel: vm)
            } else {
                EmptyView()
            }
        }
    }

    // MARK: Components

    private var header: some View {
        Text("🍼 Momently")
            .font(.system(size: 34, weight: .heavy, design: .rounded))
            .padding(.top, 20)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("Momently. Baby profile setup")
    }

    private var photoSection: some View {
        GeometryReader { geo in
            let size = geo.size.width * imageSizeRatio
            let selectedImageSizing = size * selectedImageScale
            let placeholderImageSizing = size * placeholderImageScale
            VStack {
                Button(action: {
                    viewModel.showPhotoSourceDialog()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: size, height: size)
                            .shadow(
                                color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: selectedImageSizing, height: selectedImageSizing)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        } else {
                            VStack(spacing: 12) {
                                Image("baby_default_2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: placeholderImageSizing, height: placeholderImageSizing)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Change baby photo")
                .accessibilityHint(
                    "Tap to choose a photo from library or take a new one")
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: UIScreen.main.bounds.width * imageSizeRatio)
    }

    private var formFields: some View {
        VStack(spacing: 20) {
            formField(
                title: "Name",
                content: TextField("Baby's Name", text: $viewModel.babyName)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Enter baby's name")
                    .accessibilityHint("This is the baby's first name")
            )

            formField(
                title: "Birthday",
                content: HStack {
                    Text(viewModel.birthdayDisplay)
                        .foregroundColor(
                            viewModel.birthday == nil ? .gray : .primary)

                    Spacer()

                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.presentation = .datePicker
                }
                .accessibilityElement()
                .accessibilityLabel("Birthday")
                .accessibilityValue(viewModel.birthdayDisplay)
            )
        }
    }

    private var ctaButton: some View {
        Button(action: {
            viewModel.saveAndShowBirthday()
        }) {
            Text("Show Birthday Screen")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, buttonVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            viewModel.isFormComplete
                                ? Color.blue : Color.blue.opacity(0.3))
                )
                .shadow(
                    color: viewModel.isFormComplete
                        ? Color.black.opacity(0.1) : .clear,
                    radius: 4, x: 0, y: 2
                )
                .animation(.easeInOut, value: viewModel.isFormComplete)
        }
        .disabled(!viewModel.isFormComplete)
        .accessibilityLabel("Show birthday screen")
        .accessibilityHint("Saves the profile and opens a birthday-themed screen")
    }
}

extension MomentlyDetailView {
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
