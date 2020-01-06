defmodule ApiBank.Guardian.AuthPipeline do
  @moduledoc """
  The AccountService context.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :api_bank,
    module: ApiBank.Guardian,
    error_handler: ApiBank.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
