defmodule CrawlerWebpage.CrawledItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlerWebpage.CrawledItems` context.
  """

  @doc """
  Generate a items.
  """
  def items_fixture(attrs \\ %{}) do
    {:ok, items} =
      attrs
      |> Enum.into(%{
        crawled_at: "some crawled_at",
        full_series: true,
        link: "some link",
        number_of_episode: 42,
        thumbnail: "some thumbnail",
        title: "some title",
        year: 42
      })
      |> CrawlerWebpage.CrawledItems.create_items()

    items
  end
end
