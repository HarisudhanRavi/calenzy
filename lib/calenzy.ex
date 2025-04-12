defmodule Calenzy do
  @moduledoc """
  Calenzy keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @spec get_date_range(binary(), binary()) ::
          {{:error, :invalid_year_or_month} | Date.t(), Date.t()}
  def get_date_range(year, month) do
    year = String.to_integer(year)
    month = String.to_integer(month)

    {Timex.beginning_of_month(year, month), Timex.end_of_month(year, month)}
  end
end
