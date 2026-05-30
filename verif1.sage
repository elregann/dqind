# ==========================================
# STEP 1: VERIFIKASI DOMAIN DAN PREIMAGE (V1 & V2) - FIXED
# ==========================================

# 1. Definisikan parameter keamanan lambda = 128 bit
p = next_prime(2^128)
print(f"[*] Prime p yang digunakan: {p}")
print(f"[*] Apakah |Pa| >= 2^128? {p >= 2^128}")

# 2. Setup Q-expression: f(x, y) = (x + y) mod p
def f(x, y, prime):
    return (x + y) % prime

# 3. Ambil target output 'a' secara acak di Z_p menggunakan Integers(p)
R = Integers(p)
a = R.random_element()
print(f"[*] Target output (a) yang diuji: {a}")

# 4. Sampling 5 preimage secara acak untuk membuktikan validitas elemen (V2)
print("\n[*] Mengetes 5 elemen preimage acak dari Pa:")
elements_valid = True

for i in range(1, 6):
    # Pilih x_prime secara acak di Z_p
    x_prime = int(R.random_element())
    # Karakteristik linear: y_prime pasti terdeterminasi
    y_prime = (int(a) - x_prime) % int(p)
    
    # Verifikasi apakah f(x_prime, y_prime) == a
    check_output = f(x_prime, y_prime, p)
    is_valid = (check_output == a)
    
    if not is_valid:
        elements_valid = False
        
    print(f"   Sample {i} -> x': {x_prime}")
    print(f"               y': {y_prime}")
    print(f"               f(x',y') == a? {is_valid}")

print(f"\n[>] KESIMPULAN AKHIR STEP 1: {elements_valid}")
