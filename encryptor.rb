require 'pry'
require 'pry-byebug'

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

    def get_rotation_hash(message)
      rotation_message_hash = { "rotation" => message.split("<<")[1].split(">>")[0].to_i,
                                "message" => message.split("<<")[0] }
    end

    def encrypt_realtime(message, selection)

      rotation = 9

      if (message.include? "<<") && (message.include? ">>")
        rotation_message_hash = get_rotation_hash(message)
        message = rotation_message_hash["message"]
        rotation = rotation_message_hash["rotation"]
      end

      if selection == 1
        puts encrypt(message, rotation)
      else
        puts decrypt(message, rotation)
      end

    end

    def real_time
      puts "Welcome to Real Time Encryptor!"
      selection = ""
      until ((selection == 1) || (selection == 2)) do
        selection = input_select
      end

      if (selection == 1)
        puts "Type your message to encrypt: "
      elsif (selection == 2)
        puts "Type your encrypted message to decrypt: "
      end

      message = gets.chomp
      encrypt_realtime(message, selection)

    end

    def input_select
      puts "Select [1] Encrypt or [2] Decrypt"
      selection = gets.chomp.to_i
    end

    def check_password

      require 'digest/md5'

      puts "Input password: "
      password = gets.chomp
      if (Digest::MD5.hexdigest(password) == "3e25960a79dbc69b674cd4ec67a72c62")
        real_time
      else
        "Incorrect Password"
      end
    end

    def rotation_array
      [5, 9, 23]
    end

    def better_rot_encrypt(string)
      letters = string.split("")
      i = 0

      results = letters.collect do |letter|
        rotation = rotation_array[i]
        i = incrament_array(i)
        encrypted_letter = encrypt_letter(letter, rotation)
      end
      #binding.pry
      results.join
    end

    def better_rot_decrypt(string)
      letters = string.split("")
      i = 0
      results = letters.collect do |letter|
        rotation = rotation_array[i]
        i = incrament_array(i)
        decrypt_letter(letter, rotation)
      end
      results.join
    end

    def incrament_array(i)
      if i < 2
        i += 1
      else
        i = 0
      end
    end

end
