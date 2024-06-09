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
    "#{content_path()}/#{id}"
  end

  def post_data_path(id) do
    "#{post_path(id)}/README.md"
  end

  def post_data!(id) do
    post_data_path(id)
    |> File.read!()
  end

  def post_data(id, %{title: title, content: content}) do
    with path <- post_data_path(id),
         :ok <- Path.dirname(path) |> File.mkdir_p(),
         :ok <- File.write(path, content),
         :ok <- post_metadata(id, %{title: title}) do
        #  :ok <- commit_post(id, title) do
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
    if File.exists?(content_path()) do
      {:ok, repository()}
    else
      with {:ok, _repo} <- Git.clone(["--no-checkout", url(), repo_path()]) do
        Git.reset(repository(), ["--hard"])
      end
    end
  end

  def fetch() do
    Git.fetch(repository(), ["origin", "main"])
  end

  def checkout(paths) do
    with {:ok, _} <- Git.checkout(repository(), ["origin/main", "--"] ++ paths) do
      paths
    end
  end

  def commit_post(id, title) do
    with {:ok, _} <- Git.add(repository(), "content/#{id}"),
      {:ok, _} <- Git.commit(repository(), "-m add post/#{id} #{title}") do
        # Git.pull(repository(), "--rebase")
      # {:ok, _} <- Git.push(repository()) do
        :ok
      end
  end

  def ls_files() do
    repository()
    |> Git.ls_tree(["main", "--", "content/"])
    |> split!()
  end

  def posts(max \\ 10, skip \\ 0) do
    repository = repository()

    case log(repository, "content", max, skip) do
      [] ->
        []

      commit_hashes ->
        commit_hashes
        |> commit_pair()
        |> diff_name_only!(repository)
        |> post_paths()
    end
  end

  # git log --max-count=2 --skip=0 --pretty=format:'%H | %aI | %s' --date=format-local:%Y-%m-%dT%H:%M:%S%z --relative=content --no-merges origin/main
  # git log --max-count=2 --skip=0 --pretty=format:%H --relative=content --no-merges origin/main
  def log(repository, resource \\ "content", max \\ 10, skip \\ 0) do
    repository
    |> Git.log([
      "--pretty=format:%H",
      "--max-count=#{max+1}",
      "--skip=#{skip}",
      "--relative=#{resource}",
      "origin/main",
      "--no-merges"
    ])
    |> split!()
  end

  defp commit_pair(commit_hashes) do
    "#{List.first(commit_hashes)}..#{List.last(commit_hashes)}"
  end

  def diff_name_only!(commit_pair, repository) do
    repository
    |> Git.diff(["--name-only", commit_pair])
    |> split!()
  end

  defp split!({:ok, infos}) do
    String.split(infos, "\n", trim: true)
  end

  defp post_paths(files) do
    files
    |> Enum.map(&Path.dirname/1)
    |> Enum.uniq()
    |> filter_content_uuid()
  end

  defp filter_content_uuid(paths) do
    Enum.filter(paths, & Regex.match?(~r/^content\/[0-9a-fA-F-]{36}$/, &1))
  end
end
