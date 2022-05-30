defmodule CrawlerWebpage.CrawledItems.Items do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field :crawled_at, :string
    field :full_series, :boolean, default: false
    field :link, :string
    field :number_of_episode, :integer
    field :thumbnail, :string
    field :title, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(items, attrs) do
    items
    |> cast(attrs, [:crawled_at, :title, :link, :thumbnail, :number_of_episode, :year, :full_series])
    |> validate_required([:crawled_at, :title, :link, :thumbnail, :number_of_episode, :year, :full_series])
  end
end
