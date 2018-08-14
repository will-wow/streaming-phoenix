defmodule Agg.Upstream do
  alias Agg.{User, Domicile, Account, ExpandedUser}

  @domain "http://thawing-plains-39737.herokuapp.com"

  @spec fetch_extended_user(String.t()) :: {:ok, ExpandedUser.t()} | {:error, any}
  def fetch_extended_user(user_id) do
    with {:ok, user} <- get_data(User, "users", user_id),
         {:ok, domicile, account} <- fetch_user_extra_data(user) do
      expanded_user = %ExpandedUser{
        user: user,
        domicile: domicile,
        account: account
      }

      {:ok, expanded_user}
    else
      {:error, error} -> {:error, error}
    end
  end

  def fetch_users_stream() do
    "#{@domain}/users-stream?avatar=true"
    |> HTTPoison.get(%{}, stream_to: self())

    await_chunk()
    |> Stream.unfold(fn
      {:ok, chunk} -> {chunk, await_chunk()}
      {:error, :done} -> nil
    end)
  end

  defp await_chunk() do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk} ->
        {:ok, chunk}

      %HTTPoison.AsyncEnd{} ->
        {:error, :done}
    end
  end

  @spec fetch_user_extra_data(user :: User.t(), remaining_retries :: integer) ::
          {:ok, Domicile.t(), Account.t()} | {:error, any}
  defp fetch_user_extra_data(_, 0) do
    {:error, "Too many retries"}
  end

  defp fetch_user_extra_data(
         user = %User{domicile_id: domicile_id, account_id: account_id},
         remaining_retries \\ 30
       ) do
    await_domicile = Task.async(fn -> get_data(Domicile, "domiciles", domicile_id) end)
    await_account = Task.async(fn -> get_data(Account, "accounts", account_id) end)

    with {:ok, domicile} <- Task.await(await_domicile),
         {:ok, account} <- Task.await(await_account) do
      {:ok, domicile, account}
    else
      _ ->
        fetch_user_extra_data(user, remaining_retries - 1)
    end
  end

  defp get_data(module, entity, id) do
    flaky = if entity == "users", do: "", else: "?flaky=true"

    case HTTPoison.get!("#{@domain}/#{entity}/#{id}#{flaky}") do
      %HTTPoison.Response{body: body, status_code: 200} ->
        map = Poison.decode!(body)
        struct = module.from_map(map)

        {:ok, struct}

      _ ->
        {:error, "Bad"}
    end
  end
end
