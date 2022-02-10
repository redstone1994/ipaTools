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
def create_iap(app=nil, iapMode)

  # iapType = iapMode["type"]
  tier = iapMode["tier"]
  product_name = iapMode["name"]
  product_id = iapMode["id"]
  description = iapMode["describe"]
  img = iapMode["img"]
  puts "start create iap:"
  puts iapMode

  app.in_app_purchases.create!(
    type: Spaceship::Tunes::IAPType::NON_RENEW_SUBSCRIPTION,
    versions: {
      'zh-Hans' => {
        name: product_name,
        description: description
      }
    },
    reference_name: product_name,
    product_id: product_id,
    cleared_for_sale: true,
    review_notes: description,
    review_screenshot: img,
    pricing_intervals:
      [
        {
          country: "WW",
          begin_date: nil,
          end_date: nil,
          tier: tier
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

# 开始创建ipa商品
def create_iap_demo(app = nil, filePath)
  #解析csv得到内购商品
  p_array = parase_csv_file(filePath)

  #遍历创建商品
  mode = Hash.new
  for mode in p_array do
    create_iap(app, mode)
  end

end

create_iap_demo(app, './course.csv')
