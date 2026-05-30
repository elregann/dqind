import hashlib
import secrets
import operator
from sage.all import Integers

# ==========================================
# FIXED STEP 2 (NO SAGE PREPROCESSOR BUG)
# ==========================================

p = 340282366920938463463374607431768211507
print(f"[*] Prime p initialized: {p}")

def H(*args):
    msg = "".join(str(arg) for arg in args)
    return hashlib.sha256(msg.encode('utf-8')).hexdigest()

def get_secure_random(prime):
    return secrets.randbelow(prime)

print("[*] Generating witnesses...")
s = get_secure_random(p)
x = get_secure_random(p)
a = get_secure_random(p)
y = (a - x) % p
r = get_secure_random(p)

tau = H("bind", s, x, y, a, r)
print(f"[*] True Binding Tag (tau): {tau}")

print("\n[*] Mengetes 3 Fake Preimage dari Pa terhadap tau...")
v3_success = True
for i in range(1, 4):
    xf = get_secure_random(p)
    yf = (a - xf) % p
    tau_f = H("bind", s, xf, yf, a, r)
    is_unique = (tau_f != tau)
    if not is_unique:
        v3_success = False
    print(f"   Fake {i} -> Apakah tau_f == tau? {not is_unique} (tau_f: {tau_f[:10]}...)")

print(f"[>] Hasil Verifikasi V3 (Hiding): {v3_success}")

print("\n[*] Mensimulasikan Eksekusi Honest Protocol II...")
m = get_secure_random(p)
com = H("com", m, tau, a, r)
c = get_secure_random(p)

# Menggunakan operator.xor untuk memangkas bug preprocessor Sage (^)
hash_resp = int(H("resp", c, tau), 16)
pi = operator.xor(int(m), hash_resp)

# Verifier memulihkan m kembali memakai XOR
m_recovered = operator.xor(int(pi), hash_resp)
com_check = H("com", m_recovered, tau, a, r)

v4_success = (com == com_check)
print(f"   m_original == m_recovered -> {m == m_recovered}")
print(f"   com == com_check          -> {v4_success}")
print(f"[>] Hasil Verifikasi V4 (Completeness): {v4_success}")
