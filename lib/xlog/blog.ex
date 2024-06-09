defmodule Xlog.Blog do

  # @user_id "2e7dfede-0852-4990-b4c0-3510c520dfb9"
  # @post_1_id "bec2178e-be3e-4e0d-b492-33ddef8ecb6d"

  def url() do
    "git@github.com:Simbolismo-Digital/blog.git"
  end

  def repo_path() do
    "content/blog"
  end

  def content_path() do
    "#{repo_path()}/content"
  end

  def post_path(id) do
    "#{content_path()}/#{id}/README.md"
  end

  def post_data!(id) do
    post_path(id)
    |> File.read!()
  end

  def post_data(id, %{title: title, content: content}) do
    with path <- post_path(id),
        :ok <- Path.dirname(path) |> File.mkdir_p(),
        :ok <- File.write(path, content),
        :ok <- post_metadata(id, %{title: title}) do
          # TODO: commit
          :ok
        end
  end

  # read
  def post_metadata(id) do
    path = "#{content_path()}/#{id}/meta.json"
    with {:ok, content} <- File.read(path) do
      Jason.decode(content, keys: :atoms)
    end
  end

  # write
  def post_metadata(id, metadata) do
    path = "#{content_path()}/#{id}/meta.json"
    with {:ok, json} <- Jason.encode(metadata) do
        File.write(path, json)
      end
  end

  def repository() do
    %Git.Repository{path: "#{File.cwd!()}/#{repo_path()}"}
  end

  def clone() do
    if File.exists?(repo_path()) do
      {:ok, repository()}
    else
      Git.clone([url(), repo_path()])
    end
  end

  def pull() do
    Git.pull(repository())
  end

  ####### Work with partial data

  # def fetch() do
  #   Git.fetch(repository())
  # end

  # def checkout() do
  #   checkout(@user_id, @post_1_id)
  # end

  # def checkout(user_id, post_1_id) do
  #   Git.checkout(repository(), ["origin/main", "--", "blog/content/#{user_id}/content/#{post_1_id}"])
  # end

  # def ls_files() do
  #   with {:ok, files} <- Git.ls_tree(repository(), ["-r", "--name-only", "main", "--", "blog/content/#{@user_id}"]) do
  #     {:ok, String.split(files, "\n", trim: true)}
  #   end
  # end
end
