defmodule Calenzy do
  @moduledoc """
  Calenzy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @spec build_month_calendar(integer(), pos_integer()) :: [list()]
  def build_month_calendar(year, month) do
    first = Timex.beginning_of_month(year, month)
    last = Timex.end_of_month(year, month)

    all_days = Date.range(first, last) |> Enum.to_list()

    # Pad the start (if the month doesn't start on Sunday)
    # Sunday = 0
    start_padding = rem(Date.day_of_week(first), 7)
    padded_start = List.duplicate(nil, start_padding) ++ all_days

    # Pad the end (if the last week is incomplete)
    end_padding = rem(7 - rem(length(padded_start), 7), 7)
    padded = padded_start ++ List.duplicate(nil, end_padding)

    # Chunk into weeks (rows of 7 days)
    Enum.chunk_every(padded, 7)
  end
end
