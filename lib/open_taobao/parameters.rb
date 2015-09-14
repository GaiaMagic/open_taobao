module OpenTaobao
  PARAMETERS = {
    "taobao.item.add"=>{
      "required"=>["num", "price", "type", "stuff_status", "title", "desc", "cid", "location.state", "location.city"], 
      "optional"=>["outer_id", "locality_life.choose_logis", "locality_life.merchant", "locality_life.expirydate", "approve_status",
                   "newprepay"]}, 
    "taobao.item.update"=>{
      "required"=>["num_iid"],
      "optional"=>["cid", "props", "num", "price", "title", "desc", 'location.state', 'location.city', 'post_fee', 'express_fee',
    'ems_fee', 'list_time', 'increment', 'stuff_status', 'auction_point', 'property_alias', 'input_pids', 'sku_quantities', 
    'sku_prices', 'sku_properties', 'seller_cids', 'postage_id', 'outer_id', 'product_id', 'pic_path', 'auto_fill', 'sku_outer_ids',
    'is_taobao', 'is_ex', 'is_3D', 'is_replace_sku', 'input_str', 'lang', 'has_discount', 'has_showcase', 'approve_status', 
    'freight_payer', 'valid_thru', 'has_invoice', 'has_warranty', 'after_sale_id', 'sell_promise', 'cod_postage_id', 'is_lightning_consignment',
    'weight', 'is_xinpin', 'sub_stock', 'newprepay', "locality_life.choose_logis" ]},
    "taobao.item.img.upload"=>{
      "required"=>["num_iid"],
      "optional"=>["id", "position", "is_major"]},
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
