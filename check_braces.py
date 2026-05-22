import sys

with open(sys.argv[1], 'r') as f:
    text = f.read()

count = 0
for i, char in enumerate(text):
    if char == '{':
        count += 1
    elif char == '}':
        count -= 1
        if count == 0:
            print(f"Class closed at character index {i}")
            # Count newlines to find line number
            line_num = text.count('\n', 0, i) + 1
            print(f"Class closed at line {line_num}")
