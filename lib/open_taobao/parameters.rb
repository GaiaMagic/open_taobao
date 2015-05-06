module OpenTaobao
  PARAMETERS = {
    "taobao.item.add"=>{
      "required"=>["num", "price", "type", "stuff_status", "title", "desc", "cid", "location.state", "location.city"], 
      "optional"=>["outer_id", "locality_life.choose_logis", "locality_life.merchant", "locality_life.expirydate", "image", "approve_status"]}, 
    "taobao.item.sku.add"=>{
      "required"=>["num_iid", "properties", "quantity", "price"], 
      "optional"=>["outer_id", "item_price", "lang", "spec_id", "sku_hd_length", "sku_hd_height", "sku_hd_lamp_quantity", "ignorewarning", "pic_path"]}, 
    "taobao.vmarket.eticket.consume"=>{
      "required"=>["order_id", "verify_code", "consume_num", "token"], 
      "optional"=>["codemerchant_id", "posid", "mobile", "new_code", "serial_num", "qr_images"]}, 
    "taobao.vmarket.eticket.send"=>{
      "required"=>["order_id", "verify_codes", "token"],
      "optional"=>["codemerchant_id", "qr_images"]}, 
    "taobao.vmarket.eticket.resend"=>{
      "required"=>["order_id", "verify_codes", "token"], 
      "optional"=>["codemerchant_id", "qr_images"]},
    "taobao.vmarket.eticket.qrcode.upload"=>{
      "required"=>["code_merchant_id"], 
      "optional"=>[""]}, 
    "taobao.vmarket.eticket.reverse"=>{
      "required"=>["order_id", "reverse_code", "reverse_num", "consume_secial_num", "token"], 
      "optional"=>["verify_codes", "qr_images", "codemerchant_id", "posid"]},
    }
end
