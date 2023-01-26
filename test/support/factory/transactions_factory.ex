defmodule Cumbuca.Factory.TransactionsFactory do
  alias Cumbuca.Transactions.Transaction

  defmacro __using__(_args) do
    quote do
      def transaction_factory do
        %Transaction{
          id: Ecto.UUID.generate(),
          chargeback?: false,
          processed_at: nil,
          value: Decimal.new(100),
          sender_account_id: Ecto.UUID.generate(),
          receiver_account_id: Ecto.UUID.generate(),
          reversed_transaction_id: nil,
          inserted_at: DateTime.utc_now(),
          processed_at: DateTime.utc_now(),
          updated_at: DateTime.utc_now()
        }
      end
    end
  end
end
