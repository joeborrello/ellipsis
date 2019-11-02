# Import required libraries
import torch
from transformers import XLNetTokenizer, XLNetModel
import sys
import difflib

# Load pre-trained model tokenizer (vocabulary)
tokenizer = XLNetTokenizer.from_pretrained('xlnet-large-cased')

# Encode text input
text = sys.argv[1]
indexed_tokens = tokenizer.encode(text)

# Convert indexed tokens in a PyTorch tensor
tokens_tensor = torch.tensor([indexed_tokens])

# Load pre-trained model (weights)
model = XLNetModel.from_pretrained('xlnet-large-cased')

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
print(predicted_text)
original_fragment = sys.argv[1]
completed_phrase  = predicted_text
output_list = [li for li in difflib.ndiff(original_fragment, completed_phrase) if li[0] != ' ']
print(output_list)
