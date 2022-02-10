require 'spaceship'
require 'open-uri'


#登录
token = Spaceship::ConnectAPI::Token.create(
  key_id: '',
  issuer_id: '',
  filepath:  File.absolute_path("./.p8") #.p8证书文件
)

Spaceship::ConnectAPI.token = token
Spaceship::Tunes.login('', '')

app = Spaceship::Tunes::Application.find("")

element=app.in_app_purchases.all
puts element.size
time = 1

for cc in element do
  if time%50 == 0
    sleep(10)
  end
  if not cc.nil?

    iap = app.in_app_purchases.find(cc.product_id)
    if iap.nil?
      iap = app.in_app_purchases.find(cc.product_id)
    end
    status= iap.status
    reference_name = iap.reference_name

    if status == "Approved"
      puts "#{reference_name+"-" +cc.product_id + "-" +status + " start download"+ time.to_s}"

      review_screenshot = iap.edit.review_screenshot
      puts review_screenshot
      img_url = review_screenshot['url']
      puts img_url
      path_name= "./img/" + cc.product_id + ".png"
      # sleep(rand(2..4))

      open(img_url) do |u|
        File.open(path_name, 'wb'){ |f| f.write(u.read)}
      end
      time = time+ 1

    else
      puts "#{reference_name + status + " skip"}"
    end
  end
end