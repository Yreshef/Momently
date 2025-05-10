//
//  DatePickerSheet.swift
//  Momently
//
//  Created by Yohai on 10/05/2025.
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var date: Date?
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            DatePicker(
                "",
                selection: Binding(
                    get: { date ?? Date() },
                    set: { date = $0 }
                ),
                in: ...Calendar.current.startOfDay(for: Date()),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            .ignoresSafeArea(.keyboard)

            Button("Done") {
                if date == nil {
                    date = Calendar.current.startOfDay(for: Date())
                }
                onDone()
            }
            .font(.headline)
            .padding(.bottom)
        }
        .padding()
    }
}

#Preview("DatePickerSheet") {
    DatePickerSheet(date: .constant(nil)) {
        print("Done tapped")
    }
}
