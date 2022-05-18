defmodule DataService.Schemas.Story do
  @moduledoc """
  Defines the struct to the data to be inserted on the ETS ubder the :stories table.

  The most important field is the _ref_id_, used as a key in the table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @params ~w(by descendants ref kids score time title type url)a
  @required_params ~w(by ref score time title type)a

  schema "stories" do
    field(:by, :string)
    field(:descendants, :integer)
    field(:ref, :integer)
    field(:kids, {:array, :integer})
    field(:score, :integer)
    field(:time, :naive_datetime)
    field(:title)
    field(:type)
    field(:url)

    timestamps()
  end

  def changeset(changeset \\ %__MODULE__{}, params) do
    changeset
    |> cast(params, @params)
    |> validate_required(@required_params)
    |> unique_constraint(:ref)
  end

  def apply(changeset) do
    apply_changes(changeset)
  end
end
