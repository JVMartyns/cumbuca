defmodule Cumbuca.Crypto do
  @encryption_algorithm :aes_128_ctr

  @spec encrypt(any, String.t()) :: String.t()
  def encrypt(term_to_encrypt, key \\ secret()) do
    initial_vector = :crypto.strong_rand_bytes(16)

    encrypted_binary =
      :crypto.crypto_one_time(
        @encryption_algorithm,
        :base64.decode(key),
        initial_vector,
        :erlang.term_to_binary(term_to_encrypt),
        true
      )

    :base64.encode(initial_vector <> encrypted_binary)
  end

  @spec decrypt(String.t(), String.t()) :: String.t()
  def decrypt(encrypted_term, key \\ secret()) do
    <<initial_vector::binary-16, binary_to_decrypt::binary>> = :base64.decode(encrypted_term)

    decrypted_binary =
      :crypto.crypto_one_time(
        @encryption_algorithm,
        :base64.decode(key),
        initial_vector,
        binary_to_decrypt,
        false
      )

    :erlang.binary_to_term(decrypted_binary)
  end

  defp secret, do: Application.fetch_env!(:cumbuca, :crypto)[:secret]
end
