#!/usr/bin/env python3
import argparse

def xor_data(data, key):
    """Performs repeating-key XOR on byte arrays."""
    decrypted_data = bytearray(len(data))
    for i in range(len(data)):
        decrypted_data[i] = data[i] ^ key[i % len(key)]
    return decrypted_data

def main():
    parser = argparse.ArgumentParser(description='Decrypt a file using XOR with the provided key.')
    parser.add_argument('-i', '--input_file', required=True, help='File with encrypted data.')
    parser.add_argument('-o', '--output_file', required=True, help='File for decrypted text.')
    parser.add_argument('-k', '--key', required=True, help='The key for the XOR cipher (string or hex string).')

    args = parser.parse_args()

    try:
        # Read input data as bytes
        with open(args.input_file, 'rb') as f:
            data = bytearray(f.read())

        # Determine if the key is a hex string or a regular string
        if args.key.startswith('0x'):
            key = bytearray.fromhex(args.key[2:])
        else:
            key = bytearray(args.key, 'utf-8')

        # Perform decryption (same operation as encryption)
        decrypted = xor_data(data, key)

        # Write output data
        with open(args.output_file, 'wb') as f:
            f.write(decrypted)

        print(f"Decryption completed successfully. Output saved to {args.output_file}")

    except FileNotFoundError:
        print(f"Error: The file {args.input_file} was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
