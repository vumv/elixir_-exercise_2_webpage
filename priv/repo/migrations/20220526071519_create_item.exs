defmodule CrawlerWebpage.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :crawled_at, :string
      add :title, :string
      add :link, :string
      add :thumbnail, :string
      add :number_of_episode, :integer
      add :year, :integer
      add :full_series, :boolean, default: false, null: false

      timestamps()
    end
  end
end
