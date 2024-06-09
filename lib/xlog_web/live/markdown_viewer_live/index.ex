defmodule XlogWeb.MarkdownViewerLive.Index do
  use XlogWeb, :live_view

  alias Xlog.MarkdownViewers
  alias Xlog.MarkdownViewers.MarkdownViewer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :markdown_viewer_collection, MarkdownViewers.list_markdown_viewer())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Publicação")
    |> assign(:markdown_viewer, MarkdownViewers.get_markdown_viewer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nova Publicação")
    |> assign(:markdown_viewer, %MarkdownViewer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Publicações")
    |> assign(:markdown_viewer, nil)
  end

  @impl true
  def handle_info({XlogWeb.MarkdownViewerLive.FormComponent, {:saved, markdown_viewer}}, socket) do
    {:noreply, stream_insert(socket, :markdown_viewer_collection, markdown_viewer, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    markdown_viewer = MarkdownViewers.get_markdown_viewer!(id)
    {:ok, _} = MarkdownViewers.delete_markdown_viewer(markdown_viewer)

    {:noreply, stream_delete(socket, :markdown_viewer_collection, markdown_viewer)}
  end
end
