defmodule Agg.Account do
  @type t :: %__MODULE__{
          balance: float,
          id: String.t()
        }

  defstruct [:balance, :id]

  def from_map(%{"balance" => balance, "id" => id}) do
    %__MODULE__{
      balance: balance,
      id: id
    }
  end
end
