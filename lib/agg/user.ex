defmodule Agg.User do
  @type t :: %__MODULE__{
          account_id: String.t(),
          base64_encoded_avatar: String.t(),
          domicile_id: String.t(),
          first_name: String.t(),
          id: String.t(),
          last_name: String.t()
        }

  defstruct [:account_id, :base64_encoded_avatar, :domicile_id, :first_name, :id, :last_name]

  def from_map(%{
        "account_id" => account_id,
        "base64_encoded_avatar" => base64_encoded_avatar,
        "domicile_id" => domicile_id,
        "first_name" => first_name,
        "id" => id,
        "last_name" => last_name
      }) do
    %__MODULE__{
      account_id: account_id,
      base64_encoded_avatar: base64_encoded_avatar,
      domicile_id: domicile_id,
      first_name: first_name,
      id: id,
      last_name: last_name
    }
  end
end
