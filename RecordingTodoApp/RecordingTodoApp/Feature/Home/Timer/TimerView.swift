//
 //  TimerView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel()
    
    var body: some View {
        if timerViewModel.isDisplaySetTimeView {
            SetTimerView(timerViewModel: timerViewModel)
        } else {
            TimerOperationView(timerViewModel: timerViewModel)
        }
    }
}

private struct SetTimerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 50)
            
            TimePickerView(timerViewModel: timerViewModel)
            
            Spacer()
                .frame(height: 30)
            
            TimerCreateButtonView(timerViewModel: timerViewModel)
            
            Spacer()
        }
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("타이머")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBK)
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
            
            HStack {
                Picker("Hour", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)시")
                    }
                }
                
                Picker("Minute", selection: $timerViewModel.time.minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)분")
                    }
                }
                
                Picker("Second", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)초")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
        }
    }
}

private struct TimerCreateButtonView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        Button {
            timerViewModel.settingButtonTapped()
        } label : {
            Text("설정하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.customGreen)
        }
    }
}

private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                        .font(.system(size: 28))
                        .foregroundColor(.customBK)
                        .monospaced()
                    
                    HStack(alignment: .bottom) {
                        Image(systemName: "bell.fill")
                        
                        Text("\(timerViewModel.time.convertedSeconds.formattedSettingTime)")
                            .font(.system(size: 16))
                            .foregroundColor(.customBK)
                            .padding(.top, 10)
                    }
                }
                
                Circle()
                    .stroke(Color.customPoint, lineWidth: 6)
                    .frame(width: 350)
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Button {
                    timerViewModel.cancelButtonTapped()
                } label: {
                    Text("취소")
                        .font(.system(size: 16))
                            .foregroundColor(.customBK)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 22)
                            .background(
                                Circle()
                                    .fill(Color.customGray2.opacity(0.3))
                            )
                }
                Spacer()
                Button {
                    timerViewModel.pauseOrRestartButtonTapped()
                } label: {
                    Text(timerViewModel.isPaused ? "재개" : "정지")
                        .font(.system(size: 16))
                            .foregroundColor(.customBK)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 22)
                            .background(
                                Circle()
                                    .fill(Color.customPoint.opacity(0.3))
                            )
                }
            }.padding(.horizontal, 20)
        }
    }
}
