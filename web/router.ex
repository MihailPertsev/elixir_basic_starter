defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Discuss.Plugs.SetUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Discuss do
    # Use the default browser stack
    # Before any stuff with request, do preprocessing stuf with that pipeline :browser
    pipe_through(:browser)

    # get("/", TopicController, :index)
    # get("/topics/new", TopicController, :new)
    # post("/topics", TopicController, :create)
    # get("/topics/:id/edit", TopicController, :edit)
    # put("/topics/:id", TopicController, :update)
    # delete("/topics/:id", TopicController, :delete)
    get("/", TopicController, :index)
    resources("topics", TopicController, except: [:index])
  end

  scope "/auth", Discuss do
    pipe_through(:browser)

    # Order matters!!!!!
    put("/signout", AuthController, :signout)

    # We are doing /:provider instead of /github. :request function is already defined by ueberauth
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
