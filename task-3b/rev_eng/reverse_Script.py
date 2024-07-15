from z3 import *

def reverse_obscure_function(hardcoded_value):
    s = Solver()
    input_string = [BitVec(f'c{i}', 8) for i in range(32)]  # Assume max length of 32

    result = BitVecVal(0, 32)
    for c in input_string:
        result = (result * 33 + ZeroExt(24, c)) & 0xFFFFFFFF  # result * 33 + ord(c)

    s.add(result == hardcoded_value)

    if s.check() == sat:
        model = s.model()
        secret_string = ''.join(chr(model[c].as_long()) for c in input_string if model[c].as_long() >= 32 and model[c].as_long() <= 126)
        return secret_string
    else:
        return None

hardcoded_value = 0xDEADBEEF
secret_string = reverse_obscure_function(hardcoded_value)
if secret_string:
    print(f"Secret string: {secret_string}")
else:
    print("No solution found.")
