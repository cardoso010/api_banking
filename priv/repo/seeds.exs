# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ApiBanking.Repo.insert!(%ApiBanking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, admin} =
  ApiBanking.Users.Mutator.create(%{
    name: "Admin",
    email: "admin@admin.com",
    password: "admin"
  })

admin
|> ApiBanking.Accounts.Mutator.create_with_assoc()

{:ok, user1} =
  ApiBanking.Users.Mutator.create(%{
    name: "User1",
    email: "user1@user1.com",
    password: "user1"
  })

user1
|> ApiBanking.Accounts.Mutator.create_with_assoc()
