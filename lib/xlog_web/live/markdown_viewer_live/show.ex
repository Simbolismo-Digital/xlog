defmodule XlogWeb.MarkdownViewerLive.Show do
  use XlogWeb, :live_view

  alias Earmark
  alias Xlog.MarkdownViewers
  alias XlogWeb.MarkdownViewerLive.Functions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    md_content = MarkdownViewers.get_markdown_viewer!(id)

    {:ok, html_content, _} = Functions.as_html(md_content, gfm: true, breaks: true)

    {:noreply, assign(socket, :content, String.split(html_content, "\n", trim: true))}
  end
end
