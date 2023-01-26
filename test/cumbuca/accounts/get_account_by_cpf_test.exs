defmodule Cumbuca.Accounts.GetAccountByCpfTest do
  use Cumbuca.DataCase
  alias Cumbuca.Accounts.{Account, GetAccountByCpf}
  import Cumbuca.Factory

  describe "call/1" do
    test "when account exist" do
      %{cpf: cpf} = insert(:account)

      assert {:ok, %Account{cpf: ^cpf}} = GetAccountByCpf.call(cpf)
    end

    test "when account does not exist" do
      cpf = "12345678910"
      assert {:error, "account not found for " <> params} = GetAccountByCpf.call(cpf)
      assert params == "[cpf: #{cpf}]"
    end
  end
end
