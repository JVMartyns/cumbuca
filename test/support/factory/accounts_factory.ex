defmodule Cumbuca.Factory.AccountFactory do
  @moduledoc false
  alias Cumbuca.Accounts.Account

  defmacro __using__(_args) do
    quote do
      def account_factory do
        %Account{
          first_name: "Za",
          last_name: "Warudo",
          cpf: Cpf.generate(),
          password: "12345678",
          balance: "100"
        }
      end
    end
  end
end
