# Natas28: What We Actually Did, In Plain English

A walkthrough of the joke database challenge, explained with an analogy, no jargon left unexplained.

## The Big Picture

Think of the website as a clerk who works behind a locked door. You slide a note under the door asking for something. The clerk reads your note, writes a question for a filing cabinet based on it, but instead of asking the cabinet right away, the clerk first puts that question through a shredder that cuts it into strips and scrambles each strip. The clerk slides the scrambled strips back to you. You hand the scrambled strips back through the door, the clerk unscrambles them, and only then actually asks the filing cabinet and tells you the answer.

That shredder is the encryption. The scrambling method the clerk uses, called ECB, turns out to have a huge weakness: it scrambles in fixed-size strips, always exactly the same size, and if two strips happen to contain the exact same words, they always come out scrambled in the exact same way. No randomness, no variation. Same input strip, same output strip, every single time.

## The Shredder's Weakness

Imagine the shredder cuts everything into strips of exactly 16 letters. If strip number 3 says "aaaaaaaaaaaaaaaa" and strip number 7 also happens to say "aaaaaaaaaaaaaaaa", both strips come out of the shredder looking identical once scrambled. That is the tell. If you ever see two scrambled strips that match, you know for a fact their original contents matched too, even though you cannot read either one.

This matters because it means the scrambling has no memory. Each strip is scrambled completely on its own, with no connection to the strips next to it. That is the flaw we used.

## How We Snuck Our Own Question Into the Clerk's Note

Here is the part you asked about directly. When you search for a joke, you are not just handing the clerk a search word. The clerk takes whatever you typed and glues it directly into the middle of a longer, pre-written question, something like "find me jokes where the text contains WHATEVER YOU TYPED." Your typed text becomes a literal chunk sitting inside that full question before the whole thing goes through the shredder.

Since the clerk glues in whatever you type without checking what it actually says, there is nothing stopping you from typing something far longer and stranger than a search word. You could type an entire second question of your own, one that has nothing to do with searching for jokes at all. The clerk does not notice the difference. It still just glues your text into the sentence and shreds the whole thing.

So we typed, as our "search term," a complete, real request aimed at a completely different table in the filing cabinet, the one holding usernames and passwords, not jokes. As far as the clerk's gluing process was concerned, it was just more text to paste in. We were not breaking into the clerk's note. We were hiding a second, fully formed note inside the space meant for a single search word.

## Why the First Attempt Failed

Our first try used a quote mark to try to cut our note short and start a brand new sentence right there, a classic trick. It did not work, because the clerk was quietly escaping quote marks before gluing them in, turning them harmless. So instead of fighting the gluing process, we stopped trying to cut anything short. We just wrote our entire replacement question using a style that never needed a quote mark at all (hex code instead of quoted text), and let the clerk glue it in as one long uninterrupted block.

## Finding Exactly Where Our Text Landed

Strips are a fixed size, 16 letters each, always starting at the same fixed points, like marks on a ruler. If our own writing started in the middle of a strip instead of exactly at one of those marks, part of a strip would contain a mix of the clerk's own wording and our wording jumbled together. That is a problem, because strips get scrambled as a whole unit. We cannot cleanly pull apart a strip that has both the clerk's words and our words mixed inside it.

So first we measured, by typing known filler text of different lengths and watching how the total scrambled result changed size, exactly how many letters of the clerk's own wording come before our text starts. Once we knew that number, we added a small amount of our own filler text first, just enough to push our real writing to start exactly on one of those ruler marks. From that point on, every strip touched by our writing belonged entirely to us.

## Planting a Fake "End of Note" Marker

Notes that go through the shredder need a way to say "this is where the real content ends," otherwise the unscrambling process cannot tell where padding or filler begins. We wrote our replacement question, then deliberately added our own official-looking "end of note" marker right after it, placed so it also lined up perfectly with the strip boundaries.

This meant that our question, plus our own fake ending marker, formed something that looked, strip by strip, exactly like a complete, correctly formed note all on its own, even though it was actually sitting in the middle of a much longer note that also contained the clerk's real wording before and after it.

## Cutting Out Just Our Piece

We sent this whole oversized note through the shredder as normal. The clerk scrambled everything, the real wording before our text, our own question, our fake ending marker, and whatever real wording came after. We got back every scrambled strip.

Then we did the key move. We threw away every strip except the ones covering just our own question and our fake ending marker. We kept nothing of the clerk's real wording at all.

We handed that small leftover stack of strips back to the clerk, by itself, as if it were the entire note. Because each strip unscrambles completely on its own, with no dependence on its neighbors, the clerk unscrambled our little stack perfectly, saw what looked like a complete, properly ended note, and carried out exactly the question written on it. The clerk never knew the real note ever had anything else in it, because we never sent those other strips back.

## The Last Snag

Our question worked and pulled back the right row of data, but the clerk's display code was expecting the answer to be labeled "joke" specifically, since normally it is listing jokes. Our answer was labeled "password" instead, so the display code could not find what it was looking for and showed nothing. The fix was simply asking our question to label its answer "joke" as well, even though the actual content inside was the password. The clerk's display code did not care what the data actually was, only that the label matched what it expected.

## The Short Version

We learned exactly how long the clerk's hidden wording was by measuring size changes. We found the exact spot where our own text could start cleanly, on a strip boundary. We wrote a full replacement question with no quote marks, added our own fake ending marker, and let the whole oversized note get shredded and scrambled together with the clerk's real wording. Then we threw away every scrambled strip except the ones that were purely ours, handed just those back, and the clerk faithfully carried out our question instead, never knowing the rest of the original note ever existed.

