defmodule DataService.Repo.Migrations.CreateStoryLogTable do
  use Ecto.Migration

  def up do
    create table(:stories, primary_key: false) do
      add(:id, :uuid, primary_key: false)
      add(:ref, :integer, null: false)
      add(:by, :string, null: false)
      add(:descendants, :integer)
      add(:kids, :map)
      add(:score, :integer, null: false)
      add(:time, :naive_datetime, null: false)
      add(:title, :string, null: false)
      add(:type, :string, null: false)
      add(:url, :string)

      timestamps()
    end

    create unique_index(:stories, [:ref])
  end

  def down do
    drop table(:stories)
  end
end
