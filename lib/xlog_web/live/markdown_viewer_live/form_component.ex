defmodule XlogWeb.MarkdownViewerLive.FormComponent do
  use XlogWeb, :live_component

  alias Xlog.MarkdownViewers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage markdown_viewer records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="markdown_viewer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Markdown viewer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{markdown_viewer: markdown_viewer} = assigns, socket) do
    changeset = MarkdownViewers.change_markdown_viewer(markdown_viewer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"markdown_viewer" => markdown_viewer_params}, socket) do
    changeset =
      socket.assigns.markdown_viewer
      |> MarkdownViewers.change_markdown_viewer(markdown_viewer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"markdown_viewer" => markdown_viewer_params}, socket) do
    save_markdown_viewer(socket, socket.assigns.action, markdown_viewer_params)
  end

  defp save_markdown_viewer(socket, :edit, markdown_viewer_params) do
    case MarkdownViewers.update_markdown_viewer(socket.assigns.markdown_viewer, markdown_viewer_params) do
      {:ok, markdown_viewer} ->
        notify_parent({:saved, markdown_viewer})

        {:noreply,
         socket
         |> put_flash(:info, "Markdown viewer updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_markdown_viewer(socket, :new, markdown_viewer_params) do
    case MarkdownViewers.create_markdown_viewer(markdown_viewer_params) do
      {:ok, markdown_viewer} ->
        notify_parent({:saved, markdown_viewer})

        {:noreply,
         socket
         |> put_flash(:info, "Markdown viewer created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
