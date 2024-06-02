defmodule XlogWeb.MarkdownViewerLive.Show do
  use XlogWeb, :live_view

  alias Earmark
  alias Xlog.MarkdownViewers


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    md_content = File.read!("content/blog/blog/content/2e7dfede-0852-4990-b4c0-3510c520dfb9/content/bec2178e-be3e-4e0d-b492-33ddef8ecb6d/README.md")
    html_content = Earmark.as_html!(md_content)

    {:noreply, assign(socket, :content, html_content)}
  end
end
