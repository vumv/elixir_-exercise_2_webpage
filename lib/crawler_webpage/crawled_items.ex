defmodule CrawlerWebpage.CrawledItems do
  @moduledoc """
  The CrawledItems context.
  """

  import Ecto.Query, warn: false
  alias CrawlerWebpage.Repo

  alias CrawlerWebpage.CrawledItems.Items

  @doc """
  Returns the list of item.

  ## Examples

      iex> list_item()
      [%Items{}, ...]

  """
  def list_item do
    Repo.all(Items)
  end

  @doc """
  Gets a single items.

  Raises `Ecto.NoResultsError` if the Items does not exist.

  ## Examples

      iex> get_items!(123)
      %Items{}

      iex> get_items!(456)
      ** (Ecto.NoResultsError)

  """
  def get_items!(id), do: Repo.get!(Items, id)

  @doc """
  Creates a items.

  ## Examples

      iex> create_items(%{field: value})
      {:ok, %Items{}}

      iex> create_items(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_items(attrs \\ %{}) do
    %Items{}
    |> Items.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a items.

  ## Examples

      iex> update_items(items, %{field: new_value})
      {:ok, %Items{}}

      iex> update_items(items, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_items(%Items{} = items, attrs) do
    items
    |> Items.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a items.

  ## Examples

      iex> delete_items(items)
      {:ok, %Items{}}

      iex> delete_items(items)
      {:error, %Ecto.Changeset{}}

  """
  def delete_items(%Items{} = items) do
    Repo.delete(items)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking items changes.

  ## Examples

      iex> change_items(items)
      %Ecto.Changeset{data: %Items{}}

  """
  def change_items(%Items{} = items, attrs \\ %{}) do
    Items.changeset(items, attrs)
  end
end
