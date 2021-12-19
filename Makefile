server:
	mix phx.server

console:
	iex -S mix phx.server

test:
	mix test

setup:
	mix deps.get
	mix ecto.setup
	mix phx.server
