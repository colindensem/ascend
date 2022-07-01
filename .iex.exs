Application.put_env(:elixir, :ansi_enabled, true)

import_if_available(Ecto.Query)

alias AscendWeb.Router.Helpers, as: Routes
alias Ascend.{Hills}

#
# Routes.__info__(:functions)
