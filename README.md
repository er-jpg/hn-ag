# Hacker News Aggregator

This is yet another [Hacker News](https://news.ycombinator.com/) aggregator. But this time built in Elixir, saving data into ETS and pooling data in batches from the [Hacker News API](https://github.com/HackerNews/API).

## Installation

Clone the repository via `git clone https://github.com/er-jpg/hn-ag`.

## Usage

Set up the `SECRET_KEY_BASE` env with

```bash
export SECRET_KEY_BASE=$(elixir --eval 'IO.puts(:crypto.strong_rand_bytes(64) |> Base.encode64(padding: false))')
```

When running the application from a container the following steps
 - build the image with `docker build -t hn .` from the root of the directory
 - run the image using `docker run -p 4000:4000 --net hn_ag_default -e SECRET_KEY_BASE=$SECRET_KEY_BASE hn start`
 - ping `localhost:4000/health` to check the app status

---

Running the application via terminal use the following steps

 - Enter the app folder Ex.: `cd lib/apps/http_service`
 - Run the application with `iex` Ex.: `iex -S mix`

## Testing and code quality

### Testing
To run tests just run in the root folder of the repo `mix test`. Or you can run the command inside each application in the `apps` folder individually.

### Test coverage
When checking test coverage you can just run `MIX_ENV=test mix coveralls -u`. Plase note to use the `-u` flag when running from the root directory.

### Lint
The lint of code is done via [credo](https://github.com/rrrene/credo) and in the root of repo just run `mix credo`.


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
