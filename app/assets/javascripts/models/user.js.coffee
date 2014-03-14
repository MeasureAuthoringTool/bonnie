class Thorax.Models.User extends Thorax.Model
  idAttribute: '_id'
  approve: -> $.ajax(url: "#{@url()}/approve", type: "POST").done (data) => @set(data)
  disable: -> $.ajax(url: "#{@url()}/disable", type: "POST").done (data) => @set(data)

class Thorax.Collections.Users extends Thorax.Collection
  url: '/admin/users'
  model: Thorax.Models.User
