# Import required libraries
import torch
from pytorch_transformers import GPT2Tokenizer, GPT2LMHeadModel
import sys
import difflib

# Load pre-trained model tokenizer (vocabulary)
tokenizer = GPT2Tokenizer.from_pretrained('gpt2')

# Encode text input
text = sys.argv[1]
indexed_tokens = tokenizer.encode(text)

# Convert indexed tokens in a PyTorch tensor
tokens_tensor = torch.tensor([indexed_tokens])

# Load pre-trained model (weights)
model = GPT2LMHeadModel.from_pretrained('gpt2')

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
completed_sentence = predicted_text
output_list = [li for li in difflib.ndiff(original_fragment, completed_sentence) if li[0] != ' ']
print(output_list)

