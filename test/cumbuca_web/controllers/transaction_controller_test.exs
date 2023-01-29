defmodule CumbucaWeb.TransactionControllerTest do
  alias Cumbuca.Accounts
  use CumbucaWeb.ConnCase
  import Cumbuca.Factory

  describe "show/2" do
    test "show all transactions", %{conn: conn} do
      %{id: sender_account_id, cpf: sender_account_cpf} = sender_account = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = receiver_account = insert(:account)

      sender_account_name = "#{sender_account.first_name} #{sender_account.last_name}"
      receiver_account_name = "#{receiver_account.first_name} #{receiver_account.last_name}"

      %{id: transaction_id} =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        )

      token = CumbucaWeb.Token.create(sender_account)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> get(Routes.transaction_path(conn, :show))
        |> json_response(200)

      assert %{
               "data" => [
                 %{
                   "chargeback?" => false,
                   "id" => ^transaction_id,
                   "processed_at" => _processed_at,
                   "sender_account" => %{
                     "cpf" => ^sender_account_cpf,
                     "name" => ^sender_account_name
                   },
                   "receiver_account" => %{
                     "cpf" => ^receiver_account_cpf,
                     "name" => ^receiver_account_name
                   },
                   "reversed_transaction_id" => nil,
                   "value" => "100"
                 }
               ]
             } = response
    end
  end

  describe "create/2" do
    test "create transaction", %{conn: conn} do
      %{cpf: sender_account_cpf} = sender_account = insert(:account)
      %{cpf: receiver_account_cpf} = receiver_account = insert(:account)

      sender_account_name = "#{sender_account.first_name} #{sender_account.last_name}"
      receiver_account_name = "#{receiver_account.first_name} #{receiver_account.last_name}"

      token = CumbucaWeb.Token.create(sender_account)

      request_body = %{
        cpf: receiver_account_cpf,
        value: 100
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(Routes.transaction_path(conn, :create, request_body))
        |> json_response(201)

      assert %{
               "data" => %{
                 "id" => _id,
                 "processed_at" => nil,
                 "sender_account" => %{
                   "cpf" => ^sender_account_cpf,
                   "name" => ^sender_account_name
                 },
                 "receiver_account" => %{
                   "cpf" => ^receiver_account_cpf,
                   "name" => ^receiver_account_name
                 },
                 "reversed_transaction_id" => nil,
                 "chargeback?" => false,
                 "value" => "100"
               }
             } = response
    end
  end

  describe "process_transaction/2" do
    test "processes a transaction by id", %{conn: conn} do
      %{id: sender_account_id, cpf: sender_account_cpf} = sender_account = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = receiver_account = insert(:account)

      sender_account_name = "#{sender_account.first_name} #{sender_account.last_name}"
      receiver_account_name = "#{receiver_account.first_name} #{receiver_account.last_name}"

      %{id: transaction_id} =
        transaction =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        )

      request_body = %{
        "transaction_id" => transaction_id
      }

      token = CumbucaWeb.Token.create(sender_account)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(Routes.transaction_path(conn, :process_transaction, request_body))
        |> json_response(200)

      assert %{
               "data" => %{
                 "id" => ^transaction_id,
                 "receiver_account" => %{
                   "cpf" => ^receiver_account_cpf,
                   "name" => ^receiver_account_name
                 },
                 "sender_account" => %{
                   "cpf" => ^sender_account_cpf,
                   "name" => ^sender_account_name
                 },
                 "value" => "100",
                 "processed_at" => processed_at,
                 "chargeback?" => false,
                 "reversed_transaction_id" => nil
               }
             } = response

      assert not is_nil(processed_at)

      {:ok, updated_sender_account} = Accounts.get_account_by_id(sender_account_id)
      {:ok, updated_receiver_account} = Accounts.get_account_by_id(receiver_account_id)

      assert updated_sender_account.balance ==
               Decimal.sub(sender_account.balance, transaction.value)

      assert updated_receiver_account.balance ==
               Decimal.add(receiver_account.balance, transaction.value)
    end
  end
end
