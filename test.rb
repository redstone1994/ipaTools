require 'spaceship'
require 'open-uri'
require 'csv'


#登录
token = Spaceship::ConnectAPI::Token.create(
  key_id: '',
  issuer_id: '',
  filepath:  File.absolute_path("./.p8")
)

Spaceship::ConnectAPI.token = token
Spaceship::Tunes.login('', '')

app = Spaceship::Tunes::Application.find("")

element=app.in_app_purchases.all
iap = app.in_app_purchases.find("")
puts iap.type

# puts element.size
#
# CSV.foreach("./ss.csv", headers:true ) do |row|
#     url=row[1]
#     id= row[0]
#     puts id
#     sleep(1)
#     path_name= "./img/" + id + ".png"
#     open(url) do |u|
#       File.open(path_name, 'wb'){ |f| f.write(u.read)}
#     end
# end

# for cc in element do
#
#   id= cc.product_id
#   puts id

  # iap = app.in_app_purchases.find(cc.product_id)
  # puts iap.class
  # if iap.nil?
  #   iap = app.in_app_purchases.find(cc.product_id)
  #   puts "?????????????????????"
  #   puts iap
  # end
  # status= iap.status
  # if status == 'Approved'
  #   url=iap.edit.review_screenshot['url']
  #   puts id + ","+url
  # end


# end