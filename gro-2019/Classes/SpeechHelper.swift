//
//  SpeechHelper.swift
//  Helper Keyboard
//
//  Created by Victor Zhong on 11/2/19.
//  Copyright © 2019 Victor Zhong. All rights reserved.
//

import Foundation
import Speech

protocol SpeechHelperDelegate: AnyObject {

    func sendAlert(title: String, message: String)
    func updateText(text: String)
    func recordingCanceled()
    func timerStopped()

}

extension SpeechHelperDelegate {

    func recordingCanceled() { }
    func timerStopped() { }
}

class SpeechHelper {

    weak var delegate: SpeechHelperDelegate?

    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()

    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var timer: Timer?

    init(delegate: SpeechHelperDelegate?) {
        self.delegate = delegate
    }

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)

        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            delegate?.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            delegate?.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }

        if !myRecognizer.isAvailable {
            delegate?.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            var isFinal = false

            if let result = result {
                let bestString = result.bestTranscription.formattedString
                isFinal = result.isFinal
                self?.delegate?.updateText(text: bestString)
            } else if let error = error {
                self?.delegate?.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }

            if isFinal {
                self?.cancelRecording()
            } else if error == nil {
                self?.restartSpeechTimer()
            }
        })
    }

    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.reset()
        delegate?.recordingCanceled()
    }

}

private extension SpeechHelper {

    func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2,
                                     repeats: false,
                                     block: { [weak self] (timer) in
                                        self?.delegate?.timerStopped()
        })
    }

}
