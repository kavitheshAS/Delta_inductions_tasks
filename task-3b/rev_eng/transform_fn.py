import sys

def obscure_function(s):
    result = 0
    for c in s:
        result = (result * 33 + ord(c)) & 0xFFFFFFFF  # Ensure it's a 32-bit value
    return result

def main(input_string):
    hardcoded_value = 0xDEADBEEF  # This is the hardcoded value to match
    calculated_value = obscure_function(input_string)

    if calculated_value == hardcoded_value:
        print("Flag: FLAG-SECRET")
    else:
        print("No flag for you!")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 obscure.py <input_string>")
    else:
        main(sys.argv[1])
