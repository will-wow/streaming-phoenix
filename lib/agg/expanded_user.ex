defmodule Agg.ExpandedUser do
  alias Agg.{User, Domicile, Account}

  @type t :: %__MODULE__{
          user: User.t(),
          domicile: Domicile.t(),
          account: Account.t()
        }

  defstruct [:user, :domicile, :account]

  def to_json(%__MODULE__{user: user, domicile: domicile, account: account}) do
    %{
      user: user |> Map.from_struct(),
      domicile: domicile |> Map.from_struct(),
      account: account |> Map.from_struct()
    }
  end
end
