defmodule Cumbuca.Factory.AccountFactory do
  alias Cumbuca.Accounts.Account

  defmacro __using__(_args) do
    quote do
      def account_factory do
        %Account{
          first_name: "Za",
          last_name: "Warudo",
          cpf: "61056482001",
          password: "12345678",
          balance: "100"
        }
      end
    end
  end
end
