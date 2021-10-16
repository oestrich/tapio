{:ok, _user} =
  Tapio.Users.create(%{
    username: "kullervo",
    password: "password",
    password_confirmation: "password"
  })

{:ok, _user} =
  Tapio.Users.create(%{
    username: "louhi",
    password: "password",
    password_confirmation: "password"
  })
