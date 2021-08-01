# Renraku

This is a Phoenix web application written in response to a code challenge as part of a recruitment process.
The application provides the ability to store contact data in the scope of an ID (`case_id`).
The code name of the project comes from Japanese _renraku_ (連絡 _renraku_, 'connection, contact') because
as the Ruby ecosystem shows, Japanese words make for great project names.

## Up and running

The application was developed on arm64 macOS 11.5, with PostgreSQL 13.3, Elixir 1.12.2, and Erlang 24.
Node is required to run Webpack and compile CSS, but as explicitly stated in the code challenge description,
no JavaScript is used in the browser.

A simple `docker-compose.yml` is provided with the project in case you don't want to clutter your OS.
You can disable JWT authentication in dev by running the server with the environment variable `DISABLE_AUTH=true`.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `yarn install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## A Few Sentences About Deployment

The application can be deployed as a release, either baked into a Docker image or executed as a Linux binary
plugged into a systemd supervision tree.

If you deploy using Docker, you would need to compile a release of the application inside a Docker container.
This is quite an involved process. You will likely need to build with several intermediate containers because of the following reasons:

- the base application is based on an Elixir image,
- you may need to install OS packages inside the build container to compile NIFs (think: `crypto`, `bcrypt`, binary DB drivers),
- but for the Webpack step, you still need to use a node image, which becomes unnecessary after the build,
- you don't keep the whole content of the application repository or build artifacts around, just the Elixir release and a lightweight OS environment to run it.

You can then run the Dockerized release on any compatible machine, including any Linux server, a Kubernetes pod,
or a hosted Docker service like AWS Fargate. The container can be deployed in isolation (providing no-downtime
Blue/Green deployments). When running in Docker, it is difficult or downright to connect BEAM nodes into clusters,
meaning no distributed Phoenix PubSub (correct me if I'm wrong).

Running an application from a supervision tree is an easy solution
if you want to run several services on a single machine. For deployment, you could build release tarballs
in a CI/CD pipeline and upload them to an artifact store, then use a deployment agent like CodeDeploy to
extract the release to a specific directory and restart the service. You can put the application behind
an Nginx reverse proxy to handle TLS support, to listen on a port <1000, and to provide friendly error
pages during downtime and deployments. Although it is possible to handle HTTP(S) traffic using just Cowboy,
(for port forwarding you can use iptables rules), it works best if you are running behind a load balancer.

For configuration, you can use environment variables passed to the container by Kubernetes,
or values stored in AWS Secrets Manager, which you would put in place using Terraform.
