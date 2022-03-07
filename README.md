# Hacker News Aggregator

This is yet another [Hacker News](https://news.ycombinator.com/) aggregator. But this time built in Elixir, saving data into ETS and pooling data in batches from the [Hacker News API](https://github.com/HackerNews/API).

## Installation

Clone the repository via `git clone https://github.com/er-jpg/hn-ag`.

## Usage

**TODO: Add containers to use application**

Right now it's just possible to run the application via terminal doing the following steps

 - Enter the app folder Ex.: `cd lib/apps/ets_service`
 - Run the application with `iex` Ex.: `iex -S mix`

## Testing and code quality

To run tests just run in the root folder of the repo `mix test`. Or you can run the command inside each application in the `apps` folder individually.

The lint of code is done via [credo](https://github.com/rrrene/credo) and in the root of repo just run `mix credo`.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
