import speech_recognition as sr

def transcribe(audio_file):
    r = sr.Recognizer() ##requires internet connection
    file = sr.AudioFile(audio_file)
    # for transcripting audio
    with file as source:
        audio = r.record(source)
    #  Speech recognition using Google Speech Recognition
    try:
        recog = r.recognize_google(audio, language = 'en-US') ##limited to 50 requests per day
        # for testing purposes, we're just using the default API key
        # to use another API key, use r.recognize_google(audio, key="GOOGLE_SPEECH_RECOGNITION_API_KEY")
        # instead of `r.recognize_google(audio)`` 
        return recog

    except sr.UnknownValueError:
        print("Google Speech Recognition could not understand audio")
    except sr.RequestError as e:
        print("Could not request results from Google Speech Recognition service; {0}".format(e))


