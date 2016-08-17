defmodule Jodelx.JodelStream do
  import Ecto.Query
  
  def start_fun do
    from p in Jodelx.Post, select: p
  end

  def next_fun(acc) do
    
  end
end
