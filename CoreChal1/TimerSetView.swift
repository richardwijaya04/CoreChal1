//
//  TimerSetView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI

struct TimerSetView: View {
    @State private var hours: Int
    @State private var minutes: Int
    @State private var seconds: Int
    @State private var breakMinutes: Int
    @State private var tempHours: Int = 0
    @State private var tempMinutes: Int = 0
    @State private var tempSeconds: Int = 0
    @State private var tempBreakMinutes: Int = 5
    @State private var showTimePicker: Bool = false
    @State private var showBreakPicker: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var selectedLabel: String = "None"
    @State private var labels: [String] = ["None", "Work", "Study", "Exercise"]
    @State private var showLabelPicker: Bool = false
    @State private var showAddLabelModal: Bool = false
    @State private var newLabel: String = ""
    
    @State private var selectedTimerEndOption: String
    @State private var showTimerEndPicker: Bool = false
    private let timerEndOptions = ["Vibrate", "Notification Only", "Ringing"]
    
    @State private var vibrateOn: Bool = true
    
    init() {
        let savedHours = UserDefaults.standard.integer(forKey: "timerHours")
        let savedMinutes = UserDefaults.standard.integer(forKey: "timerMinutes")
        let savedSeconds = UserDefaults.standard.integer(forKey: "timerSeconds")
        let savedBreakMinutes = UserDefaults.standard.integer(forKey: "breakMinutes")
        
        _hours = State(initialValue: savedHours)
        _minutes = State(initialValue: savedMinutes)
        _seconds = State(initialValue: savedSeconds)
        _breakMinutes = State(initialValue: savedBreakMinutes != 0 ? savedBreakMinutes : 5)
        
        if let savedLabels = UserDefaults.standard.array(forKey: "labels") as? [String] {
            _labels = State(initialValue: savedLabels)
        }
        
        let savedTimerEndOption = UserDefaults.standard.string(forKey: "timerEndOption") ?? "Vibrate"
        _selectedTimerEndOption = State(initialValue: savedTimerEndOption)
    }
    
    var body: some View {
        ZStack {
            Color.primary
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Timer")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.leading, 15)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Button(action: {
                        tempHours = hours
                        tempMinutes = minutes
                        tempSeconds = seconds
                        showTimePicker.toggle()
                    }) {
                        Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                            .font(.system(size: 60, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    
                    Button(action: {
                        tempBreakMinutes = breakMinutes
                        showBreakPicker.toggle()
                    }) {
                        HStack {
                            Text("\(breakMinutes)m break")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 13)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                
                Button(action: {
                    UserDefaults.standard.set(hours, forKey: "timerHours")
                    UserDefaults.standard.set(minutes, forKey: "timerMinutes")
                    UserDefaults.standard.set(seconds, forKey: "timerSeconds")
                    UserDefaults.standard.set(breakMinutes, forKey: "breakMinutes")
                    UserDefaults.standard.set(selectedLabel, forKey: "timerLabel")
                    UserDefaults.standard.set(selectedTimerEndOption, forKey: "timerEndOption")
                    
                    print("Timer set: \(hours)h \(minutes)m \(seconds)s, Break: \(breakMinutes)m, Label: \(selectedLabel), When Timer Ends: \(selectedTimerEndOption)")
                    
                    // Kirim notifikasi ke TimerView
                    NotificationCenter.default.post(name: NSNotification.Name("TimerSetNotification"), object: nil)
                    
                    showAlert = true
                }) {
                    Text("Set")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Timer Ready!"),
                        message: Text("Your timer has been set successfully. Let's get to work!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        showLabelPicker.toggle()
                    }) {
                        HStack {
                            Text("Label")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text(selectedLabel)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                    }
                    
                    Button(action: {
                        showTimerEndPicker.toggle()
                    }) {
                        HStack {
                            Text("When Timer Ends")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text(selectedTimerEndOption)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                    }
                    
                    HStack {
                        Text("Add as widget")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Toggle("", isOn: $vibrateOn)
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                
                Spacer()
            }
            
            if showTimePicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showTimePicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            hours = tempHours
                            minutes = tempMinutes
                            seconds = tempSeconds
                            showTimePicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    HStack(spacing: 0) {
                        Picker("Hours", selection: $tempHours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Minutes", selection: $tempMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Seconds", selection: $tempSeconds) {
                            ForEach(0..<60) { second in
                                Text("\(second)s").tag(second)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            
            if showBreakPicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showBreakPicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            breakMinutes = tempBreakMinutes
                            showBreakPicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Picker("Break Duration", selection: $tempBreakMinutes) {
                        ForEach(1..<16) { minute in
                            Text("\(minute)m").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            
            if showLabelPicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showLabelPicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            showLabelPicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(labels, id: \.self) { label in
                                HStack {
                                    Text(label)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            selectedLabel = label
                                            showLabelPicker = false
                                        }
                                    
                                    Spacer()
                                    
                                    if label != "None" {
                                        Button(action: {
                                            if let index = labels.firstIndex(of: label) {
                                                labels.remove(at: index)
                                                if selectedLabel == label {
                                                    selectedLabel = "None"
                                                }
                                                UserDefaults.standard.set(labels, forKey: "labels")
                                            }
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .background(selectedLabel == label ? Color.gray.opacity(0.3) : Color.clear)
                            }
                        }
                    }
                    .frame(height: 200)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Tombol Add New Label
                    Button(action: {
                        showLabelPicker = false
                        showAddLabelModal = true
                    }) {
                        Text("Add New Label")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            
            if showAddLabelModal {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            newLabel = ""
                            showAddLabelModal = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            if !newLabel.isEmpty && !labels.contains(newLabel) {
                                labels.append(newLabel)
                                selectedLabel = newLabel
                                // Simpan labels ke UserDefaults
                                UserDefaults.standard.set(labels, forKey: "labels")
                            }
                            newLabel = ""
                            showAddLabelModal = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    TextField("Enter new label", text: $newLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            
            // When Timer Ends Picker Modal
            if showTimerEndPicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showTimerEndPicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            showTimerEndPicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Picker("When Timer Ends", selection: $selectedTimerEndOption) {
                        ForEach(timerEndOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
        }
    }
}

#Preview {
    TimerSetView()
}
