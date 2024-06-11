defmodule Xlog.Posts do

  alias Xlog.Blog

  def list_posts(max, page) do
    Blog.get_contents(posts_path(), max, max * page)
    |> Blog.checkout()
    |> Enum.map(&get_index_from_file/1)
    |> Enum.sort_by(& &1.inserted_at, :desc)
    |> dbg()
  end

  def get_post!(id) do
    File.read!("#{repo_path()}/#{post_root_path(id)}/README.md")
  end


  def create_post(%{id: id, content: content, metadata: metadata}) do
    root_relative_path = post_root_path(id)
    root_full_path = "#{repo_path()}/#{root_relative_path}"

    with :ok <- File.mkdir_p(root_full_path),
         :ok <- create_post_readme(root_full_path, content),
         :ok <- create_post_metadata(root_full_path, metadata),
         :ok <- Blog.commit_and_merge(root_relative_path, "add post/#{id} #{metadata.title}") do
      :ok
    end
  end

  defp get_index_from_file(path) do
    id = Path.basename(path)
    {:ok, creation_time} = Blog.creation_time(path)
    {:ok, metadata} = get_post_metadata(id)

    %Xlog.MarkdownViewers.MarkdownViewer{
      id: id,
      title: metadata.title,
      metadata: metadata,
      inserted_at: creation_time,
      updated_at: creation_time
    }
  end

  defp get_post_metadata(id) do
    path = "#{repo_path()}/#{post_root_path(id)}/meta.json"

    with {:ok, content} <- File.read(path) do
      Jason.decode(content, keys: :atoms)
    end
  end

  defp create_post_readme(full_path, content) do
    File.write("#{full_path}/README.md", content)
  end

  defp create_post_metadata(full_path, metadata) do
    with {:ok, json} <- Jason.encode(metadata) do
      File.write("#{full_path}/meta.json", json)
    end
  end

  defp repo_path() do
    Xlog.Blog.repo_path()
  end

  defp posts_path() do
    "posts"
  end

  defp post_root_path(id) do
    "#{posts_path()}/#{id}"
  end
end
