defmodule EtsService.Schemas.Story do
  @moduledoc """
  Defines the struct to the data to be inserted on the ETS ubder the :stories table.

  The most important field is the _id_, used as a key in the table.
  """
  defstruct [
    :by,
    :descendants,
    :id,
    :kids,
    :score,
    :time,
    :title,
    :type,
    :url
  ]

  @type t :: %__MODULE__{
          by: String.t(),
          descendants: integer(),
          id: integer(),
          kids: list(integer()),
          score: integer(),
          time: integer(),
          title: String.t(),
          type: String.t(),
          url: String.t()
        }
end
