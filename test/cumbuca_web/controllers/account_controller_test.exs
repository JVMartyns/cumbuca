defmodule CumbucaWeb.AccountControllerTest do
  use CumbucaWeb.ConnCase
  import Cumbuca.Factory

  @valid_params %{
    first_name: "Za",
    last_name: "Warudo",
    cpf: "61056482001",
    password: "12345678"
  }

  describe "create/2" do
    test "when params are valid, create account", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :create, @valid_params))
        |> json_response(201)

      assert %{
               "data" => %{
                 "account" => %{
                   "id" => id,
                   "balance" => "0",
                   "cpf" => "61056482001",
                   "password" => "12345678",
                   "first_name" => "Za",
                   "last_name" => "Warudo",
                   "inserted_at" => _inserted_at,
                   "updated_at" => _updated_at
                 },
                 "token" => token
               }
             } = response

      assert {:ok, %{id: ^id}} = CumbucaWeb.Token.verify(token)
    end

    test "when account has already exist", %{conn: conn} do
      insert(:account, cpf: @valid_params.cpf)

      response =
        conn
        |> post(Routes.account_path(conn, :create, @valid_params))
        |> json_response(422)

      expected_response = %{"errors" => %{"cpf" => ["has already been taken"]}}

      assert response == expected_response
    end

    test "when cpf is invalid", %{conn: conn} do
      invalid_params = %{@valid_params | cpf: "123"}

      response =
        conn
        |> post(Routes.account_path(conn, :create, invalid_params))
        |> json_response(422)

      expected_response = %{"errors" => %{"cpf" => ["has invalid format"]}}

      assert response == expected_response
    end

    test "when params are invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :create, %{}))
        |> json_response(422)

      expected_response = %{
        "errors" => %{
          "cpf" => ["can't be blank"],
          "first_name" => ["can't be blank"],
          "last_name" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end

  describe "login/2" do
    test "when params are valid, return an token", %{conn: conn} do
      %{id: id, cpf: cpf, password: password} = insert(:account)

      valid_login = %{
        cpf: cpf,
        password: password
      }

      response =
        conn
        |> post(Routes.account_path(conn, :login, valid_login))
        |> json_response(200)

      assert %{"data" => %{"token" => token}} = response
      assert {:ok, %{id: ^id}} = CumbucaWeb.Token.verify(token)
    end

    test "when params are invalid, return an error", %{conn: conn} do
      invalid_login = %{
        cpf: "11122233345",
        password: "invalid_password"
      }

      response =
        conn
        |> post(Routes.account_path(conn, :login, invalid_login))
        |> json_response(401)

      assert response == %{"errors" => %{"detail" => "Unauthorized"}}
    end
  end
end
