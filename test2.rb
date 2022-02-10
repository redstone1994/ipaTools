require 'spaceship'
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

#创建内购商品
def create_iap(app=nil)

  puts "start create iap:"

  app.in_app_purchases.create!(
    type: Spaceship::Tunes::IAPType::NON_RENEW_SUBSCRIPTION,
    versions: {
      'zh-Hans' => {
        name: "测试课程s",
        description: "dasdadada"
      }
    },
    reference_name: "测试课程s",
    product_id: "adaddddad",
    cleared_for_sale: true,
    review_notes: "dadadadaffasdsa",
    review_screenshot: "./img/course_rcg93719s.png",
    pricing_intervals:
      [
        {
          country: "WW",
          begin_date: nil,
          end_date: nil,
          tier: 32
        }
      ]
  )
end

# 解析 csv 文件，返回 商品信息 数组
def parase_csv_file(filePath)
  #数组用于存放解析过后的商品对象
  m_array = []

  #按行读取csv文件，并存放到数组中 #encoding: "ISO8859-1:utf-8"
  CSV.foreach(filePath, headers:true) do |row|
    #hash 对象，用于存放每一个商品的信息
    m_map = Hash.new

    # 获取所需数据
    m_productName = row[0]
    m_productID = row[3]
    m_old_productID = row[2]
    # m_type = row[3]
    m_price = row[1]
    # type= Spaceship::Tunes::IAPType::READABLE_NON_RENEWING_SUBSCRIPTION
    # key-value 设置
    m_map["name"] = m_productName
    m_map["id"] = m_productID
    # m_map["type"] = type
    m_map["tier"] = m_price
    m_map["describe"] = "《"+m_productName+"》课程"
    m_map["img"] = "./img/"+ m_old_productID+".png"

    m_array << m_map
  end

  return m_array

end

create_iap(app)

