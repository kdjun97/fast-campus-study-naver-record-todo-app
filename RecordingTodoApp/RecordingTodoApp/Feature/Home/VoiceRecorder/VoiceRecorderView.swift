//
 //  VoiceRecorderView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct VoiceRecorderView: View {
    @EnvironmentObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TitleView()
                    .padding(.top, 20)
                if (voiceRecorderViewModel.recordedFiles.isEmpty) {
                    AnnouncementView()
                } else {
                    RecordContentView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 18)
                }
            }
            RecordingButton(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .onChange(
            of: voiceRecorderViewModel.recordedFiles,
            perform: { recordedFiles in
                homeViewModel.voiceRecorderCount = recordedFiles.count
            }
        )
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isShowRemoveDialog
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) {}
        }.alert(
            voiceRecorderViewModel.dialogMessage,
            isPresented: $voiceRecorderViewModel.isShowDialog
        ) {
            Button("확인", role: .cancel) {}
        }
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .padding(.leading, 20)
            Spacer()
        }
    }
}

private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("\"현재 등록된 음성메모가 없습니다.\"")
            Text("\"하단의 녹음버튼을 눌러 음성메모를 시작해주세요.\"")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

private struct RecordContentView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel

    init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                RecordContentCellItem(
                    voiceRecorderViewModel: voiceRecorderViewModel,
                    recordedFile: recordedFile
                )
            }
        }
    }
}

private struct RecordContentCellItem: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if (voiceRecorderViewModel.selectedRecordedFile == recordedFile
            && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused)
        ) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceRecorderViewModel.voiceRecorderCellTapped(recordedFile: recordedFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.customBK)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconOn)
                        }
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordedFile != recordedFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconOn)
                        }
                    }
                }
            }.padding(.horizontal, 20)
            
            if (voiceRecorderViewModel.selectedRecordedFile == recordedFile) {
                VStack {
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 1, weight: .medium))
                            .foregroundColor(.customIconOn)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.customIconOn)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if (voiceRecorderViewModel.isPaused) {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        } label: {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundColor(.customBK)
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if (voiceRecorderViewModel.isPlaying) {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundColor(.customBK)
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceRecorderViewModel.removeButtonTapped()
                        } label: {
                            Image("trash")
                                .renderingMode(.template)
                                .foregroundColor(.customBK)
                        }
                    }
                }.padding(.horizontal, 20)
            }
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
        }
    }
}

private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.customGray2)
                    .frame(width: geometry.size.width, height:2)
                
                Rectangle()
                    .fill(.customBGGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width, height:2)
            }
        }
    }
}

private struct RecordingButton: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    voiceRecorderViewModel.recordButtonTapped()
                } label: {
                    (voiceRecorderViewModel.isRecording)
                    ? Image("mic_recording")
                    : Image("mic")
                }
            }
        }
    }
}
