defmodule Agg.Domicile do
  @type t :: %__MODULE__{
          city: String.t(),
          id: String.t(),
          postal_code: integer,
          street: String.t()
        }

  defstruct [:city, :id, :postal_code, :street]

  def from_map(%{
        "city" => city,
        "id" => id,
        "postal_code" => postal_code,
        "street" => street
      }) do
    %__MODULE__{
      city: city,
      id: id,
      postal_code: postal_code,
      street: street
    }
  end
end
