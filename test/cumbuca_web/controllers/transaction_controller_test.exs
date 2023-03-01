defmodule CumbucaWeb.TransactionControllerTest do
  alias Cumbuca.Accounts
  use CumbucaWeb.ConnCase
  import Cumbuca.Factory
  alias Cumbuca.Repo
  alias Ecto.Adapters.SQL.Sandbox

  setup tags do
    :ok =
      if tags[:isolation] do
        Sandbox.checkout(Repo, isolation: tags[:isolation])
      else
        Sandbox.checkout(Repo)
      end

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end

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

    test "search date by period", %{conn: conn} do
      %{id: sender_account_id} = sender_account = insert(:account)
      %{id: receiver_account_id} = insert(:account)

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-07 20:30:52Z]
      )

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-08 20:30:52Z]
      )

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-09 20:30:52Z]
      )

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-10 20:30:52Z]
      )

      token = CumbucaWeb.Token.create(sender_account)

      response_to_initial_date =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> get(Routes.transaction_path(conn, :show, %{"initial_date" => "2023-02-09"}))
        |> json_response(200)

      assert [
               %{"processed_at" => "2023-02-09T20:30:52Z"},
               %{"processed_at" => "2023-02-10T20:30:52Z"}
             ] = response_to_initial_date["data"]

      response_to_final_date =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> get(Routes.transaction_path(conn, :show, %{"final_date" => "2023-02-08"}))
        |> json_response(200)

      assert [
               %{"processed_at" => "2023-02-07T20:30:52Z"},
               %{"processed_at" => "2023-02-08T20:30:52Z"}
             ] = response_to_final_date["data"]

      period = %{
        "initial_date" => "2023-02-08",
        "final_date" => "2023-02-09"
      }

      response_to_period =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> get(Routes.transaction_path(conn, :show, period))
        |> json_response(200)

      assert [
               %{"processed_at" => "2023-02-08T20:30:52Z"},
               %{"processed_at" => "2023-02-09T20:30:52Z"}
             ] = response_to_period["data"]
    end

    test "when the search date has an invalid format, ignore the parameter", %{conn: conn} do
      %{id: sender_account_id} = sender_account = insert(:account)
      %{id: receiver_account_id} = insert(:account)

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-07 20:30:52Z]
      )

      insert(:transaction,
        sender_account_id: sender_account_id,
        receiver_account_id: receiver_account_id,
        processed_at: ~U[2023-02-08 20:30:52Z]
      )

      token = CumbucaWeb.Token.create(sender_account)

      response_to_initial_date =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> get(Routes.transaction_path(conn, :show, %{"initial_date" => "invalid_value"}))
        |> json_response(200)

      assert [
               %{"processed_at" => "2023-02-07T20:30:52Z"},
               %{"processed_at" => "2023-02-08T20:30:52Z"}
             ] = response_to_initial_date["data"]
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
        |> post(Routes.transaction_path(conn, :create_transference, request_body))
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
    @tag isolation: "repeatable read"
    test "processes a transaction by id", %{conn: conn} do
      %{id: sender_account_id, cpf: sender_account_cpf} = sender_account = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = receiver_account = insert(:account)

      sender_account_name = "#{sender_account.first_name} #{sender_account.last_name}"
      receiver_account_name = "#{receiver_account.first_name} #{receiver_account.last_name}"

      %{id: transaction_id} =
        transaction =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id,
          processed_at: nil
        )

      request_body = %{
        "transaction_id" => transaction_id
      }

      token = CumbucaWeb.Token.create(sender_account)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(Routes.transaction_path(conn, :process, request_body))
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

  describe "create chargeback" do
    @tag isolation: "repeatable read"
    test "process an chargeback", %{conn: conn} do
      %{id: sender_account_id, cpf: sender_account_cpf} = sender_account = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = receiver_account = insert(:account)

      sender_account_name = "#{sender_account.first_name} #{sender_account.last_name}"
      receiver_account_name = "#{receiver_account.first_name} #{receiver_account.last_name}"

      %{id: transaction_id} =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id,
          processed_at: nil
        )

      request_body = %{
        "transaction_id" => transaction_id
      }

      token = CumbucaWeb.Token.create(receiver_account)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(Routes.transaction_path(conn, :chargeback, request_body))
        |> json_response(200)

      assert %{
               "data" => %{
                 "chargeback?" => true,
                 "id" => _id,
                 "processed_at" => _processed_at,
                 "receiver_account" => %{
                   "cpf" => ^sender_account_cpf,
                   "name" => ^sender_account_name
                 },
                 "reversed_transaction_id" => ^transaction_id,
                 "sender_account" => %{
                   "cpf" => ^receiver_account_cpf,
                   "name" => ^receiver_account_name
                 },
                 "value" => "100"
               }
             } = response
    end
  end
end
