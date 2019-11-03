![Ellipsis Logo](https://github.com/joeborrello/ummm/blob/master/DVlogoSmall.png)

# Ellipsis

### Verbal auto-complete for monitoring neurodegeneration

#### Built by Team GRO at the 2019 BCG Digital Ventures hackathon
---

## How to run

- Run `minimalRESTAPI.py` to start autocomplete server

> The minimalRESTAPI.py script starts the server, which listens for a POST from the iOS application

- iOS application, when prompted, listens for spoken words, which are subsequently transcribed to text and posted to the autocomplete server

- When transcribed text is posted, the python script uses NLP model to suggest the next word, which is then sent back to the iOS application

- when the word is received by the iOS application it is spoken back to the user

_Note: Running the full, mobile version of this app requires that the iOS app is loaded onto a mobile device (or mobile device simulator)_

---
## How to run (without an iOS device)

- To see how the autocompletion server runs without using an iOS device, simply start the server with `python minimalRESTAPI.py` and, in a separate terminal window execute `curl -X POST -d *"YOUR SENTENCE FRAGMENT HERE"* http://157.245.196.85:5002/predict`

---
## Dependencies

- As best as possible, running pip install -r requirements.txt will install all required dependencies on a system
