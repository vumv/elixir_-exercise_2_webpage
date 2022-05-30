defmodule CrawlerWebpageWeb.PageController do
  use CrawlerWebpageWeb, :controller
  use Crawly.Spider
  alias CrawlerWebpage.CrawledItems
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, params) do
    case params do
      %{"in_url" => in_url} ->
        case crawl(in_url, 10) do
          %{crawled_at: crawled_time, items: items} ->
            items
            |> Enum.map(fn item ->
              %{
                crawled_at: crawled_time,
                title: item.title,
                link: item.link,
                thumbnail: item.thumbnail,
                number_of_episode: item.number_of_episode,
                full_series: item.full_series,
                year: item.year,
                reading_page: item.reading_page
              }
              |> CrawledItems.create_items()
            end)

            IO.puts("CATEGORY URL DONE !")
            redirect(conn, to: Routes.items_path(conn, :index))
        end

      %{"in_file" => in_file} ->
        case File.read(String.trim(in_file)) do
          {:ok, file_text} ->
            IO.puts("AAAAA" <>file_text)
            url_list= String.split(file_text, "\n")
            url_list|> Enum.map(fn a_url ->
              if String.length(String.trim(a_url)) != 0 do
                case crawl(a_url, 1) do
                  %{crawled_at: crawled_time, items: items} ->
                    items
                    |> Enum.map(fn item ->
                      %{
                        crawled_at: crawled_time,
                        title: item.title,
                        link: item.link,
                        thumbnail: item.thumbnail,
                        number_of_episode: item.number_of_episode,
                        full_series: item.full_series,
                        year: item.year,
                        reading_page: item.reading_page
                      }
                      |> CrawledItems.create_items()
                    end)
                end
              end
            end)
            IO.puts("FILE DONE !")
            redirect(conn, to: Routes.items_path(conn, :index))
          _ ->
            conn |> put_flash(:info, "ERROR")
            render("index.html")
        end
      %{"out_file" => out_file} ->
        data = CrawledItems.list_item()|>Enum.sort_by( &(&1.crawled_at), :desc)
        {_status, result} = JSON.encode(data)
        File.write(out_file, result)
        conn |> put_flash(:info, "SAVED OK TO: " <> out_file)|>render("index.html")
      _ ->
        render(conn, "index.html")
    end
  end

  def get_full_series(episode_info_text) do
    String.contains?(String.downcase(episode_info_text), "full") ||
      if Enum.count(String.split(episode_info_text, "/")) == 2 do
        [left, right] = String.split(episode_info_text, "/")

        current_episode =
          String.trim(String.split(String.trim(left, " "), " ") |> List.last(), "(")

        last_episode =
          String.trim(String.split(String.trim(right, " "), " ") |> List.first(), ")")

        last_episode == current_episode
      else
        false
      end
  end

  def get_current_episode(episode_info_text) do
    current_episode =
      if Enum.count(String.split(episode_info_text, "/")) == 2 do
        [left, _right] = String.split(episode_info_text, "/")
        String.trim(String.split(String.trim(left, " "), " ") |> List.last(), "(")
      else
        String.split(String.trim(episode_info_text, " "), " ") |> Enum.at(1)
      end

    case Integer.parse(current_episode) do
      {episode_value, ""} -> episode_value
      _ -> 0
    end
  end

  def get_short_title_and_year(full_title) do
    year =
      full_title
      |> String.split("(")
      |> List.last()
      |> String.trim(" ")
      |> String.trim(")")
      |> String.trim(" ")

    case Integer.parse(year) do
      {year_value, ""} ->
        {full_title |> String.split("-") |> List.first() |> String.trim(" "), year_value}

      _ ->
        {full_title |> String.split("-") |> List.first() |> String.trim(" "), 0}
    end
  end

  def recursive_parse_page(in_page_url, in_already_items, in_start_page, in_stop_page) do
    # print the current url

    # run recurively until current page url = last page url
    if in_start_page != 0 && in_start_page < in_stop_page && String.contains?(in_page_url, "http") do
      IO.puts(in_page_url)

      # some website is aguard from ddos by maximum 20 requests/ seconds
      # below code is delay every 20 requests
      if Integer.mod(in_start_page, 20) === 0 do
        :timer.sleep(1000)
      end

      response = Crawly.fetch(in_page_url)
      {:ok, document} = Floki.parse_document(response.body)

      items =
        Floki.find(document, "a.movie-item")
        |> Enum.map(fn
          {_, [_, {_, href}, {_, title}], [{_, _, [{_, _, thumb}, {_, _, meta}]}]} ->
            [{_, [_, {_, thumb_image}], _}] = thumb
            [_, image, _] = String.split(thumb_image, "'")
            {_, _, meta_episode} = List.last(meta)
            meta_episode_info = List.last(meta_episode)
            episode_is_tuple = is_tuple(meta_episode_info)

            episode_info_text =
              if episode_is_tuple do
                Tuple.to_list(meta_episode_info) |> List.last() |> List.last()
              else
                meta_episode_info
              end

            full_series = get_full_series(episode_info_text)
            number_of_episode = get_current_episode(episode_info_text)

            {short_title, year} =
              String.split(title, "\n")
              |> List.first()
              |> String.trim("\t")
              |> get_short_title_and_year()

            %{
              title: short_title,
              link: href,
              thumbnail: image,
              number_of_episode: number_of_episode,
              full_series: full_series,
              year: year,
              reading_page: in_start_page
            }
        end)

      in_already_items = in_already_items ++ items

      [{_, _, pagination}] = Floki.find(document, "ul.pagination")
      {_, _, [{_, [_, {_, next_page_url}], _}]} = List.last(pagination)

      in_start_page =
        if in_page_url == next_page_url || String.contains?(next_page_url, "http") !== true do
          0
        else
          in_start_page + 1
        end

      # loop with url = ext_page_url
      recursive_parse_page(next_page_url, in_already_items, in_start_page, in_stop_page)
    else
      # end for getting data recursively
      %{
        crawled_at: to_string(DateTime.utc_now()),
        total: Enum.count(in_already_items),
        items: in_already_items
      }

      # {_status, result} = JSON.encode(out_items)
      # file_path = Path.expand("./result_data.json")
      # File.write(file_path, result)
    end
  end

  def crawl(url, max_of_pages) do
    already_items = []
    start_page = 1

    max_of_pages =
      if  max_of_pages > 0 && max_of_pages <= 10 do
        max_of_pages
      else
        10
      end

    stop_page = start_page + max_of_pages

    url =
      if String.last(String.trim(url)) == "/" do
        url
      else
        String.trim(url) <> "/"
      end

     recursive_parse_page(url, already_items, start_page, stop_page)
  end
end
