defmodule Cumbuca.Common do
  @moduledoc false
  alias __MODULE__.ExternalToInternal

  defdelegate external_to_internal(atom, element), to: ExternalToInternal, as: :call
end
