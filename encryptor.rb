class Encryptor
  def cipher(rotation)
      characters = (' '..'z').to_a
      rotated_characters = characters.rotate(rotation)
      Hash[characters.zip(rotated_characters)]
    end

    def encrypt_letter(letter, rotation)
      cipher_for_rotation = cipher(rotation)
      cipher_for_rotation[letter]
    end

    def encrypt(string, rotation)
      letters = string.split("")
      results = letters.collect do |letter|
        encrypted_letter = encrypt_letter(letter, rotation)
      end
      results.join
    end

    def decrypt_letter(letter, rotation)
      cipher_for_rotation = cipher( -1 * rotation )
      cipher_for_rotation[letter]
    end

    def decrypt(string, rotation)
      letters = string.split("")
      results = letters.collect do |letter|
        decrypt_letter(letter, rotation)
      end
      results.join
    end

    def encrypt_file(filename, rotation)
      input = File.open(filename, "r")
      output = File.open(filename + ".encrypted", "w")
      output.write(encrypt(input.read, rotation))
      output.close
    end

    def decrypt_file(filename, rotation)
      input = File.open(filename, "r")
      output = File.open(filename.gsub("encrypted", "decrypted"), "w")
      decrypted_text = decrypt(input.read, rotation)
      output.write(decrypted_text)
      output.close
    end

    def supported_characters
      (' '..'z').to_a
    end

    def crack(message)
      supported_characters.count.times.collect do |attempt|
        decrypt(message, attempt)
      end
    end

    def

end
