defmodule CumbucaWeb.AccountControllerTest do
  use CumbucaWeb.ConnCase

  @valid_params %{
    first_name: "Za",
    last_name: "Warudo",
    cpf: "61056482001"
  }

  describe "create/2" do
    test "when params are valid, create account", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :create, @valid_params))
        |> json_response(201)

      assert %{
               "data" => %{
                 "id" => _id,
                 "balance" => "0",
                 "cpf" => "61056482001",
                 "first_name" => "Za",
                 "last_name" => "Warudo",
                 "inserted_at" => _inserted_at,
                 "updated_at" => _updated_at
               }
             } = response
    end

    test "when account has already exist", %{conn: conn} do
      Cumbuca.Accounts.create_account(@valid_params)

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
          "last_name" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end
end
