defmodule CrawlerWebpageWeb.ItemsController do
  use CrawlerWebpageWeb, :controller
  alias CrawlerWebpage.CrawledItems
  alias CrawlerWebpage.CrawledItems.Items

  def index(conn, _params) do
    item = CrawledItems.list_item()|>Enum.sort_by( &(&1.crawled_at), :desc)
    render(conn, "index.html", item: item)
  end

  def new(conn, _params) do
    changeset = CrawledItems.change_items(%Items{})
    render(conn, "new.html", changeset: changeset)
  end

  def create_items(conn, attrs \\ %{}) do
    item = CrawledItems.list_item()
    render(conn, "index.html", item: item)
  end

  def create(conn, %{"items" => items_params}) do
    case CrawledItems.create_items(items_params) do
      {:ok, items} ->
        conn
        |> put_flash(:info, "Items created successfully.")
        |> redirect(to: Routes.items_path(conn, :show, items))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end



  def show(conn, %{"id" => id}) do
    items = CrawledItems.get_items!(id)
    render(conn, "show.html", items: items)
  end

  def edit(conn, %{"id" => id}) do
    items = CrawledItems.get_items!(id)
    changeset = CrawledItems.change_items(items)
    render(conn, "edit.html", items: items, changeset: changeset)
  end

  def update(conn, %{"id" => id, "items" => items_params}) do
    items = CrawledItems.get_items!(id)

    case CrawledItems.update_items(items, items_params) do
      {:ok, items} ->
        conn
        |> put_flash(:info, "Items updated successfully.")
        |> redirect(to: Routes.items_path(conn, :show, items))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", items: items, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    items = CrawledItems.get_items!(id)
    {:ok, _items} = CrawledItems.delete_items(items)

    conn
    |> put_flash(:info, "Items deleted successfully.")
    |> redirect(to: Routes.items_path(conn, :index))
  end
end
