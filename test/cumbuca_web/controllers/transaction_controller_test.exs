defmodule CumbucaWeb.TransactionControllerTest do
  use CumbucaWeb.ConnCase
  import Cumbuca.Factory

  describe "show/2" do
    test "show all transactions", %{conn: conn} do
      %{id: sender_account_id, cpf: sender_account_cpf} = sender_account = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = insert(:account, cpf: "69441939064")

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
                   "sender_account" => ^sender_account_cpf,
                   "receiver_account" => ^receiver_account_cpf,
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
      %{cpf: receiver_account_cpf} = insert(:account)

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
                 "sender_account" => ^sender_account_cpf,
                 "receiver_account" => ^receiver_account_cpf,
                 "reversed_transaction_id" => nil,
                 "chargeback?" => false,
                 "value" => "100"
               }
             } = response
    end
  end
end
