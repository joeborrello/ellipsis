# Import required libraries
#import torch
#from transformers import GPT2Tokenizer, GPT2LMHeadModel
import sys
import difflib

from pytorch_pretrained_bert.tokenization_gpt2 import GPT2Tokenizer
from pytorch_pretrained_bert.modeling_gpt2 import GPT2LMHeadModel
import torch
import tqdm

from flask import Flask, request

app = Flask(__name__)
        
@app.route('/predict', methods=['POST'])
def predict():
    text_return = ''
    if request.method == 'POST':
        post_text = request.form.to_dict()
        for k in post_text:
            
            print(k)
            # Load pre-trained model tokenizer (vocabulary)
            tokenizer = GPT2Tokenizer.from_pretrained('gpt2')

            # Encode text input
            text = k
            
            indexed_tokens = tokenizer.encode(text)

            # Convert indexed tokens in a PyTorch tensor
            tokens_tensor = torch.tensor([indexed_tokens])
            
            # Load pre-trained model (weights)
            model = GPT2LMHeadModel.from_pretrained('https://storage.googleapis.com/allennlp/models/gpt2-345M-dump')
            #print(1)
            # Set the model in evaluation mode to deactivate the DropOut modules
            model.eval()
            
            # If you have a GPU, put everything on cuda
            tokens_tensor = tokens_tensor.to('cpu')
            model.to('cpu')

            # Predict all tokens
            with torch.no_grad():
                outputs = model(tokens_tensor)
                predictions = outputs[0]

            # Get the predicted next sub-word
            predicted_index = torch.argmax(predictions[0, -1, :]).item()
            predicted_text = tokenizer.decode(indexed_tokens + [predicted_index])

            # Print the predicted word
            #print(predicted_text) #debugging
            original_fragment = text
            completed_phrase  = predicted_text
            output_list = [li for li in difflib.ndiff(original_fragment, completed_phrase) if li[0] != ' ']
            #print(output_list) #debugging
            output_list = [s.replace('+','') for s in output_list[1:]]
            #print(output_list) #debugging
            output_word = ""
            for x in output_list:
                output_word += x
            #print(output_word)
            #output_word = output_word.strip(" ")
            #print(output_word)
            output_word = output_word.replace(" ","")
            print(output_word)
            text_return = output_word
            
    return text_return

if __name__ == '__main__':
    app.run(host= '157.245.196.85', port=5002, debug=False)

