defmodule Cumbuca.Accounts.CreateAccountTest do
  use Cumbuca.DataCase

  alias Cumbuca.Accounts.Account
  alias Cumbuca.Accounts.CreateAccount

  @valid_params %{
    first_name: "Za",
    last_name: "Warudo",
    cpf: "61056482001"
  }

  describe "call/1" do
    test "when params are valid" do
      assert {:ok, account} = CreateAccount.call(@valid_params)

      assert %Account{
               balance: balance,
               cpf: "61056482001",
               first_name: "Za",
               last_name: "Warudo",
               id: _id,
               inserted_at: _,
               updated_at: _
             } = account

      assert balance == Decimal.new(0)
    end

    test "when account has already exist" do
      CreateAccount.call(@valid_params)

      assert {:error, changeset} = CreateAccount.call(@valid_params)
      assert errors_on(changeset) == %{cpf: ["has already been taken"]}
    end

    test "when cpf is invalid" do
      invalid_params = %{@valid_params | cpf: "123"}
      assert {:error, changeset} = CreateAccount.call(invalid_params)

      assert errors_on(changeset) == %{cpf: ["has invalid format"]}
    end

    test "when params are invalid" do
      assert {:error, changeset} = CreateAccount.call(%{})

      assert errors_on(changeset) == %{
               cpf: ["can't be blank"],
               first_name: ["can't be blank"],
               last_name: ["can't be blank"]
             }
    end
  end
end
