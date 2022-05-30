defmodule CrawlerWebpage.Repo do
  use Ecto.Repo,
    otp_app: :crawler_webpage,
    adapter: Ecto.Adapters.Postgres
end
