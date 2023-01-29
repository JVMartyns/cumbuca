defmodule Cumbuca.Crypto do
  @encryption_algorithm :aes_128_ctr

  @spec encrypt(any, String.t()) :: String.t()
  def encrypt(term_to_encrypt, key \\ secret()) do
    encrypted_binary =
      :crypto.crypto_one_time(
        @encryption_algorithm,
        :base64.decode(key),
        :base64.decode(iv()),
        :erlang.term_to_binary(term_to_encrypt),
        true
      )

    :base64.encode(encrypted_binary)
  end

  @spec decrypt(String.t(), String.t()) :: String.t()
  def decrypt(encrypted_term, key \\ secret()) do
    decrypted_binary =
      :crypto.crypto_one_time(
        @encryption_algorithm,
        :base64.decode(key),
        :base64.decode(iv()),
        :base64.decode(encrypted_term),
        false
      )

    :erlang.binary_to_term(decrypted_binary)
  end

  defp secret, do: Application.fetch_env!(:cumbuca, :crypto)[:secret]
  defp iv, do: Application.fetch_env!(:cumbuca, :crypto)[:iv]
end
