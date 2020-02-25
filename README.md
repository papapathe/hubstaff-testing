# Webhooks

The most simple project management tool in the world for which we're going to develop
a webhook delivery system.

It doesn't even have authorization 😱.

## Dependencies

* ruby-2.6.3
* postgres-9.6+

## Installation

Create `database.yaml` by duplicating `config/database.yml.example`.
Then adjust the config to match your development environment.

Run the following commands.

```bash
bundle install
bundle exec rails db:drop db:setup
```

Let's make sure everything is ready.

```bash
bundle exec rspec
```

You're good to go. Happy coding 🤘!

![](happy-coding.gif)