## Technical Step by Step

1. Measure the ciphertext length while sending inputs of increasing length (1 letter, 2 letters, and so on). AES with PKCS7 padding always rounds the output up to the next multiple of 16 bytes. Every time the output jumps up by 16, it means your input plus the fixed surrounding SQL text just crossed another 16 byte boundary.
2. Use two of those jump points to solve for the fixed text length with simple algebra. If output is still 80 bytes at input length 12, but becomes 96 bytes at input length 13, the fixed text plus your input must cross from 79 to 80 bytes right at that step. That pins the fixed text at exactly 67 bytes total.
3. Find where your input starts, not just the total fixed length. Send a long run of the same character (for example 48 letter a) and split the returned ciphertext into 16 byte blocks. Because ECB encrypts identical 16 byte blocks identically, two blocks that are byte for byte identical mean both of those plaintext blocks were pure filler, with no real query text mixed in. Shrinking the filler length until the duplicate just barely disappears pins down the exact byte offset where your input begins. In this case, offset 38.
4. Calculate filler needed to reach a clean 16 byte boundary. Offsets 0, 16, 32, 48, 64 are boundaries. Your input begins at byte 38, so adding 10 filler characters pushes your real payload to start exactly at byte 48, a clean boundary.
5. Confirm whether simple quote based SQL injection works, by comparing a baseline search against a payload containing a single quote, and against an always true payload like OR 1=1. If all three come back identical, quotes are being escaped and that route is closed.
6. Write a full, self contained SQL query as your search input, avoiding quote characters entirely by using MySQL hex literals (0x followed by the hex bytes of the string) instead of quoted strings.
7. Pad that query with spaces until its length is a multiple of 16 bytes, then append 16 bytes of the value chr(16) repeated 16 times. This is a valid PKCS7 padding block on its own, meaning end of message here, remove the last 16 bytes.
8. Submit filler plus your padded query plus the fake padding block as the search input. The server glues it into the middle of its real query and encrypts the entire combined string in 16 byte blocks.
9. From the full returned ciphertext, slice out only the bytes starting at your known offset (48) and running for exactly the length of your padded query plus your fake padding block. Discard every other byte, including the real prefix and the real suffix the server added.
10. Submit that extracted slice alone, base64 encoded, directly to the endpoint that decrypts and executes. Because ECB decrypts each block independently with no link to its neighbors, this slice decrypts cleanly into your query followed by valid padding, as if it was the entire message all along.
11. If the result looks empty or mislabeled, check the column alias. The display code expects a specific column name (joke in this case), so alias your selected column to match, for example SELECT password AS joke.

## Flowchart

```
[You type a search term]
        |
        v
[Server glues your term into a fixed SQL template]
        |
        v
[Server encrypts the WHOLE combined string, block by block, ECB mode]
        |
        v
[Server sends you the encrypted blob in the URL]

--- normal flow stops here, you would just submit it back ---

[Attack path instead:]

[You measure block size jumps -> find total fixed text length]
        |
        v
[You find duplicate ciphertext blocks -> find exact start offset of your input]
        |
        v
[You add filler so your real payload starts on a clean 16 byte boundary]
        |
        v
[You write your own full query, no quotes, hex literals instead]
        |
        v
[You append a fake PKCS7 padding block right after your query]
        |
        v
[You submit filler + your query + fake padding as the search term]
        |
        v
[Server encrypts everything: real prefix + filler + your query + fake padding + real suffix]
        |
        v
[You slice out ONLY the ciphertext bytes covering your query + fake padding]
        |
        v
[You discard the real prefix and real suffix ciphertext entirely]
        |
        v
[You submit your small slice alone to the decrypt-and-run endpoint]
        |
        v
[Server decrypts each block independently, has no idea blocks are missing]
        |
        v
[Your query decrypts cleanly, looks complete, padding checks out]
        |
        v
[Server runs YOUR query instead of the real one]
        |
        v
[Result shown back to you]
```

## How We Actually Removed the Prefix and Suffix

This is the part that trips people up, so slow version. Nothing was deleted from the server's real query. The server still built and encrypted its full real query, real prefix, your stuff, real suffix, all of it, every single time. We never touched or edited that.

What we controlled was only the request we sent back afterward. The encrypted result the server gave us was just a long sequence of bytes, broken into 16 byte chunks, where each chunk only depends on its own 16 bytes of plaintext and nothing else. That independence is the entire point. A chunk covering the real prefix text has no cryptographic link to a chunk covering your text. They just happen to be sitting next to each other in one long sequence, purely because that is the order the server built the plaintext in.

So after getting the full encrypted blob back, we did simple byte slicing on our own computer, nothing sent to the server yet. We took the full byte sequence and kept only the portion starting at byte 48 (where we had engineered our own content to begin) and running for the length of our query plus our fake padding block. Every byte before position 48, which covered the real prefix, we threw away. Every byte after our fake padding block, which covered the real suffix, we also threw away.

We were left holding a short, isolated chunk of ciphertext containing only what the server had encrypted from our own text, nothing else. When we sent that short chunk back to the decrypt and run endpoint by itself, the server had no way to know it was ever part of something longer. It just decrypted the bytes we gave it, block by block, exactly as it always does, found our query followed by a properly formed padding block, and ran it. The real prefix and suffix were never in that request at all, so there was nothing for the server to even notice was missing.
