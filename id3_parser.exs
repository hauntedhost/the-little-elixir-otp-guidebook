defmodule Id3Parser do
  @id3_tag_size 128

  # note: this can only parse mp3 files with id3 in v1 format
  def parse(file_name) do
    case File.read(file_name) do
      {:ok, mp3} ->

        # mp3 size minus 128 bytes where id3 tag is located
        mp3_byte_size = byte_size(mp3) - @id3_tag_size

        # pattern match mp3 binary to capture id3_tag
        << _ :: binary-size(mp3_byte_size), id3_tag :: binary >> = mp3

        # pattern match components of id3_tag
        << "TAG",
           raw_title    :: binary-size(30),
           raw_artist   :: binary-size(30),
           raw_album    :: binary-size(30),
           raw_year     :: binary-size(4),
           raw_comment  :: binary-size(30),
           _            :: binary >> = id3_tag

        # trim unprintable characters
        [title, artist, album, year] = trim([raw_title, raw_artist, raw_album, raw_year])

        IO.puts "#{artist} - #{title} (#{album}, #{year})"

      _ ->
        IO.puts "Couldn't open #{file_name}"
    end
  end

  defp trim([string | rest]) do
    [trim(string) | trim(rest) ]
  end

  defp trim([]), do: []

  defp trim(string) do
    String.split(string, <<0>>) |> List.first
  end
end
