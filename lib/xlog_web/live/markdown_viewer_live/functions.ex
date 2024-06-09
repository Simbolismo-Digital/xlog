defmodule XlogWeb.MarkdownViewerLive.Functions do
  @moduledoc """
  Documentation for Templating render.

  See https://github.com/jdanielnd/eex_markdown
  """

  defmodule Implementation do
    def youtube(video_id, width \\ 640, height \\ 360) do
      "<iframe id=\"youtube-player\" type=\"text/html\" width=\"#{width}\" height=\"#{height}\" src=\"http://www.youtube.com/embed/#{video_id}?autoplay=1\" frameborder=\"0\"></iframe>"
    end
  end

  @doc """
  Extends Earmark to support EEx parsing
  """
  def as_html(lines, options \\ %Earmark.Options{}) do
    lines
    |> EEx.eval_string([],
      functions: [{__MODULE__.Implementation, __MODULE__.Implementation.__info__(:functions)}]
    )
    |> Earmark.as_html(options)
  end
end
